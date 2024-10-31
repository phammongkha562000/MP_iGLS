import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';

part 'stock_count_event.dart';
part 'stock_count_state.dart';

class StockCountBloc extends Bloc<StockCountEvent, StockCountState> {
  final _stockCountRepo = getIt<StockCountRepository>();
  final _todoRepo = getIt<ToDoTripRepository>();
  StockCountBloc() : super(StockCountInitial()) {
    on<StockCountSave>(_mapSaveToState);
    on<StockCountViewLoaded>(_mapViewLoadedToState);
    on<DeleteStockCount>(_mapDeleteToState);
  }
  Future<void> _mapSaveToState(StockCountSave event, emit) async {
    try {
      final currentState = state;

      if (currentState is StockCountSuccess) {
        emit(StockCountLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = AddStockCountRequest(
            contactCode: userInfo.defaultClient ?? '',
            dcCode: userInfo.defaultCenter ?? '',
            countCode:
                DateFormat(constants.formatyyyyMMdd).format(DateTime.now()),
            createUser: userInfo.userId ?? '',
            round: event.round,
            locCode: event.locCode,
            itemCode: event.itemCode,
            yyyymm: event.yyyymm,
            qty: event.quantity,
            remark: event.memo,
            companyId: userInfo.subsidiaryId ?? '',
            uom: event.uom);
        final apiResultAdd =
            await _stockCountRepo.addStockCount(content: content);
        if (apiResultAdd.isFailure) {
          emit(StockCountFailure(
              message: apiResultAdd.getErrorMessage(),
              errorCode: apiResultAdd.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResultAdd.data;
        if (apiResponse.isSuccess != true) {
          emit(const StockCountFailure(message: strings.messError));
          emit(currentState);

          return;
        }
        final apiResultGetSC =
            await _getStockCount(round: event.round, userInfo: userInfo);
        if (apiResultGetSC.isFailure) {
          emit(StockCountFailure(
              message: apiResultGetSC.getErrorMessage(),
              errorCode: apiResultGetSC.errorCode));
          return;
        }
        List<StockCountResponse> apiStockCount = apiResultGetSC.data;
        apiStockCount.sort((a, b) => b.id!.compareTo(a.id!));
        double totalQty = 0;
        for (var e in apiStockCount) {
          totalQty += e.qty!;
        }
        emit(currentState.copyWith(
          saveSuccess: true,
          stockCountList: apiStockCount,
          round: event.round,
          totalQty: totalQty,
        ));
      }
    } catch (e) {
      emit(const StockCountFailure(message: strings.messError));
    }
  }

  Future<void> _mapViewLoadedToState(StockCountViewLoaded event, emit) async {
    try {
      final currentState = state;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      if (currentState is StockCountSuccess) {
        // emit(StockCountLoading());
        final apiResultGetSC = await _getStockCount(
          userInfo: userInfo,
          round: event.round,
        );
        if (apiResultGetSC.isFailure) {
          emit(StockCountFailure(
              message: apiResultGetSC.getErrorMessage(),
              errorCode: apiResultGetSC.errorCode));
          return;
        }
        List<StockCountResponse> apiStockCount = apiResultGetSC.data;
        apiStockCount.sort((a, b) => b.id!.compareTo(a.id!));
        double totalQty = 0;
        for (var e in apiStockCount) {
          totalQty += e.qty!;
        }
        emit(currentState.copyWith(
            stockCountList: apiStockCount,
            round: event.round,
            totalQty: totalQty,
            saveSuccess: false,
            deleteSucess: false));
        return;
      }
      emit(StockCountLoading());

      final apiResultGetSC = await _getStockCount(
        round: event.round,
        userInfo: userInfo,
      );
      if (apiResultGetSC.isFailure) {
        emit(StockCountFailure(
            message: apiResultGetSC.getErrorMessage(),
            errorCode: apiResultGetSC.errorCode));
        return;
      }
      List<StockCountResponse> apiStockCount = apiResultGetSC.data;
      apiStockCount.sort((a, b) => b.id!.compareTo(a.id!));

      //******List Location */
      List<LocationStockCountResponse> listLocation =
          event.generalBloc.listLocation;
      if (listLocation.isEmpty || listLocation == []) {
        ApiResult apiLocResult = await _stockCountRepo.getLocation(
          dcCode: userInfo.defaultCenter ?? '',
          locRole: '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );

        if (apiLocResult.isFailure) {
          emit(InventoryFailure(
              message: apiLocResult.getErrorMessage(),
              errorCode: apiLocResult.errorCode));
          return;
        }
        listLocation = apiLocResult.data;
        event.generalBloc.listLocation = apiLocResult.data;
        log('resave list location');
      }

      //******List ItemCode */
      List<ItemCodeResponse> listItemCode = event.generalBloc.listItemCode;
      if (listItemCode.isEmpty || listItemCode == []) {
        ApiResult apiItemCodeResult = await _stockCountRepo.getItemCode(
            contactCode: userInfo.defaultClient ?? '',
            dcCode: userInfo.defaultCenter ?? '',
            modelCode: '',
            subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiItemCodeResult.isFailure) {
          emit(InventoryFailure(
              message: apiItemCodeResult.getErrorMessage(),
              errorCode: apiItemCodeResult.errorCode));
          return;
        }
        listItemCode = apiItemCodeResult.data;
        event.generalBloc.listItemCode = apiItemCodeResult.data;
        log('resave list ItemCode');
      }
      double totalQty = 0;
      for (var e in apiStockCount) {
        totalQty += e.qty!;
      }

      final apiStdUOM = await _todoRepo.getStdCode(
          stdCode: 'UOM', subsidiaryId: userInfo.subsidiaryId ?? '');

      if (apiStdUOM.isFailure) {
        emit(StockCountFailure(message: apiStdUOM.getErrorMessage()));
        return;
      }
      List<StdCode> uomLst = apiStdUOM.data;

      emit(StockCountSuccess(
          locationList: listLocation,
          stockCountList: apiStockCount,
          round: event.round,
          itemCodeList: listItemCode,
          totalQty: totalQty,
          uomLst: uomLst.take(6).toList()));
    } catch (e) {
      emit(const StockCountFailure(message: strings.messError));
    }
  }

  Future<void> _mapDeleteToState(DeleteStockCount event, emit) async {
    try {
      final currentState = state;
      if (currentState is StockCountSuccess) {
        emit(StockCountLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = DeleteStockCountRequest(
            id: event.id,
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
            companyId: userInfo.subsidiaryId ?? '');
        final apiResultDelete =
            await _stockCountRepo.deleteStockCount(content: content);
        if (apiResultDelete.isFailure) {
          emit(StockCountFailure(
              message: apiResultDelete.getErrorMessage(),
              errorCode: apiResultDelete.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResultDelete.data;
        if (apiResponse.isSuccess != true) {
          emit(const StockCountFailure(message: strings.messError));
          // _logger.severe(
          //   "Error",
          //   content.toJson(),
          // );
          return;
        }

        final apiResultGetSC =
            await _getStockCount(round: currentState.round, userInfo: userInfo);
        if (apiResultGetSC.isFailure) {
          emit(StockCountFailure(
              message: apiResultGetSC.getErrorMessage(),
              errorCode: apiResultGetSC.errorCode));
          return;
        }
        List<StockCountResponse> apiStockCount = apiResultGetSC.data;
        apiStockCount.sort((a, b) => b.id!.compareTo(a.id!));

        double totalQty = 0;
        for (var e in apiStockCount) {
          totalQty += e.qty!;
        }
        emit(currentState.copyWith(
          deleteSucess: true,
          stockCountList: apiStockCount,
          totalQty: totalQty,
        ));
      }
    } catch (e) {
      emit(const StockCountFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getStockCount(
      {required int round, required UserInfo userInfo}) async {
    final content = StockCountRequest(
        contactCode: userInfo.defaultClient ?? '',
        dcCode: userInfo.defaultCenter ?? '',
        countCode: DateFormat(constants.formatyyyyMMdd).format(DateTime.now()),
        createUser: userInfo.userId ?? '',
        round: round,
        companyId: userInfo.subsidiaryId ?? '');
    return await _stockCountRepo.getStockCount(content: content);
  }
}
