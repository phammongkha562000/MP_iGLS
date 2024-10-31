import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/ha_driver_menu/ha_driver_menu.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../general/general_bloc.dart';

part 'driver_check_in_event.dart';
part 'driver_check_in_state.dart';

class DriverCheckInBloc extends Bloc<DriverCheckInEvent, DriverCheckInState> {
  final _driverCheckInRepo = getIt<DriverCheckInRepository>();
  DriverCheckInBloc() : super(DriverCheckInInitial()) {
    on<DriverCheckInViewLoaded>(_mapViewLoadedToState);
    on<DriverCheckInUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(
      DriverCheckInViewLoaded event, emit) async {
    emit(DriverCheckInLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final tractor = sharedPref.equipmentNo;

      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      if (tractor == null || tractor == "" || driverId == "") {
        emit(const DriverCheckInFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        return;
      }
      String accessDatetime = DateTime.now().toString().split('.').first;
      log(accessDatetime.toString());
      final apiResult = await _driverCheckInRepo.getDriverTodayInfo(
        driverId: driverId,
        equipmentCode: tractor,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (apiResult.isFailure) {
        emit(DriverCheckInFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      DriverTodayInfo apiTodayInfo = apiResult.data;

      emit(DriverCheckInSuccess(
        dateTime: apiTodayInfo.onDate,
        tractor: tractor,
        driverId: driverId,
      ));
    } catch (e) {
      emit(DriverCheckInFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(DriverCheckInUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is DriverCheckInSuccess) {
        emit(DriverCheckInLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final sharedPref = await SharedPreferencesService.instance;
        final userId = event.generalBloc.generalUserInfo?.userId ?? '';
        final dcCode = userInfo.defaultCenter;
        final equipmentCode = sharedPref.equipmentNo;
        final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
        if (equipmentCode == null || equipmentCode == '' || driverId == '') {
          emit(const DriverCheckInFailure(
              message: strings.messErrorNoEquipment,
              errorCode: constants.errorNullEquipDriverId));
        }
        final content = DriverCheckInRequest(
            equipmentCode: equipmentCode!,
            dcCode: dcCode!,
            driverId: driverId,
            userId: userId,
            onDate: DateFormat(constants.formatyyyyMMddHHmm)
                .format(DateTime.now()));
        final apiResultSave = await _driverCheckInRepo.saveDriverCheckIn(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultSave.isFailure) {
          emit(DriverCheckInFailure(
              message: apiResultSave.getErrorMessage(),
              errorCode: apiResultSave.errorCode));
          return;
        }
        StatusResponse apiSave = apiResultSave.data;

        if (apiSave.isSuccess != true) {
          emit(const DriverCheckInFailure(message: strings.messError));
          return;
        }
        final tractor = sharedPref.equipmentNo;

        final apiResult = await _driverCheckInRepo.getDriverTodayInfo(
          driverId: driverId,
          equipmentCode: tractor,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResult.isFailure) {
          emit(DriverCheckInFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        DriverTodayInfo apiTodayInfo = apiResult.data;
        emit(currentState.copyWith(
          dateTime: apiTodayInfo.onDate,
          isSuccess: true,
          updateSuccess: true,
        ));
      }
    } catch (e) {
      emit(const DriverCheckInFailure(message: strings.messError));
    }
  }
}
