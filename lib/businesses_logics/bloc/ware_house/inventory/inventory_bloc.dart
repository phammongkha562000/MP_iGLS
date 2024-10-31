import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/key_params.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../../../data/shared/shared.dart';
import '../../general/general_bloc.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final _inventoryRepo = getIt<InventoryRepository>();
  final _loginRepo = getIt<LoginRepository>();
  final _palletRelocationRepo = getIt<PalletRelocationRepository>();

  final _stockCountRepo = getIt<StockCountRepository>();

  InventoryBloc() : super(InventoryInitial()) {
    on<InventoryLoaded>(_mapViewToState);
    on<InventorySearch>(_mapSearchtoState);
    on<GrNoSearch>(_grNoSearchToState);
  }
  List<String> itemStatus = ["NORMAL", "DAMAGED", "REPAIR"];

  void _mapViewToState(InventoryLoaded event, emit) async {
    emit(InventoryLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

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

      List<ContactResponse> listContactResponse =
          event.generalBloc.listContactResponse;
      if (listContactResponse.isEmpty || listContactResponse == []) {
        final apiResultContact = await _loginRepo.getContactToFormat(
          contactCode: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultContact.isFailure) {
          emit(InventoryFailure(
              message: apiResultContact.getErrorMessage(),
              errorCode: apiResultContact.errorCode));
          return;
        }
        listContactResponse = apiResultContact.data;
        event.generalBloc.listContactResponse = listContactResponse;
        log('resave list list ContactResponse');
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
        log('resave list list ItemCode');
      }
      //****** */
      // if (getItemCodeList is ApiResult) {
      //   if (getItemCodeList.isFailure) {
      //     emit(InventoryFailure(
      //         message: getItemCodeList.getErrorMessage(),
      //         errorCode: getItemCodeList.errorCode));
      //     return;
      //   }
      // }
      // // List<LocationStockCountResponse> locationList = getLocationList;
      // List<ItemCodeResponse> itemCodeList = getItemCodeList;
      //contact others

      if (listContactResponse.isNotEmpty) {
        for (var i = 0; i <= listContactResponse.length; i++) {
          if (listContactResponse[i].valueCode == "DEF_QTY_SCALE") {
            var formartN = listContactResponse[i].othersValue;
            sharedPref.setFormatWithContact(formartN ?? "");
            globalContactFormat.setFormat = sharedPref.formatN;

            break;
          } else if (listContactResponse[i].valueCode != "DEF_QTY_SCALE") {}
        }
      } else {
        sharedPref.setFormatWithContact('');
      }

      // if (event.pageId != null && event.pageName != null) {
      //   final sharedPref = await SharedPreferencesService.instance;
      //   String accessDatetime = DateTime.now().toString().split('.').first;
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
      //     emit(InventoryFailure(
      //         message: addFreqVisitResult.getErrorMessage(),
      //         errorCode: addFreqVisitResult.errorCode));
      //     return;
      //   }
      // }

      emit(InventorySuccess(
        itemStatus: itemStatus[0],
        listLoc: listLocation,
        listItemCode: listItemCode,
        listItem: itemStatus,
      ));
    } catch (e) {
      emit(InventoryFailure(message: e.toString()));
    }
  }

  void _mapSearchtoState(InventorySearch event, emit) async {
    try {
      emit(InventoryLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final dataSearch = InventoryRequest(
        contactCode: userInfo.defaultClient ?? '',
        companyId: userInfo.subsidiaryId ?? '',
        dcNo: userInfo.defaultCenter ?? '',
        itemCode: event.itemCode,
        locCode: event.locCode,
        donebyStaff: "",
        grade: "",
        grf: "",
        grt: "",
        itemStatus: event.itemStatus,
        lotCode: "",
        orderNo: "",
        orderType: "",
        zone: "",
        pageNum: 0,
        pageSize: 1000,
      );
      final apiResultInventory =
          await _inventoryRepo.getInventory(content: dataSearch);
      if (apiResultInventory.isFailure) {
        emit(InventoryFailure(
            message: apiResultInventory.getErrorMessage(),
            errorCode: apiResultInventory.errorCode));
        return;
      }
      InventoryResponse getInventory = apiResultInventory.data;
      final listInventory = getInventory.returnModel;
      double totalQty = 0;
      double totalReserved = 0;
      for (var e in listInventory) {
        totalQty += e.grQty!;
        totalReserved += e.reservedQty!;
      }

      emit(InventorySearchSuccess(
          listInventory: listInventory,
          totalQty: totalQty,
          totalReserved: totalReserved));
    } catch (e) {
      emit(InventoryFailure(message: e.toString()));
    }
  }

  Future<void> _grNoSearchToState(GrNoSearch event, emit) async {
    try {
      emit(InventoryLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResponse = await _palletRelocationRepo.getGRForRelocation(
          grNo: event.grNo,
          dcNo: userInfo.defaultCenter ?? '',
          contactCode: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');

      if (apiResponse.isFailure) {
        emit(InventoryFailure(message: apiResponse.getErrorMessage()));
        return;
      }
      PalletRelocationResponse res = apiResponse.data;
      if (res.gRNo == null) {
        emit(InventoryFailure(message: '5544'.tr()));
        return;
      }
      emit(GrNoSearchSuccess(pallet: res));
    } catch (e) {
      emit(InventoryFailure(message: e.toString()));
    }
  }
}
