import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';

part 'manual_driver_closing_event.dart';
part 'manual_driver_closing_state.dart';

class ManualDriverClosingBloc
    extends Bloc<ManualDriverClosingEvent, ManualDriverClosingState> {
  final _manualDriverClosingRepo = getIt<ManualDriverClosingRepository>();
  ManualDriverClosingBloc() : super(ManualDriverClosingInitial()) {
    on<ManualDriverClosingViewLoaded>(_mapViewLoadedToState);
    on<ManualDriverClosingSaveWithoutTripNo>(_mapSaveWithoutToState);
    on<ManualDriverClosingSaveWithTripNo>(_mapSaveWithToState);
  }
  Future<void> _mapViewLoadedToState(
      ManualDriverClosingViewLoaded event, emit) async {
    emit(ManualDriverClosingLoading());
    try {
      // UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      /*  if (event.ddcId == 0) { */
      /* List<ContactLocal> contactList = [
        ContactLocal(contactCode: '', contactName: '5059'.tr())
      ];
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;

      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userProfileRepo.getLocal(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId!);
        if (apiResult.isFailure) {
          emit(
              ManualDriverClosingFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }
      contactList.addAll(contactLocalList); */

      emit(ManualDriverClosingSuccess(
          /*  localList: contactList, */ date: DateTime.now()));
      /*  } else {
       /*  final apiResultDetail =
            await _manualDriverClosingRepo.getDriverClosingHistoryDetail(
                ddcId: event.ddcId, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultDetail.isFailure) {
          emit(ManualDriverClosingFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        DriverDailyClosingDetailResponse apiDetail = apiResultDetail.data;
        emit(ManualDriverClosingSuccess(detail: apiDetail)); */
      } */
    } catch (e) {
      emit(const ManualDriverClosingFailure(message: strings.messError));
    }
  }

  Future<void> _mapSaveWithoutToState(
      ManualDriverClosingSaveWithoutTripNo event, emit) async {
    try {
      final currentState = state;
      if (currentState is ManualDriverClosingSuccess) {
        emit(ManualDriverClosingLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final sharedPref = await SharedPreferencesService.instance;

        final String tripDate =
            DateFormat('dd/MM/yyyy HH:mm:ss').format(event.tripDate);
        final content = DriverDailyClosingWithoutTripNoRequest(
            tripDate: tripDate,
            contactCode: event.contact,
            /* currentState.localList!
                .where((element) => element.contactName == event.contact)
                .single
                .contactCode!, */
            tripNo: event.tripNo,
            driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
            equipmentNo: sharedPref.equipmentNo!,
            mileStart: event.mileStart,
            mileEnd: event.mileEnd,
            tripRoute: event.tripRoute,
            allowance: event.allowance,
            mealAllowance: event.mealAllowance,
            tollFee: event.tollFee,
            loadUnloadCost: event.loadUnloadCost,
            othersFee: event.othersFee,
            actualTotal: event.actualTotal,
            driverMemo: event.driverMemo,
            userId: event.generalBloc.generalUserInfo?.userId ?? '');
        final apiResultSave =
            await _manualDriverClosingRepo.getSaveWithoutTripNo(
                content: content, subsidiary: userInfo.subsidiaryId ?? '');
        if (apiResultSave.isFailure) {
          emit(ManualDriverClosingFailure(
              message: apiResultSave.getErrorMessage(),
              errorCode: apiResultSave.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResultSave.data;
        if (apiResponse.isSuccess != true) {
          emit(const ManualDriverClosingFailure(message: strings.messError));
          emit(currentState);
          // _logger.severe(
          //   "Error",
          //   content.toMap(),
          // );
          return;
        }
        emit(ManualDriverClosingSaveSuccess());
      }
    } catch (e) {
      emit(const ManualDriverClosingFailure(message: strings.messError));
    }
  }

  Future<void> _mapSaveWithToState(
      ManualDriverClosingSaveWithTripNo event, emit) async {
    try {
      final currentState = state;
      if (currentState is ManualDriverClosingSuccess) {
        emit(ManualDriverClosingLoading());

        final sharedPref = await SharedPreferencesService.instance;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = DriverDailyClosingWithTripNoRequest(
          dDCId: event.dDCId,
            driverTripType: event.driverTripType,
            tripDate: event.tripDate,
            tripNo: event.tripNo,
            driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
            equipmentNo: sharedPref.equipmentNo!,
            mileStart: event.mileStart,
            mileEnd: event.mileEnd,
            tripRoute: event.tripRoute,
            allowance: event.allowance,
            mealAllowance: event.mealAllowance,
            tollFee: event.tollFee,
            loadUnloadCost: event.loadUnloadCost,
            othersFee: event.othersFee,
            actualTotal: event.actualTotal,
            driverMemo: event.driverMemo,
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            contactCode: event.contactCode);
        final apiResultSave = await _manualDriverClosingRepo.getSaveWithTripNo(
            content: content, subsidiary: userInfo.subsidiaryId ?? '');
        if (apiResultSave.isFailure) {
          emit(ManualDriverClosingFailure(
              message: apiResultSave.getErrorMessage(),
              errorCode: apiResultSave.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResultSave.data;
        if (apiResponse.isSuccess != true) {
          emit(ManualDriverClosingFailure(message: apiResponse.message));
          emit(currentState);
        
          return;
        }
        /*   final apiResultDetail =
            await _manualDriverClosingRepo.getDriverClosingHistoryDetail(
                ddcId: event.dDCId /* currentState.detail!.dDCId! */,
                subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultDetail.isFailure) {
          emit(ManualDriverClosingFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        DriverDailyClosingDetailResponse apiDetail = apiResultDetail.data;
        emit(currentState.copyWith(isSuccess: true, detail: apiDetail)); */
        emit(ManualDriverClosingSaveSuccess());
      }
    } catch (e) {
      emit(const ManualDriverClosingFailure(message: strings.messError));
    }
  }
}
