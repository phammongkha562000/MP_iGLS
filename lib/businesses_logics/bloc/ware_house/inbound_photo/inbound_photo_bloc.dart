import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../../../data/shared/shared.dart';
import '../../general/general_bloc.dart';

part 'inbound_photo_event.dart';
part 'inbound_photo_state.dart';

class InboundPhotoBloc extends Bloc<InboundPhotoEvent, InboundPhotoState> {
  final _inboundPhotoRepo = getIt<InboundPhotoRepository>();
  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<InboundPhotoResult> inboundPhotoLst = [];
  InboundPhotoBloc() : super(InboundPhotoInitial()) {
    on<InboundPhotoViewLoaded>(_mapViewLoadedToState);
    on<InboundPhotoPreviousDateLoaded>(_mapPreviousToState);
    on<InboundPhotoNextDateLoaded>(_mapNextToState);
    on<InboundPhotoPickDate>(_mapPickDateToState);
    on<InboundPhotoPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(InboundPhotoViewLoaded event, emit) async {
    emit(InboundPhotoLoading());
    try {
      endPage = false;
      pageNumber = 1;
      quantity = 0;
      inboundPhotoLst.clear();

      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult =
          await _getOrder(dateEvent: event.date, userInfo: userInfo);
      if (apiResult.isFailure) {
        emit(InboundPhotoFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      ApiResponse apiRes = apiResult.data;
      InboundPhotoResponse inboundRes = apiRes.payload;

      List<InboundPhotoResult> inboundList = inboundRes.results ?? [];
      inboundPhotoLst.addAll(inboundList);
      quantity = inboundRes.totalCount ?? 0;
      // List<OrderResponse> orderList = apiResult.data;/

      // if (event.pageId != null && event.pageName != null) {
      //   String accessDatetime = DateTime.now().toString().split('.').first;
      //   final sharedPref = await SharedPreferencesService.instance;

      //   final contentQuickMenu = FrequentlyVisitPageRequest(
      //       userId:  event.generalBloc.generalUserInfo?.userId??'',
      //       subSidiaryId:  userInfo.subsidiaryId?? '',
      //       pageId: event.pageId!,
      //       pageName: event.pageName!,
      //       accessDatetime: accessDatetime,
      //       systemId: constants.systemId);
      //   final addFreqVisitResult =
      //       await _loginRepo.saveFreqVisitPage(content: contentQuickMenu);
      //   if (addFreqVisitResult.isFailure) {
      //     emit(InboundPhotoFailure(
      //         message: addFreqVisitResult.getErrorMessage(),
      //         errorCode: addFreqVisitResult.errorCode));
      //     return;
      //   }
      // }

      emit(InboundPhotoSuccess(
          date: event.date,
          orderList: inboundList,
          quantity: quantity,
          isPagingLoading: false));
    } catch (e) {
      emit(const InboundPhotoFailure(message: strings.messError));
    }
  }

  Future<void> _mapPickDateToState(InboundPhotoPickDate event, emit) async {
    try {
      final currentState = state;
      emit(InboundPhotoLoading());
      if (currentState is InboundPhotoSuccess) {
        endPage = false;
        pageNumber = 1;
        quantity = 0;
        inboundPhotoLst.clear();
        final date = event.date;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await _getOrder(dateEvent: date, userInfo: userInfo);
        if (apiResult.isFailure) {
          emit(InboundPhotoFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }

        // List<OrderResponse> orderList = apiResult.data;
        ApiResponse apiRes = apiResult.data;
        InboundPhotoResponse inboundRes = apiRes.payload;

        List<InboundPhotoResult> inboundList = inboundRes.results ?? [];
        inboundPhotoLst.addAll(inboundList);
        quantity = inboundRes.totalCount ?? 0;
        emit(currentState.copyWith(
          date: date,
          orderList: inboundList,
          quantity: quantity,
        ));
      }
    } catch (e) {
      emit(const InboundPhotoFailure(message: strings.messError));
    }
  }

  Future<void> _mapPreviousToState(
      InboundPhotoPreviousDateLoaded event, emit) async {
    try {
      final currentState = state;
      emit(InboundPhotoLoading());
      if (currentState is InboundPhotoSuccess) {
        endPage = false;
        pageNumber = 1;
        quantity = 0;
        inboundPhotoLst.clear();
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final previous = currentState.date.findPreviousDate;
        final apiResult =
            await _getOrder(dateEvent: previous, userInfo: userInfo);
        if (apiResult.isFailure) {
          emit(InboundPhotoFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }

        ApiResponse apiRes = apiResult.data;
        InboundPhotoResponse inboundRes = apiRes.payload;

        List<InboundPhotoResult> inboundList = inboundRes.results ?? [];
        inboundPhotoLst.addAll(inboundList);
        quantity = inboundRes.totalCount ?? 0;
        emit(currentState.copyWith(
          date: previous,
          orderList: inboundList,
          quantity: quantity,
        ));
      }
    } catch (e) {
      emit(const InboundPhotoFailure(message: strings.messError));
    }
  }

  Future<void> _mapNextToState(InboundPhotoNextDateLoaded event, emit) async {
    try {
      final currentState = state;
      emit(InboundPhotoLoading());
      if (currentState is InboundPhotoSuccess) {
        endPage = false;
        pageNumber = 1;
        quantity = 0;
        inboundPhotoLst.clear();
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final next = currentState.date.findNextDate;

        final apiResult = await _getOrder(dateEvent: next, userInfo: userInfo);
        if (apiResult.isFailure) {
          emit(InboundPhotoFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }

        // List<OrderResponse> orderList = apiResult.data;
        ApiResponse apiRes = apiResult.data;
        InboundPhotoResponse inboundRes = apiRes.payload;

        List<InboundPhotoResult> inboundList = inboundRes.results ?? [];
        inboundPhotoLst.addAll(inboundList);
        quantity = inboundRes.totalCount ?? 0;
        emit(currentState.copyWith(
            quantity: quantity, date: next, orderList: inboundList));
      }
    } catch (e) {
      emit(const InboundPhotoFailure(message: strings.messError));
    }
  }

  Future<void> _mapPagingToState(InboundPhotoPaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is InboundPhotoSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        if (inboundPhotoLst.length == quantity) {
          endPage = true;
          emit(currentState);
          return;
        }
        if (endPage == false) {
          emit(currentState.copyWith(isPagingLoading: true));
          pageNumber++;
          final apiResult =
              await _getOrder(dateEvent: currentState.date, userInfo: userInfo);
          if (apiResult.isFailure) {
            emit(InboundPhotoFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }

          ApiResponse apiRes = apiResult.data;
          InboundPhotoResponse inboundRes = apiRes.payload;

          List<InboundPhotoResult> inboundList = inboundRes.results ?? [];
          if (inboundList != [] && inboundList.isNotEmpty) {
            inboundPhotoLst.addAll(inboundList);
          } else {
            endPage = true;
          }
          emit(currentState.copyWith(
              orderList: inboundPhotoLst, isPagingLoading: false));
        }
      }
    } catch (e) {
      emit(const InboundPhotoFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getOrder(
      {required DateTime dateEvent, required UserInfo userInfo}) async {
    try {
      final date = DateFormat(constants.formatMMddyyyy).format(dateEvent);

      final dcCode = userInfo.defaultCenter ?? '';
      final contactCode = userInfo.defaultClient ?? '';
      final companyId = userInfo.subsidiaryId ?? '';
      final content = OrderInboundPhotoRequest(
          orderNo: '',
          orderType: '',
          etaf: /* "01/01/2020" */ date,
          etat: /* "12/01/2024" */ date,
          aignedStaff: '',
          contactCode: contactCode,
          dcCode: dcCode,
          companyId: companyId,
          pageNumber: pageNumber,
          pageSize: constants.sizePaging);
      return await _inboundPhotoRepo.getOrder(content: content);
    } catch (e) {
      rethrow;
    }
  }
}
