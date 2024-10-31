// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/presentations/enum/enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/location/location_helper.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import '../../../general/general_bloc.dart';

part 'todo_normal_trip_detail_event.dart';
part 'todo_normal_trip_detail_state.dart';

class ToDoNormalTripDetailBloc
    extends Bloc<ToDoNormalTripDetailEvent, ToDoNormalTripDetailState> {
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  static final _userProfileRepo = getIt<UserProfileRepository>();

  ToDoNormalTripDetailBloc() : super(ToDoNormalTripDetailInitial()) {
    on<ToDoNormalTripDetailViewLoaded>(_mapViewLoadedToState);
    on<ToDoNormalTripUpdateStatus>(_mapUpdateStatusToState);
    on<ToDoNormalTripUpdateOrgItemStatus>(_mapUpdateOrgItemStatusToState);
  }
  Future<void> _mapViewLoadedToState(
      ToDoNormalTripDetailViewLoaded event, emit) async {
    emit(ToDoNormalTripDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

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
          emit(ToDoNormalTripDetailFailure(
              message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }

      final apiResult = await _getDetail(
          tripNo: event.tripNo,
          subsidiaryId: userInfo.subsidiaryId ?? '',
          listDC: dcLocalList);
      if (apiResult.isFailure) {
        emit(ToDoNormalTripDetailFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      ToDoNormalTripDetailResponse detail = apiResult.data;
      final menuGroupBy = groupBy(
        detail.orgTrip!,
        (OrgTrip elm) => elm.orgPicCode,
      );

      final groupByList =
          menuGroupBy.entries.map((entry) => entry.value).toList();
      emit(ToDoNormalTripDetailSuccess(
          groupList: groupByList,
          detail: detail,
          tripNo: event.tripNo));
    } catch (e) {
      emit(ToDoNormalTripDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateStatusToState(
      ToDoNormalTripUpdateStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoNormalTripDetailSuccess) {
        emit(ToDoNormalTripDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType == EventTypeValue.completedTripEvent &&
              DateTime.now().isAfter(DateTime.parse(
                          FormatDateConstants.convertyyyyMMddHHmm(currentState
                              .detail.tripEvents!
                              .where((element) =>
                                  element.eventType ==
                                  EventTypeValue.startDeliveryEvent)
                              .first
                              .eventDateVal!))
                      .add(
                          const Duration(minutes: constants.minuteComplete))) ==
                  false) {
            //complete sau
            emit(currentState.copyWith(
                isSuccess: false,
                expectedTime: DateTime.parse(
                        FormatDateConstants.convertyyyyMMddHHmm(currentState
                            .detail.tripEvents!
                            .where((element) =>
                                element.eventType ==
                                EventTypeValue.startDeliveryEvent)
                            .first
                            .eventDateVal!))
                    .add(const Duration(minutes: constants.minuteComplete))));
          } else {
            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            final sharedPref = await SharedPreferencesService.instance;

            final userId = event.generalBloc.generalUserInfo?.userId ?? '';
            final ordeId = event.orgItemNo;
            final eventType = event.eventType;
            final tripNo = event.tripNo;
            final eventDate = DateFormat(constants.formatMMddyyyyHHmmss, 'en')
                .format(DateTime.now());
            final remark =
                '$userId - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';

            final content = UpdateNormalTripStatusRequest(
                tripNo: tripNo,
                eventDate: eventDate,
                eventType: eventType,
                placeDesc: '',
                remark: remark,
                longitude: lon.toString(),
                latitude: lat.toString(),
                userId: userId,
                ordeId: ordeId);
            final apiResultUpdate =
                await _toDoTripRepo.updateNormalTripStatusDetail(
                    content: content,
                    subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultUpdate.isFailure) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResultUpdate.getErrorMessage(),
                  errorCode: apiResultUpdate.errorCode));
              return;
            }
            StatusResponse apiResponse = apiResultUpdate.data;
            if (apiResponse.isSuccess != true) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResponse.message ?? ''));

              return;
            }
            List<DcLocal> dcLocalList = event.generalBloc.listDC;
            if (dcLocalList == [] || dcLocalList.isEmpty) {
              final apiResult = await _userProfileRepo.getLocal(
                  userId: event.generalBloc.generalUserInfo?.userId ?? '',
                  subsidiaryId: userInfo.subsidiaryId!);
              if (apiResult.isFailure) {
                emit(ToDoNormalTripDetailFailure(
                    message: apiResult.getErrorMessage()));
                return;
              }
              LocalRespone response = apiResult.data;
              dcLocalList = response.dcLocal ?? [];

              event.generalBloc.listDC = dcLocalList;
              event.generalBloc.listContactLocal = response.contactLocal ?? [];
            }

            final apiResult = await _getDetail(
                listDC: dcLocalList,
                tripNo: tripNo,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResult.isFailure) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResult.getErrorMessage(),
                  errorCode: apiResult.errorCode));
              return;
            }
            ToDoNormalTripDetailResponse detail = apiResult.data;
            final menuGroupBy = groupBy(
              detail.orgTrip!,
              (OrgTrip elm) => elm.orgPicCode,
            );

            final groupByList =
                menuGroupBy.entries.map((entry) => entry.value).toList();
            emit(currentState.copyWith(
                detail: detail, isSuccess: true, groupList: groupByList));
          }
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(ToDoNormalTripDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateOrgItemStatusToState(
      ToDoNormalTripUpdateOrgItemStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoNormalTripDetailSuccess) {
        emit(ToDoNormalTripDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType == EventTypeValue.updateOrderStatus &&
              DateTime.now().isAfter(DateTime.parse(
                          FormatDateConstants.convertyyyyMMddHHmm(currentState
                              .detail.tripEvents!
                              .where((element) =>
                                  element.eventType ==
                                  EventTypeValue.startDeliveryEvent)
                              .first
                              .eventDateVal!))
                      .add(
                          const Duration(minutes: constants.minuteComplete))) ==
                  false) {
            //complete sau
            emit(currentState.copyWith(
                isSuccess: false,
                expectedTime: DateTime.parse(
                        FormatDateConstants.convertyyyyMMddHHmm(currentState
                            .detail.tripEvents!
                            .where((element) =>
                                element.eventType ==
                                EventTypeValue.startDeliveryEvent)
                            .first
                            .eventDateVal!))
                    .add(const Duration(minutes: constants.minuteComplete))));
          } else {
            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            final sharedPref = await SharedPreferencesService.instance;

            final userId = event.generalBloc.generalUserInfo?.userId ?? '';
            final orgItemNo = event.orgItemNo;
            final tripNo = event.tripNo;
            final eventType = event.eventType;
            final eventDate = DateFormat(constants.formatMMddyyyyHHmmss)
                .format(DateTime.now());
            final remark =
                '${event.generalBloc.generalUserInfo?.userId ?? ''} - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';

            final content = UpdateNormalTripStatusOrgItemRequest(
                tripNo: tripNo,
                eventDate: eventDate,
                eventType: eventType,
                placeDesc: '',
                remark: remark,
                longitude: lon.toString(),
                latitude: lat.toString(),
                userId: userId,
                orgItemNo: orgItemNo,
                companyId: userInfo.subsidiaryId ?? '');

            final apiResultUpdate = await _toDoTripRepo
                .updateNormalTripOrgItemStatusDetail(content: content);
            if (apiResultUpdate.isFailure) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResultUpdate.getErrorMessage(),
                  errorCode: apiResultUpdate.errorCode));
              return;
            }
            StatusResponse apiResponse = apiResultUpdate.data;
            if (apiResponse.isSuccess != true) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResponse.message ?? ''));

              return;
            }
            List<DcLocal> dcLocalList = event.generalBloc.listDC;
            if (dcLocalList == [] || dcLocalList.isEmpty) {
              final apiResult = await _userProfileRepo.getLocal(
                  userId: event.generalBloc.generalUserInfo?.userId ?? '',
                  subsidiaryId: userInfo.subsidiaryId!);
              if (apiResult.isFailure) {
                emit(ToDoNormalTripDetailFailure(
                    message: apiResult.getErrorMessage()));
                return;
              }
              LocalRespone response = apiResult.data;
              dcLocalList = response.dcLocal ?? [];

              event.generalBloc.listDC = dcLocalList;
              event.generalBloc.listContactLocal = response.contactLocal ?? [];
            }

            final apiResult = await _getDetail(
                tripNo: tripNo,
                subsidiaryId: userInfo.subsidiaryId ?? '',
                listDC: dcLocalList);
            if (apiResult.isFailure) {
              emit(ToDoNormalTripDetailFailure(
                  message: apiResult.getErrorMessage(),
                  errorCode: apiResult.errorCode));
              return;
            }
            ToDoNormalTripDetailResponse detail = apiResult.data;
            final menuGroupBy = groupBy(
              detail.orgTrip!,
              (OrgTrip elm) => elm.orgPicCode,
            );

            final groupByList =
                menuGroupBy.entries.map((entry) => entry.value).toList();
            emit(currentState.copyWith(
                detail: detail, groupList: groupByList, isSuccess: true));
          }
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(ToDoNormalTripDetailFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getDetail(
      {required String tripNo,
      required String subsidiaryId,
      required List<DcLocal> listDC}) async {
    final dcCode = listDC.map((e) => e.dcCode).join(",");
    return await _toDoTripRepo.getNormalTripDetail(
        tripNo: tripNo, dcCode: dcCode, companyId: subsidiaryId);
  }
}
