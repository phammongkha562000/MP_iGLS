import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/mpi/timesheet/clock_in_out/clock_in_out_request.dart';
import 'package:igls_new/data/models/mpi/timesheet/clock_in_out/wifi_response.dart';
import 'package:igls_new/data/repository/mpi/timesheet/timesheet_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/location/location_helper.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:r_get_ip/r_get_ip.dart';
// import 'package:vpn_connection_detector/vpn_connection_detector.dart';

part 'clock_in_out_event.dart';
part 'clock_in_out_state.dart';

class ClockInOutBloc extends Bloc<ClockInOutEvent, ClockInOutState> {
  final _timesheetRepo = getIt<TimesheetRepository>();
  GeneralBloc? generalBloc;
  List<WifiResponse> workLocsList = [];
  ClockInOutBloc() : super(ClockInOutInitial()) {
    on<ClockInOutViewLoaded>(_mapViewLoadedToState);
    on<ClockInOutUpdate>(_mapUpdateToState);
  }

  void _mapViewLoadedToState(ClockInOutViewLoaded event, emit) async {
    emit(ClockInOutLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiWifi = await _timesheetRepo.getcoworklocs(
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiWifi.isFailure) {
        emit(ClockInOutFailure(message: apiWifi.getErrorMessage()));
        return;
      }
      ApiResponse apiRes = apiWifi.data;
      if (apiRes.success == false) {
        emit(ClockInOutFailure(message: apiRes.error?.message ?? ''));
        return;
      }

      workLocsList = apiRes.payload ?? [];
      List<WifiResponse> workLocs = [];

      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        final workLocation = generalBloc?.generalUserInfo?.workingLocation;
        if (workLocation != '' && workLocation != null) {
          List<String> workLocationList = workLocation.split(',');
          for (var element in workLocationList) {
            for (var elm in workLocsList) {
              if (int.parse(element) == elm.id) {
                workLocs.add(elm);
              }
            }
          }
        }
      }
      List<String> workLocsName =
          workLocs.map((e) => e.locationName ?? '').toList();
      emit(ClockInOutSuccess(workingLocation: workLocsName.join(', ')));
    } catch (e) {
      emit(ClockInOutFailure(message: e.toString()));
    }
  }

  Future<bool> initPlatformState() async {
    // const LocationSettings locationSettings = LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // );
    Position position = await Geolocator.getCurrentPosition(
        /* locationSettings:
            locationSettings */
        desiredAccuracy: LocationAccuracy.high);
    final a = position.isMocked;
    log(a.toString());
    return a;
  }

  Future<void> _mapUpdateToState(ClockInOutUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ClockInOutSuccess) {
        emit(ClockInOutLoading());
        //*Mở ra nè
        bool developerMode = await FlutterJailbreakDetection.developerMode;
        if (developerMode) {
          emit(const ClockInOutFailure(message: '5784'));
          return;
        }

        String lat = '0';
        String lon = '0';
        final sharedPref = await SharedPreferencesService.instance;

        String deviceId = sharedPref.deviceId ?? '';
        //  get IP
        final externalIP = await RGetIp.externalIP;
        log('IP: ${externalIP.toString()}');

        String method = 'LOCATION';
        String macAddressWifi = '';

        //check wifi/4G
        final connectivityResult = await (Connectivity().checkConnectivity());
        var location = await LocationHelper.getLatitudeAndLongitude();
        lat = location[0].toString();
        lon = location[1].toString();
        //*user Hải Phòng office
        /* if (event.appBloc.tokenResponse?.asIgnoreCheckLocation != "False") {
          //hardcode //False
          if (await initPlatformState()) {
            emit(const ClockInOutFailure(message: 'Vị trí không chính xác'));
            return;
          }

          List<WifiResponse> workLocs = [];

          final workLocation = event.appBloc.userInfo?.workingLocation;
          if (workLocation != '' && workLocation != null) {
            List<String> workLocationList = workLocation.split(',');
            for (var element in workLocationList) {
              for (var elm in event.appBloc.wifi) {
                if (int.parse(element) == elm.id) {
                  workLocs.add(elm);
                }
              }
            }
          }
          List<String> workLocsName =
              workLocs.map((e) => e.locationName ?? '').toList();
          final content = ClockInOutRequest(
            employeeId: globalUser.getEmployeeId ?? 0,
            lat: lat,
            lon: lon,
            wifiSSID: '',
            actionDate: DateFormat(MyConstants.yyyyMMddHHmmssSlash)
                .format(DateTime.now()),
            actionType: event.type == 0 ? 'I' : 'O',
            macAddressWifi: macAddressWifi,
            method: method,
            deviceId: deviceId,
          );

          ApiResult apiResultCheckInOut =
              await _clockInOutRepo.postCheckInOut(content: content);
          if (apiResultCheckInOut.isFailure) {
            Error error = apiResultCheckInOut.getErrorResponse();
            emit(ClockInOutFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResultCheckInOut.data;
          if (apiResponse.success == false) {
            emit(ClockInOutFailure(
              message: apiResponse.error.errorMessage,
            ));
            return;
          } else if (apiResponse.error.errorCode == '1') {
            emit(ClockInOutSuccessfully(lat: lat, lon: lon));

            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          } else {
            String messErr = apiResponse.error.errorMessage;
            emit(ClockInOutFailure(
                message: messErr, errorCode: MyError.errCodeDevice));
            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          }
        } else */
        if (connectivityResult.contains(ConnectivityResult.wifi)) {
          for (var element in workLocsList) {
            if (element.macAddressWifi != '' &&
                element.macAddressWifi != null) {
              final wifiItem = element.macAddressWifi!.split(';');
              for (var i in wifiItem) {
                if (i == externalIP) {
                  method = 'IP';
                  macAddressWifi = externalIP.toString();
                  break;
                }
              }
            }
          }
          //validate
          if (method == 'IP') {
            final content = ClockInOutRequest(
                // employeeId:
                //     5344 /*  globalUser.getEmployeeId ?? 0 */, //hardcode
                employeeCode: generalBloc?.generalUserInfo?.empCode ?? '',
                lat: lat,
                lon: lon,
                wifiSSID: '',
                actionDate: DateFormat(constants.yyyyMMddHHmmssSlash)
                    .format(DateTime.now()),
                actionType: event.type == 0 ? 'I' : 'O',
                macAddressWifi: macAddressWifi,
                method: method,
                deviceId: deviceId);

            ApiResult apiResultCheckInOut = await _timesheetRepo.postCheckInOut(
                content: content,
                mpiUrl: sharedPref.serverMPi ?? '',
                baseUrl: sharedPref.serverAddress ?? '');
            if (apiResultCheckInOut.isFailure) {
              emit(ClockInOutFailure(
                  message: apiResultCheckInOut.getErrorMessage()));
              return;
            }
            MPiApiResponse apiResponse = apiResultCheckInOut.data;
            if (apiResponse.error.errorCode == '1') {
              emit(ClockInOutSuccessfully(lat: lat, lon: lon));
              emit(currentState.copyWith(workingLocation: ''));
            } else {
              emit(ClockInOutFailure(message: apiResponse.error.errorMessage));
            }
          } else {
            emit(const ClockInOutFailure(
                message: 'Vui lòng sử dụng Wifi Minh Phương để chấm công!'));
            return;
          }
        } else {
          //4G
          //get Location
          if (await initPlatformState()) {
            emit(const ClockInOutFailure(message: 'Location không chính xác'));
            return;
          }

          List<WifiResponse> workLocs = [];
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult.contains(ConnectivityResult.mobile)) {
            final workLocation = generalBloc?.generalUserInfo?.workingLocation;
            if (workLocation != '' && workLocation != null) {
              List<String> workLocationList = workLocation.split(',');
              for (var element in workLocationList) {
                for (var elm in workLocsList) {
                  if (int.parse(element) == elm.id) {
                    workLocs.add(elm);
                  }
                }
              }
            }
          }
          List<String> workLocsName =
              workLocs.map((e) => e.locationName ?? '').toList();
          final content = ClockInOutRequest(
              employeeCode: generalBloc?.generalUserInfo?.empCode ?? '',
              lat: lat,
              lon: lon,
              wifiSSID: '',
              actionDate: DateFormat(constants.yyyyMMddHHmmssSlash)
                  .format(DateTime.now()),
              actionType: event.type == 0 ? 'I' : 'O',
              macAddressWifi: macAddressWifi,
              method: method,
              deviceId: deviceId);
          final sharedPref = await SharedPreferencesService.instance;

          ApiResult apiResultCheckInOut = await _timesheetRepo.postCheckInOut(
              content: content,
              mpiUrl: sharedPref.serverMPi ?? '',
              baseUrl: sharedPref.serverAddress ?? '');
          if (apiResultCheckInOut.isFailure) {
            emit(ClockInOutFailure(
                message: apiResultCheckInOut.getErrorMessage()));
            return;
          }
          MPiApiResponse apiResponse = apiResultCheckInOut.data;
          if (apiResponse.success == false) {
            emit(ClockInOutFailure(message: apiResponse.error.errorMessage));
            return;
          } else if (apiResponse.error.errorCode == '1') {
            emit(ClockInOutSuccessfully(lat: lat, lon: lon));

            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          } else {
            emit(ClockInOutFailure(message: apiResponse.error.errorMessage));
            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          }
        }
      } else {
        emit(const ClockInOutFailure(message: "updatefailure"));
      }
    } catch (e) {
      emit(ClockInOutFailure(message: e.toString()));
    }
  }
}
