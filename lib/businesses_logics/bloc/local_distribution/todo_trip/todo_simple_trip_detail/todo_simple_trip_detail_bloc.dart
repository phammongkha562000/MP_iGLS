// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/repository/local_distribution/to_do_local_distribution/to_do_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/location/location_helper.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:collection/collection.dart';
import 'package:igls_new/presentations/enum/enum.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'todo_simple_trip_detail_event.dart';
part 'todo_simple_trip_detail_state.dart';

class TodoSimpleTripDetailBloc
    extends Bloc<TodoSimpleTripDetailEvent, TodoSimpleTripDetailState> {
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  // final _logger = Logger(GlobalApp.logz.toString());

  TodoSimpleTripDetailBloc() : super(TodoSimpleTripDetailInitial()) {
    on<TodoSimpleTripDetailViewLoaded>(_mapViewLoadedToState);
    on<TodoSimpleTripDetailUpdateStatus>(_mapUpdateStatusToState);
    on<TodoSimpleTripDetailUpdateOrderStatus>(_mapUpdateOrderStatusToState);
    on<TodoSimpleTripDetailUpdateStepTripStatus>(
        _mapUpdateStepTripStatusToState); //api Imhere
  }
  Future<void> _mapViewLoadedToState(
      TodoSimpleTripDetailViewLoaded event, emit) async {
    emit(TodoSimpleTripDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResultDetail = await _getDetailTrip(
          tripNo: event.tripNo, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultDetail.isFailure) {
        emit(TodoSimpleTripDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      ToDoTripDetailResponse detail = apiResultDetail.data;
      final menuGroupBy = groupBy(
        detail.simpleOrderDetails!,
        (SimpleOrderDetail elm) => elm.pickUpCode,
      );

      final groupByList =
          menuGroupBy.entries.map((entry) => entry.value).toList();

      final apiResult = await _toDoTripRepo.getStdCode(
          stdCode: StdCodeType.failReasonCodetype,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(TodoSimpleTripDetailFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      final List<StdCode> listReason = apiResult.data;
      emit(TodoSimpleTripDetailSuccess(
        listGroup: groupByList,
        detail: detail,
        listReason: listReason,
      ));
    } catch (e) {
      emit(const TodoSimpleTripDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapUpdateStatusToState(
      TodoSimpleTripDetailUpdateStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is TodoSimpleTripDetailSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        emit(TodoSimpleTripDetailLoading());
        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType == EventTypeValue.completedTripEvent &&
              DateTime.now().isAfter(DateTime.parse(
                          FormatDateConstants.convertyyyyMMddHHmm(
                              currentState.detail.startTime!))
                      .add(
                          const Duration(minutes: constants.minuteComplete))) ==
                  false) {
            //complete sau
            emit(currentState.copyWith(
                isSuccess: false,
                expectedTime: DateTime.parse(
                        FormatDateConstants.convertyyyyMMddHHmm(
                            currentState.detail.startTime!))
                    .add(const Duration(minutes: constants.minuteComplete))));
          } else {
            String eventDate = FormatDateConstants.getCurrentDate();

            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            final sharedPref = await SharedPreferencesService.instance;
            final remark =
                '${event.generalBloc.generalUserInfo?.userId ?? ''} - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';

            final content = UpdateTripStatusRequest(
                tripNo: event.tripNo,
                eventDate: eventDate,
                eventType: event.eventType,
                lon: lon,
                lat: lat, //hard location
                userId: event.generalBloc.generalUserInfo?.userId ?? '',
                deliveryResult: event.deliveryResult ?? '',
                failReason: '',
                remark: remark,
                orgItemNo: event.orgItemNo ?? -1,
                orderId: event.orderId ?? -1);
            final apiResultUpdate = await _getUpdateTrip(
                content: content,
                contactCode: userInfo.defaultClient ?? '',
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultUpdate.isFailure) {
              emit(TodoSimpleTripDetailFailure(
                  message: apiResultUpdate.getErrorMessage(),
                  errorCode: apiResultUpdate.errorCode));
              return;
            }
            StatusResponse apiResponse = apiResultUpdate.data;
            if (apiResponse.isSuccess != true) {
              emit(const TodoSimpleTripDetailFailure(
                  message: strings.messError));
              emit(currentState);
              // _logger.severe(
              //   "Error",
              //   content.toMap(),
              // );
              return;
            }
            final apiResultDetail = await _getDetailTrip(
                tripNo: event.tripNo,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultDetail.isFailure) {
              emit(TodoSimpleTripDetailFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            ToDoTripDetailResponse detail = apiResultDetail.data;
            final menuGroupBy = groupBy(
              detail.simpleOrderDetails!,
              (SimpleOrderDetail elm) => elm.pickUpCode,
            );

            final groupByList =
                menuGroupBy.entries.map((entry) => entry.value).toList();
            emit(currentState.copyWith(
                detail: detail, listGroup: groupByList, isSuccess: true));
          }
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(const TodoSimpleTripDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapUpdateOrderStatusToState(
      TodoSimpleTripDetailUpdateOrderStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is TodoSimpleTripDetailSuccess) {
        emit(TodoSimpleTripDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType == EventTypeValue.updateOrderStatus &&
              DateTime.now().isAfter(DateTime.parse(
                          FormatDateConstants.convertyyyyMMddHHmm(
                              currentState.detail.startTime!))
                      .add(
                          const Duration(minutes: constants.minuteComplete))) ==
                  false) {
            emit(currentState.copyWith(
                isSuccess: false,
                expectedTime: DateTime.parse(
                        FormatDateConstants.convertyyyyMMddHHmm(
                            currentState.detail.startTime!))
                    .add(const Duration(minutes: constants.minuteComplete))));
          } else {
            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            String failReason = '';
            if (event.deliveryResult ==
                DeliveryResult.failResult.toUpperCase()) {
              failReason = event.failReason;
            }

            final sharedPref = await SharedPreferencesService.instance;
            final remark =
                '${event.generalBloc.generalUserInfo?.userId ?? ''} - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';
            String eventDate = FormatDateConstants.getCurrentDate();

            final content = UpdateTripStatusRequest(
                tripNo: event.tripNo,
                eventDate: eventDate,
                eventType: event.eventType,
                lon: lon,
                lat: lat,
                userId: event.generalBloc.generalUserInfo?.userId ?? '',
                deliveryResult: event.deliveryResult,
                failReason: failReason,
                remark: remark,
                orgItemNo: event.itemNo,
                orderId: int.parse(event.orderId));

            final apiResultUpdate = await _getUpdateTrip(
                content: content,
                contactCode: userInfo.defaultClient ?? '',
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultUpdate.isFailure) {
              emit(TodoSimpleTripDetailFailure(
                  message: apiResultUpdate.getErrorMessage(),
                  errorCode: apiResultUpdate.errorCode));
              return;
            }
            StatusResponse apiResponse = apiResultUpdate.data;
            if (apiResponse.isSuccess != true) {
              emit(const TodoSimpleTripDetailFailure(
                  message: strings.messError));
              emit(currentState);
              // _logger.severe(
              //   "Error",
              //   content.toMap(),
              // );
              return;
            }
            final apiResultDetail = await _getDetailTrip(
                tripNo: event.tripNo,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultDetail.isFailure) {
              emit(TodoSimpleTripDetailFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            ToDoTripDetailResponse detail = apiResultDetail.data;
            final menuGroupBy = groupBy(
              detail.simpleOrderDetails!,
              (SimpleOrderDetail elm) => elm.pickUpCode,
            );

            final groupByList =
                menuGroupBy.entries.map((entry) => entry.value).toList();

            emit(currentState.copyWith(
                detail: detail, listGroup: groupByList, isSuccess: true));
          }
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      emit(const TodoSimpleTripDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapUpdateStepTripStatusToState(
      TodoSimpleTripDetailUpdateStepTripStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is TodoSimpleTripDetailSuccess) {
        emit(TodoSimpleTripDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          final tripNo = event.tripNo;

          final sharedPref = await SharedPreferencesService.instance;

          final remark =
              '${event.generalBloc.generalUserInfo?.userId ?? ''} - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';
          String eventDate = FormatDateConstants.getCurrentDate();

          var location = await LocationHelper.getLatitudeAndLongitude();
          double lat = location[0];
          double lon = location[1];

          final content = UpdateTripStatusRequest(
              tripNo: tripNo,
              eventDate: eventDate,
              eventType: event.eventType,
              lon: lon,
              lat: lat,
              userId: event.generalBloc.generalUserInfo?.userId ?? '',
              deliveryResult: '',
              failReason: '',
              remark: remark,
              orgItemNo: -1,
              orderId: int.parse(event.orderId));
          final apiResultUpdate = await _getUpdateTrip(
              content: content,
              contactCode: userInfo.defaultClient ?? '',
              subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultUpdate.isFailure) {
            emit(TodoSimpleTripDetailFailure(
                message: apiResultUpdate.getErrorMessage(),
                errorCode: apiResultUpdate.errorCode));
            return;
          }
          StatusResponse apiResponse = apiResultUpdate.data;
          log(apiResponse.isSuccess.toString());
          if (apiResponse.isSuccess != true) {
            emit(const TodoSimpleTripDetailFailure(message: strings.messError));
            // _logger.severe(
            //   "Error",
            //   content.toMap(),
            // );
            return;
          }
          emit(currentState.copyWith(isSuccess: true));
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(const TodoSimpleTripDetailFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getDetailTrip({
    required String tripNo,
    required String subsidiaryId,
  }) async {
    return await _toDoTripRepo.getToDoTripDetail(
        tripNo: tripNo, subsidiaryId: subsidiaryId);
  }

  Future<ApiResult> _getUpdateTrip({
    required UpdateTripStatusRequest content,
    required String contactCode,
    required String subsidiaryId,
  }) async {
    return await _toDoTripRepo.getUpdateTripStatusDetail(
        content: content, contactCode: contactCode, subsidiaryId: subsidiaryId);
  }
}
