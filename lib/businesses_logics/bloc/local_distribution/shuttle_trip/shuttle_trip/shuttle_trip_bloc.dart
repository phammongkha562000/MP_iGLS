// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/shared/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../general/general_bloc.dart';
import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';

part 'shuttle_trip_event.dart';
part 'shuttle_trip_state.dart';

class ShuttleTripBloc extends Bloc<ShuttleTripEvent, ShuttleTripState> {
  final _shuttleRepo = getIt<ShuttleTripRepository>();
  ShuttleTripBloc() : super(ShuttleTripInitial()) {
    on<ShuttleTripViewLoaded>(_mapViewLoadedToState);
    on<ShuttleTripChangeMonth>(_mapChangeMonthToState);
    on<ShuttleTripChangeDate>(_mapChangeDateToState);
  }
  Future<void> _mapViewLoadedToState(ShuttleTripViewLoaded event, emit) async {
    emit(ShuttleTripLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final vehicleNo = sharedPref.equipmentNo;
      final driverId = userInfo.empCode ?? '';
      if (vehicleNo == null || vehicleNo == "" || driverId == "") {
        emit(const ShuttleTripFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        return;
      }
      final apiResult = await _getShuttleTrips(
        defaultClient: userInfo.defaultClient ?? '',
        subsidiaryId: userInfo.subsidiaryId ?? "",
        defaultCenter: userInfo.defaultCenter ?? '',
        dateTime: DateTime.now(),
        userId: event.generalBloc.generalUserInfo?.userId ?? '',
      );
      if (apiResult.isFailure) {
        emit(ShuttleTripFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<ShuttleTripsResponse> apiResponse = apiResult.data;
      List<List<ShuttleTripsResponse>> groupByList = [];
      List<ShuttleTripsResponse> shuttleTripsByDate = [];
      List<ShuttleTripsResponse> shuttleTripsList = [];
      if (apiResponse.isNotEmpty) {
        final shuttleGroup = groupBy(
          apiResponse,
          (ShuttleTripsResponse elm) => elm.startTime!.split(' ').first,
        );

        groupByList = shuttleGroup.entries.map((entry) => entry.value).toList();
        for (var element in groupByList) {
          shuttleTripsList = (groupByList != [])
              ? element
                  .where((element) =>
                      FormatDateConstants.convertToDateTimeMMddyyyy(
                              element.startTime!)
                          .toString()
                          .split(' ')
                          .first ==
                      DateTime.now().toString().split(' ').first)
                  .toList()
              : [];
          for (var element in shuttleTripsList) {
            shuttleTripsByDate.add(element);
          }
        }
      }

      emit(ShuttleTripSuccess(
          shuttleTrips: apiResponse,
          dateTime: DateTime.now(),
          shuttleTripsByDate: shuttleTripsByDate,
          groupShuttleTrips: groupByList));
    } catch (e) {
      emit(ShuttleTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeMonthToState(
      ShuttleTripChangeMonth event, emit) async {
    try {
      final currentState = state;
      if (currentState is ShuttleTripSuccess) {
        emit(ShuttleTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await _getShuttleTrips(
          defaultClient: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? "",
          defaultCenter: userInfo.defaultCenter ?? '',
          dateTime: event.dateTime,
          userId: userInfo.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(ShuttleTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<ShuttleTripsResponse> apiResponse = apiResult.data;
        List<List<ShuttleTripsResponse>> groupByList = [];
        List<ShuttleTripsResponse> shuttleTripsByDate = [];
        List<ShuttleTripsResponse> shuttleTripsList = [];

        if (apiResponse.isNotEmpty) {
          final shuttleGroup = groupBy(
            apiResponse,
            (ShuttleTripsResponse elm) => elm.startTime!.split(' ').first,
          );

          groupByList =
              shuttleGroup.entries.map((entry) => entry.value).toList();

          for (var element in groupByList) {
            shuttleTripsList = (groupByList != [])
                ? element
                    .where((element) =>
                        FormatDateConstants.convertToDateTimeMMddyyyy(
                                element.startTime!)
                            .toString()
                            .split(' ')
                            .first ==
                        event.dateTime.toString().split(' ').first)
                    .toList()
                : [];
            for (var element in shuttleTripsList) {
              shuttleTripsByDate.add(element);
            }
          }
        }

        emit(currentState.copyWith(
            shuttleTrips: apiResponse,
            dateTime: event.dateTime,
            shuttleTripsByDate: shuttleTripsByDate,
            groupShuttleTrips: groupByList));
      }
    } catch (e) {
      emit(ShuttleTripFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getShuttleTrips({
    required DateTime dateTime,
    required String userId,
    required String defaultCenter,
    required String subsidiaryId,
    required String defaultClient,
  }) async {
    final dateFirst = dateTime.firstDayOfMonth;
    final dateLast = dateTime.lastDayOfMonth;
    final dTF = DateFormat(constants.formatyyyyMMdd).format(dateFirst);
    final dTT = DateFormat(constants.formatyyyyMMdd).format(dateLast);

    final content = ShuttleTripRequest(
        isPosted: null,
        dTF: dTF,
        dTT: dTT,
        contactCode: defaultClient,
        dCCode: defaultCenter,
        from: null,
        to: null,
        driverID: userId);

    return await _shuttleRepo.getListShuttleTrip(
        content: content, subsidiaryId: subsidiaryId);
  }

  Future<void> _mapChangeDateToState(ShuttleTripChangeDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ShuttleTripSuccess) {
        emit(ShuttleTripLoading());

        final shuttleTripsByDate = currentState.shuttleTrips
            .where((element) =>
                FormatDateConstants.convertMMddyyyy2(element.startTime!) ==
                DateFormat(constants.formatMMddyyyy).format(event.dateTime))
            .toList();
        final date = event.dateTime;
        emit(currentState.copyWith(
            shuttleTripsByDate: shuttleTripsByDate, dateTime: date));
      }
    } catch (e) {
      emit(ShuttleTripFailure(message: e.toString()));
    }
  }
}
