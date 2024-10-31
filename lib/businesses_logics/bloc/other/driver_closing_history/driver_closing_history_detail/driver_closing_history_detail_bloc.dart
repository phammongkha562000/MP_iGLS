import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_update_request.dart';
import 'package:igls_new/data/repository/other/manual_driver_closing/manual_driver_closing_repository.dart';
import 'package:igls_new/data/services/services.dart';

part 'driver_closing_history_detail_event.dart';
part 'driver_closing_history_detail_state.dart';

class DriverClosingHistoryDetailBloc extends Bloc<
    DriverClosingHistoryDetailEvent, DriverClosingHistoryDetailState> {
  final _manualDriverClosingRepo = getIt<ManualDriverClosingRepository>();

  DriverClosingHistoryDetailBloc()
      : super(DriverClosingHistoryDetailInitial()) {
    on<DriverClosingHistoryDetailViewLoaded>(_mapViewLoadedToState);
    // on<DriverClosingHistorySaveWithTripNo>(_mapSaveWithToState);
    // on<DriverClosingHistorySaveWithoutTripNo>(_mapSaveWithoutToState);
    on<DriverClosingHistoryUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(
      DriverClosingHistoryDetailViewLoaded event, emit) async {
    emit(DriverClosingHistoryDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResultDetail =
          await _manualDriverClosingRepo.getDriverClosingHistoryDetail(
              ddcId: event.dDCId, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultDetail.isFailure) {
        emit(DriverClosingHistoryDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      DriverDailyClosingDetailResponse apiDetail = apiResultDetail.data;
      emit(DriverClosingHistoryDetailSuccess(detail: apiDetail));
    } catch (e) {
      emit(DriverClosingHistoryDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(DriverClosingHistoryUpdate event, emit) async {
    try {
      emit(DriverClosingHistoryDetailLoading());

      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final apiUpdate = await _manualDriverClosingRepo.updateDriverClosing(
          content: event.content, subsidiary: userInfo.subsidiaryId ?? '');
      if (apiUpdate.isFailure) {
        emit(DriverClosingHistoryDetailFailure(
            message: apiUpdate.getErrorMessage(),
            errorCode: apiUpdate.errorCode));

        return;
      }
      StatusResponse statusRes = apiUpdate.data;
      if (statusRes.isSuccess == false) {
        emit(DriverClosingHistoryDetailFailure(
            message: statusRes.valueReturn ?? ''));
        return;
      }

      final apiResultDetail =
          await _manualDriverClosingRepo.getDriverClosingHistoryDetail(
              ddcId: event.content.ddcId,
              subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultDetail.isFailure) {
        emit(DriverClosingHistoryDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      DriverDailyClosingDetailResponse apiDetail = apiResultDetail.data;
      emit(DriverClosingHistoryDetailSuccess(detail: apiDetail));
    } catch (e) {
      emit(DriverClosingHistoryDetailFailure(message: e.toString()));
    }
  }

  // Future<void> _mapSaveWithoutToState(
  //     DriverClosingHistorySaveWithoutTripNo event, emit) async {
  //   try {
  //     final currentState = state;
  //     if (currentState is DriverClosingHistoryDetailSuccess) {
  //       emit(DriverClosingHistoryDetailLoading());

  //       UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

  //       final sharedPref = await SharedPreferencesService.instance;

  //       final String tripDate =
  //           DateFormat('dd/MM/yyyy HH:mm:ss').format(event.tripDate);
  //       final content = DriverDailyClosingWithoutTripNoRequest(
  //           tripDate: tripDate,
  //           contactCode: event.contact,

  //           /* currentState.localList!
  //               .where((element) => element.contactName == event.contact)
  //               .single
  //               .contactCode!, */
  //           tripNo: event.tripNo,
  //           driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
  //           equipmentNo: sharedPref.equipmentNo!,
  //           mileStart: event.mileStart,
  //           mileEnd: event.mileEnd,
  //           tripRoute: event.tripRoute,
  //           allowance: event.allowance,
  //           mealAllowance: event.mealAllowance,
  //           tollFee: event.tollFee,
  //           loadUnloadCost: event.loadUnloadCost,
  //           othersFee: event.othersFee,
  //           actualTotal: event.actualTotal,
  //           driverMemo: event.driverMemo,
  //           userId: event.generalBloc.generalUserInfo?.userId ?? '');
  //       final apiResultSave =
  //           await _manualDriverClosingRepo.getSaveWithoutTripNo(
  //               content: content, subsidiary: userInfo.subsidiaryId ?? '');
  //       if (apiResultSave.isFailure) {
  //         emit(DriverClosingHistoryFailure(
  //             message: apiResultSave.getErrorMessage(),
  //             errorCode: apiResultSave.errorCode));
  //         return;
  //       }
  //       StatusResponse apiResponse = apiResultSave.data;
  //       if (apiResponse.isSuccess != true) {
  //         emit(DriverClosingHistoryFailure(message: apiResponse.message ?? ''));
  //         emit(currentState);

  //         return;
  //       }
  //       emit(DriverClosingHistoryDetailSaveSuccess());
  //     }
  //   } catch (e) {
  //     emit(DriverClosingHistoryFailure(message: e.toString()));
  //   }
  // }

  // Future<void> _mapSaveWithToState(
  //     DriverClosingHistorySaveWithTripNo event, emit) async {
  //   try {
  //     final currentState = state;
  //     if (currentState is DriverClosingHistoryDetailSuccess) {
  //       emit(DriverClosingHistoryDetailLoading());

  //       final sharedPref = await SharedPreferencesService.instance;
  //       UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

  //       final content = DriverDailyClosingWithTripNoRequest(
  //           driverTripType: event.driverTripType,
  //           tripDate: event.tripDate,
  //           tripNo: event.tripNo,
  //           driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
  //           equipmentNo: sharedPref.equipmentNo!,
  //           mileStart: event.mileStart,
  //           mileEnd: event.mileEnd,
  //           tripRoute: event.tripRoute,
  //           allowance: event.allowance,
  //           mealAllowance: event.mealAllowance,
  //           tollFee: event.tollFee,
  //           loadUnloadCost: event.loadUnloadCost,
  //           othersFee: event.othersFee,
  //           actualTotal: event.actualTotal,
  //           driverMemo: event.driverMemo,
  //           userId: event.generalBloc.generalUserInfo?.userId ?? '',
  //           contactCode: event.contactCode);
  //       final apiResultSave = await _manualDriverClosingRepo.getSaveWithTripNo(
  //           content: content, subsidiary: userInfo.subsidiaryId ?? '');
  //       if (apiResultSave.isFailure) {
  //         emit(DriverClosingHistoryFailure(
  //             message: apiResultSave.getErrorMessage(),
  //             errorCode: apiResultSave.errorCode));
  //         return;
  //       }
  //       StatusResponse apiResponse = apiResultSave.data;
  //       if (apiResponse.isSuccess != true) {
  //         emit(DriverClosingHistoryFailure(message: apiResponse.message));
  //         emit(currentState);

  //         return;
  //       }

  //       emit(DriverClosingHistoryDetailSaveSuccess());
  //     }
  //   } catch (e) {
  //     emit(DriverClosingHistoryFailure(message: e.toString()));
  //   }
  // }
}
