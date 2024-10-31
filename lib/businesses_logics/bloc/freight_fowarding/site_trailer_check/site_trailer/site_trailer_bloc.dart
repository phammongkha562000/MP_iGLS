import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_request.dart';
import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../general/general_bloc.dart';

part 'site_trailer_event.dart';
part 'site_trailer_state.dart';

class SiteTrailerBloc extends Bloc<SiteTrailerEvent, SiteTrailerState> {
  final _siteTrailerRepo = getIt<SiteTrailerRepository>();
  final _repoTaskHistory = getIt<TaskHistoryRepository>();
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();

  SiteTrailerBloc() : super(SiteTrailerInitial()) {
    on<SiteTrailerViewLoaded>(_mapViewLoadedToState);
    on<SiteTrailerSave>(_mapSaveToState);
    on<SiteTrailerPickCysite>(_mapPickCysiteToState);
  }
  Future<void> _mapViewLoadedToState(SiteTrailerViewLoaded event, emit) async {
    emit(SiteTrailerLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      List<CySiteResponse> listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteTrailerFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
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
        emit(SiteTrailerFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<EquipmentResponse> apiEquipment = apiResult.data;

      emit(SiteTrailerSuccess(
          cySiteList: listCY, cySite: cySite, equipmentList: apiEquipment));
    } catch (e) {
      emit(SiteTrailerFailure(message: e.toString()));
    }
  }

  Future<void> _mapPickCysiteToState(SiteTrailerPickCysite event, emit) async {
    try {
      final currentState = state;
      if (currentState is SiteTrailerSuccess) {
        emit(SiteTrailerLoading());

        CySiteResponse cySite = currentState.cySiteList
            .where((element) => element.cyCode == event.cySiteCode)
            .first;

        emit(currentState.copyWith(cySite: cySite));
      }
    } catch (e) {
      emit(SiteTrailerFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(SiteTrailerSave event, emit) async {
    try {
      final currentState = state;
      if (currentState is SiteTrailerSuccess) {
        emit(SiteTrailerLoading());

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

        final apiResultCheckEquipment = await _repoTaskHistory.checkEquipment(
          equipmentsRequest: dataRequest,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultCheckEquipment.isFailure) {
          emit(SiteTrailerFailure(
              message: apiResultCheckEquipment.getErrorMessage(),
              errorCode: apiResultCheckEquipment.errorCode));
          return;
        }
        StatusResponse checkEquipment = apiResultCheckEquipment.data;
        if (checkEquipment.isSuccess == false) {
          emit(SiteTrailerFailure(message: "5490".tr()));
          return;
        } else {
          CySiteResponse cySite = currentState.cySiteList
              .where((element) => element.cyName == event.cySiteName)
              .first;
          final contentSave = SiteStockCheckRequest(
              countTrailer: "0",
              placeSite: cySite.cyCode ?? sharedPref.cySite,
              placeSiteName: cySite.cyCode ?? sharedPref.cySite,
              userId: event.generalBloc.generalUserInfo?.userId ?? '',
              trailerNumber: event.trailerNo,
              cntrNo: event.cntrNo,
              remark: event.remark,
              cntrStatus: event.cntrStatus,
              containerLocker: event.containerLocker,
              barriers: event.barriers,
              landingGear: event.landingGear,
              tireStatus: event.tireStatus,
              ledStatus: event.ledStatus, workingStatus: event.workingStatus);
          final apiResultSave = await _siteTrailerRepo.getSaveSiteTrailer(
              content: contentSave, subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultSave.isFailure) {
            emit(SiteTrailerFailure(
                message: apiResultSave.getErrorMessage(),
                errorCode: apiResultSave.errorCode));
            return;
          }
          StatusResponse apiSave = apiResultSave.data;
          if (apiSave.isSuccess == true) {
            emit(SiteTrailerSaveSuccess());
          } else {
            emit(SiteTrailerFailure(
                message: apiSave.valueReturn!.contains('ER001')
                    ? '5486'.tr()
                    : 'Update fail!'));
            return;
          }
        }
      }
    } catch (e) {
      emit(SiteTrailerFailure(message: e.toString()));
    }
  }
}
