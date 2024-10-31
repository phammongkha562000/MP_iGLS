import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_request.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import '../../../general/general_bloc.dart';

part 'site_stock_check_event.dart';
part 'site_stock_check_state.dart';

class SiteStockCheckBloc
    extends Bloc<SiteStockCheckEvent, SiteStockCheckState> {
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();
  final _repoTaskHistory = getIt<TaskHistoryRepository>();

  // final _userprofileRepo = getIt<UserProfileRepository>();

  SiteStockCheckBloc() : super(SiteStockCheckInitial()) {
    // on<SiteStockCheckViewLoaded>(_mapViewLoadedToState);
    // on<SiteStockCheckGetDC>(_mapGetDCToState);
    on<SiteStockCheckGetCY>(_mapGetCYToState);
    on<SiteStockCheckGetEquipment>(_mapGetEquipmentToState);
    on<SiteStockCheckSave>(_mapSaveToState);
    // on<SiteStockCheckPickCysite>(_mapPickCysiteToState);
  }

  // Future<void> _mapGetDCToState(SiteStockCheckGetDC event, emit) async {
  //   try {
  //     UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

  //     List<DcLocal> dcLocalList = [];
  //     dcLocalList.add(DcLocal(dcCode: '', dcDesc: '5059'.tr()));
  //     List<DcLocal> listDC = event.generalBloc.listDC;
  //     if (listDC == [] || listDC.isEmpty) {
  //       final apiResult = await _userprofileRepo.getLocal(
  //           userId: userInfo.userId ?? '',
  //           subsidiaryId: userInfo.subsidiaryId ?? '');
  //       if (apiResult.isFailure) {
  //         emit(
  //             SiteStockCheckGetDCFailure(message: apiResult.getErrorMessage()));
  //         return;
  //       }
  //       LocalRespone response = apiResult.data;
  //       listDC = response.dcLocal ?? [];
  //       event.generalBloc.listDC = listDC;
  //     }
  //     dcLocalList.addAll(listDC);
  //     emit(SiteStockCheckGetDCSuccess(dcList: dcLocalList));
  //   } catch (e) {
  //     emit(SiteStockCheckFailure(message: e.toString()));
  //   }
  // }

  Future<void> _mapGetCYToState(SiteStockCheckGetCY event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      List<CySiteResponse> listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(
              SiteStockCheckGetCYFailure(message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }
      final sharedPref = await SharedPreferencesService.instance;

      CySiteResponse? cySite;
      if (listCY.isNotEmpty) {
        if (sharedPref.cySite != null && sharedPref.cySite != '') {
          cySite = listCY
              .where((element) => element.cyCode == sharedPref.cySite)
              .first;
        }
      }
      emit(SiteStockCheckGetCYSuccess(cySiteList: listCY, cySite: cySite));
    } catch (e) {
      emit(SiteStockCheckFailure(message: e.toString()));
    }
  }

  Future<void> _mapGetEquipmentToState(
      SiteStockCheckGetEquipment event, emit) async {
    try {
      emit(SiteStockCheckLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final contentEquipment = EquipmentRequest(
          equipmentCode: '',
          equipmentDesc: '',
          equipTypeNo: '',
          ownership: '',
          equipmentGroup: 'TL',
          dcCode: event.dcCode);
      final apiResult = await _repoTaskHistory.getEquipment(
        content: contentEquipment,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );

      if (apiResult.isFailure) {
        emit(SiteStockCheckGetEquipmentFailure(
            message: apiResult.getErrorMessage()));
        return;
      }
      List<EquipmentResponse> apiEquipment = apiResult.data;
      emit(SiteStockCheckGetEquipmentSuccess(equipmentList: apiEquipment));
    } catch (e) {
      emit(SiteStockCheckFailure(message: e.toString()));
    }
  }
  /* Future<void> _mapViewLoadedToState(
      SiteStockCheckViewLoaded event, emit) async {
    emit(SiteStockCheckLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final sharedPref = await SharedPreferencesService.instance;

      List<DcLocal> dcLocalList = [];
      dcLocalList.add(DcLocal(dcCode: '', dcDesc: '5059'.tr()));
      List<DcLocal> listDC = event.generalBloc.listDC;
      if (listDC == [] || listDC.isEmpty) {
        final apiResult = await _userprofileRepo.getLocal(
            userId: userInfo.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteStockCheckFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        listDC = response.dcLocal ?? [];
        event.generalBloc.listDC = listDC;
      }
      dcLocalList.addAll(listDC);
      List<CySiteResponse> listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteStockCheckFailure(message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }
      CySiteResponse? cySite;
      if (listCY.isNotEmpty) {
        if (sharedPref.cySite != null && sharedPref.cySite != '') {
          cySite = listCY
              .where((element) => element.cyCode == sharedPref.cySite)
              .first;
        }
      }

      final contentEquipment = EquipmentRequest(
          equipmentCode: '',
          equipmentDesc: '',
          equipTypeNo: '',
          ownership: '',
          equipmentGroup: 'TL',
          dcCode: userInfo.defaultCenter ?? '');
      final apiResult = await _repoTaskHistory.getEquipment(
        content: contentEquipment,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );

      if (apiResult.isFailure) {
        emit(SiteStockCheckFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<EquipmentResponse> apiEquipment = apiResult.data;

      emit(SiteStockCheckSuccess(
          cySiteList: listCY,
          cySite: cySite,
          equipmentList: apiEquipment,
          dcList: dcLocalList));
    } catch (e) {
      emit(SiteStockCheckFailure(message: e.toString()));
    }
  } */

  // Future<void> _mapPickCysiteToState(
  //     SiteStockCheckPickCysite event, emit) async {
  //   try {
  //     final currentState = state;
  //     if (currentState is SiteStockCheckSuccess) {
  //       emit(SiteStockCheckLoading());

  //       CySiteResponse cySite = currentState.cySiteList
  //           .where((element) => element.cyName == event.cySiteName)
  //           .first;

  //       emit(currentState.copyWith(cySite: cySite));
  //     }
  //   } catch (e) {
  //     emit(SiteStockCheckFailure(message: e.toString()));
  //   }
  // }

  Future<void> _mapSaveToState(SiteStockCheckSave event, emit) async {
    try {
      emit(SiteStockCheckLoading());

      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final dataRequest = CheckEquipmentsRequest(
        equipmentCode: event.trailerNo,
        equipmentDesc: "",
        equipTypeNo: "",
        ownership: "",
        equipmentGroup: "",
        dcCode: userInfo.defaultCenter ?? '',
      );

      final checkEquipment = await _repoTaskHistory.checkEquipment(
        equipmentsRequest: dataRequest,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );

      if (checkEquipment.isSuccess == false) {
        emit(const SiteStockCheckFailure(message: "no_searchs_equipment"));
        return;
      } else {
        final contentSave = SiteStockCheckRequest(
            countTrailer: "0",
            placeSite: event.cySiteCode ?? sharedPref.cySite,
            placeSiteName: event.cySiteCode ?? sharedPref.cySite,
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            trailerNumber: event.trailerNo,
            cntrNo: '',
            remark: event.remark,
            cntrStatus: 'Empty',
            containerLocker: 'Ok',
            barriers: 'Ok',
            landingGear: 'Ok',
            tireStatus: 'Ok',
            ledStatus: 'Ok',
            workingStatus: 'NORL');
        final apiSave = await _siteStockCheckRepo.getSaveSiteStockCheck(
            content: contentSave, subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiSave.isSuccess == true) {
          emit(SiteStockCheckSaveSuccess());
        } else {
          emit(SiteStockCheckFailure(message: 'UpdateFail'.tr()));
          return;
        }
      }
    } catch (e) {
      emit(SiteStockCheckFailure(message: e.toString()));
    }
  }
}
