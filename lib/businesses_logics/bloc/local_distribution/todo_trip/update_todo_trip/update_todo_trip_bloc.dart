import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/local_distribution/to_do_local_distribution/to_do_repository.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/location/location_helper.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/enum/delivery_result.dart';
import 'package:igls_new/presentations/enum/event_type.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'update_todo_trip_event.dart';
part 'update_todo_trip_state.dart';

class UpdateTodoTripBloc
    extends Bloc<UpdateTodoTripEvent, UpdateTodoTripState> {
  final _userRepo = getIt<UserProfileRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  // final _logger = Logger(GlobalApp.logz.toString());

  UpdateTodoTripBloc() : super(UpdateTodoTripInitial()) {
    on<UpdateTodoTripViewLoaded>(_mapViewLoadedToState);
    on<UpdateTodoTripStepStatus>(_mapStepStatusToState);
    on<UpdateTodoTripSubmit>(_mapSubmitToState);
  }
  Future<void> _mapViewLoadedToState(
      UpdateTodoTripViewLoaded event, emit) async {
    emit(UpdateTodoTripLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResultContact = await _userRepo.getContact(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultContact.isFailure) {
        emit(UpdateTodoTripFailure(
            message: apiResultContact.getErrorMessage(),
            errorCode: apiResultContact.errorCode));
        return;
      }
      List<ContactLocal> contactList = apiResultContact.data;
      final apiResultDetail = await _getDetailSimpleTrip(
          tripNo: event.tripNo, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultDetail.isFailure) {
        emit(UpdateTodoTripFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      ToDoTripDetailResponse detail = apiResultDetail.data;
      emit(UpdateTodoTripSuccess(contactList: contactList, detail: detail));
    } catch (e) {
      emit(UpdateTodoTripFailure(message: 'MessError'.tr()));
    }
  }

  Future<void> _mapStepStatusToState(
      UpdateTodoTripStepStatus event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final currentState = state;
      if (currentState is UpdateTodoTripSuccess) {
        emit(UpdateTodoTripLoading());
        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType == EventTypeValue.completedTripEvent &&
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
            return;
          } else {
            String eventDate = FormatDateConstants.getCurrentDate();
            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            final sharedPref = await SharedPreferencesService.instance;

            String remark =
                "${event.generalBloc.generalUserInfo?.empCode ?? ''} ${sharedPref.equipmentNo ?? ''} ${userInfo.mobileNo ?? ''}";
            final content = UpdateTripStatusRequest(
                tripNo: currentState.detail.tripNo!,
                eventDate: eventDate,
                eventType: event.eventType,
                lon: lon,
                lat: lat,
                userId: event.generalBloc.generalUserInfo?.userId ?? '',
                deliveryResult:
                    event.eventType == EventTypeValue.completedTripEvent
                        ? DeliveryResult.fullSuccessResult
                        : "",
                failReason: '',
                remark: remark,
                orgItemNo: 0,
                orderId: 0);

            final apiResultUpdate =
                await _toDoTripRepo.getUpdateTripStatusDetail(
                    content: content,
                    contactCode: userInfo.defaultClient!,
                    subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultUpdate.isFailure) {
              emit(UpdateTodoTripFailure(
                  message: apiResultUpdate.getErrorMessage(),
                  errorCode: apiResultUpdate.errorCode));
              return;
            }
            StatusResponse apiUpdate = apiResultUpdate.data;
            if (apiUpdate.isSuccess != true) {
              emit(const UpdateTodoTripFailure(message: strings.messError));
              // _logger.severe(
              //   "Error",
              //   content.toMap(),
              // );
              return;
            }
            final apiResultDetail = await _getDetailSimpleTrip(
              tripNo: currentState.detail.tripNo!,
              subsidiaryId: userInfo.subsidiaryId ?? '',
            );
            if (apiResultDetail.isFailure) {
              emit(UpdateTodoTripFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            ToDoTripDetailResponse detail = apiResultDetail.data;
            emit(currentState.copyWith(isSuccess: true, detail: detail));
          }
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(UpdateTodoTripFailure(message: 'MessError'.tr()));
    }
  }

  Future<void> _mapSubmitToState(UpdateTodoTripSubmit event, emit) async {
    try {
      final currentState = state;
      if (currentState is UpdateTodoTripSuccess) {
        emit(UpdateTodoTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = SimpleTripRequest(
            tripMemo: event.tripMemo, tripNo: currentState.detail.tripNo!);

        final apiResultUpdate = await _toDoTripRepo.getUpdateSimpleTripMyWork(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultUpdate.isFailure) {
          emit(UpdateTodoTripFailure(
              message: apiResultUpdate.getErrorMessage(),
              errorCode: apiResultUpdate.errorCode));
          return;
        }
        StatusResponse apiUpdate = apiResultUpdate.data;

        if (apiUpdate.isSuccess != true) {
          emit(const UpdateTodoTripFailure(message: strings.messError));
          // _logger.severe(
          //   "Error",
          //   content.toMap(),
          // );
          return;
        }
        final apiResultDetail = await _getDetailSimpleTrip(
          tripNo: currentState.detail.tripNo!,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultDetail.isFailure) {
          emit(UpdateTodoTripFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        ToDoTripDetailResponse detail = apiResultDetail.data;
        emit(currentState.copyWith(isSuccess: true, detail: detail));
      }
    } catch (e) {
      emit(UpdateTodoTripFailure(message: 'MessError'.tr()));
    }
  }

  Future<ApiResult> _getDetailSimpleTrip(
      {required String tripNo, required String subsidiaryId}) async {
    try {
      return await _toDoTripRepo.getToDoTripDetail(
          tripNo: tripNo, subsidiaryId: subsidiaryId);
    } catch (e) {
      rethrow;
    }
  }
}
