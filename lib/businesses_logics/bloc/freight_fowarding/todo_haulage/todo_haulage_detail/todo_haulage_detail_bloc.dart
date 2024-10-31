import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import '../../../../../data/models/models.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/repository/ha_driver_menu/task_history/task_history_repo.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/location/location_helper.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/shared/shared.dart';
import '../../../general/general_bloc.dart';

part 'todo_haulage_detail_event.dart';
part 'todo_haulage_detail_state.dart';

class ToDoHaulageDetailBloc
    extends Bloc<ToDoHaulageDetailEvent, ToDoHaulageDetailState> {
  final _todoLaugaleRepo = getIt<ToDoHaulageRepository>();
  final _repoTaskHistory = getIt<TaskHistoryRepository>();

  ToDoHaulageDetailBloc() : super(ToDoHaulageDetailInitial()) {
    on<ToDoHaulageDetailViewLoaded>(_mapDetailViewLoadToState);
    on<ToDoHaulageUpdateWorkOrderStatus>(_mapUpdateWorkOrderStatusToState);
    on<ToDoHaulageUpdateTrailer>(_mapUpdateTrailerToState);
    on<ToDoHaulageUpdateNote>(_mapUpdateNoteToState);
    on<ToDoHaulageUpdateContainerSealNo>(_mapUpdateCNTRSealToState);
  }

  Future _mapDetailViewLoadToState(ToDoHaulageDetailViewLoaded event,
      Emitter<ToDoHaulageDetailState> emit) async {
    emit(ToDoHaulageDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final woTaskId = event.woTaskId;
      final apiResult = await _getDetailHaulage(
          woTaskId: woTaskId, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(ToDoHaulageDetailFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      HaulageToDoDetail detail = apiResult.data;

      final List<PageMenuPermissions> pageLocal = event.generalBloc.listMenu;
      final item = pageLocal
          .where((element) => element.tagVariant == constants.casePlanTransfer)
          .toList();
      final contentEquipment = EquipmentRequest(
        equipmentCode: '',
        equipmentDesc: '',
        equipTypeNo: '',
        ownership: '',
        equipmentGroup: 'TL',
        dcCode: userInfo.defaultCenter ?? '',
      );
      final apiResultEquipment = await _repoTaskHistory.getEquipment(
          content: contentEquipment, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultEquipment.isFailure) {
        emit(ToDoHaulageDetailFailure(
            message: apiResultEquipment.getErrorMessage(),
            errorCode: apiResultEquipment.errorCode));
        return;
      }
      List<EquipmentResponse> apiEquipment = apiResultEquipment.data;
      emit(ToDoHaulageDetailSuccess(
          equipmentList: apiEquipment,
          detail: detail,
          isTransfer: item.isNotEmpty ? true : false));
    } catch (e) {
      emit(ToDoHaulageDetailFailure(message: e.toString()));
    }
  }

  void _mapUpdateWorkOrderStatusToState(
      ToDoHaulageUpdateWorkOrderStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoHaulageDetailSuccess) {
        emit(ToDoHaulageDetailLoading());
        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          if (event.eventType != 'PU' &&
              DateTime.now().isAfter(DateTime.parse(
                          FormatDateConstants.convertyyyyMMddHHmm(
                              currentState.detail.actualStart!))
                      .add(
                          const Duration(minutes: constants.minuteComplete))) ==
                  false) {
            //complete sau
            emit(currentState.copyWith(
                isSuccess: false,
                expectedTime: DateTime.parse(
                        FormatDateConstants.convertyyyyMMddHHmm(
                            currentState.detail.actualStart!))
                    .add(const Duration(minutes: constants.minuteComplete))));
          } else {
            final wOTaskId = currentState.detail.woTaskId;
            final cNTRNo = currentState.detail.cntnNo;
            final sealNo = currentState.detail.sealNo;
            final now = DateTime.now();
            final eventDate = DateFormat(constants.formatMMddyyyyHHmm)
                .format(now); //truyền lên 24h
            final eventType = event.eventType;
            UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

            var location = await LocationHelper.getLatitudeAndLongitude();
            double lat = location[0];
            double lon = location[1];

            final content = WorkOrderStatusRequest(
                wOTaskId: wOTaskId!,
                eventDate: eventDate,
                eventType: eventType,
                lat: lat.toString(), // ! lat hard
                lon: lon.toString(), // ! lon hard
                userId: event.generalBloc.generalUserInfo?.userId ?? '',
                cNTRNo: cNTRNo!,
                sealNo: sealNo!);
            final apiResult = await _todoLaugaleRepo.updateWorkOrderStatus(
                content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResult.isFailure) {
              emit(ToDoHaulageDetailFailure(
                  message: apiResult.getErrorMessage(),
                  errorCode: apiResult.errorCode));
              return;
            }
            StatusResponse apiResponse = apiResult.data;
            if (apiResponse.isSuccess != true) {
              emit(ToDoHaulageDetailFailure(
                  message: apiResponse.message.toString()));

              return;
            }
            final apiResultDetail = await _getDetailHaulage(
                woTaskId: currentState.detail.woTaskId!,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            //get detail
            if (apiResultDetail.isFailure) {
              emit(ToDoHaulageDetailFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            HaulageToDoDetail detail = apiResultDetail.data;

            emit(currentState.copyWith(detail: detail, isSuccess: true));
          }
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(ToDoHaulageDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateTrailerToState(
      ToDoHaulageUpdateTrailer event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoHaulageDetailSuccess) {
        emit(ToDoHaulageDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final detail = currentState.detail;
        final content = UpdateTrailerRequest(
          woNo: detail.woNoOrginal!,
          woTaskId: detail.woTaskId.toString(),
          trailerNo: event.trailer,
          updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
        );
        final dataRequest = CheckEquipmentsRequest(
          equipmentCode: event.trailer,
          equipmentDesc: "",
          equipTypeNo: "",
          ownership: "",
          equipmentGroup: "",
          dcCode: userInfo.defaultCenter ?? '',
        );

        final apiResultCheckEquipment = await _repoTaskHistory.checkEquipment(
            equipmentsRequest: dataRequest,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultCheckEquipment.isFailure) {
          emit(ToDoHaulageDetailFailure(
              message: apiResultCheckEquipment.getErrorMessage(),
              errorCode: apiResultCheckEquipment.errorCode));
          return;
        }

        StatusResponse checkEquipment = apiResultCheckEquipment.data;

        if (checkEquipment.isSuccess == true) {
          final apiResult = await _todoLaugaleRepo.updateTrailer(
              content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResult.isFailure) {
            emit(ToDoHaulageDetailFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }
          StatusResponse apiResponse = apiResult.data;
          if (apiResponse.isSuccess != true) {
            emit(ToDoHaulageDetailFailure(
                message: apiResponse.message.toString()));

            return;
          }
          final apiResultDetail = await _getDetailHaulage(
              woTaskId: currentState.detail.woTaskId!,
              subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultDetail.isFailure) {
            emit(ToDoHaulageDetailFailure(
                message: apiResultDetail.getErrorMessage(),
                errorCode: apiResultDetail.errorCode));
            return;
          }
          HaulageToDoDetail detail = apiResultDetail.data;
          emit(currentState.copyWith(detail: detail, isSuccess: true));
        } else {
          emit(currentState.copyWith(isSuccess: false));
        }
      }
    } catch (e) {
      emit(ToDoHaulageDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateNoteToState(ToDoHaulageUpdateNote event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoHaulageDetailSuccess) {
        emit(ToDoHaulageDetailLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final detail = currentState.detail;
        final content = WorkTaskUpdateNoteRequest(
          driverMemo: event.note,
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          woTaskId: detail.woTaskId.toString(),
        );
        final apiResult = await _todoLaugaleRepo.getUpdateNote(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(ToDoHaulageDetailFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResult.data;

        if (apiResponse.isSuccess != true) {
          emit(ToDoHaulageDetailFailure(
              message: apiResponse.message.toString()));

          return;
        }

        final apiResultDetail = await _getDetailHaulage(
          woTaskId: currentState.detail.woTaskId!,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultDetail.isFailure) {
          emit(ToDoHaulageDetailFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        HaulageToDoDetail newDetail = apiResultDetail.data;

        emit(currentState.copyWith(detail: newDetail, isSuccess: true));
      }
    } catch (e) {
      emit(ToDoHaulageDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateCNTRSealToState(
      ToDoHaulageUpdateContainerSealNo event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoHaulageDetailSuccess) {
        emit(ToDoHaulageDetailLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = ContainerAndSealNoRequest(
            wOTaskId: currentState.detail.woTaskId!,
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            cNTRNo: event.cntr,
            sealNo: event.seal);
        final apiResult = await _todoLaugaleRepo.updateContainerSealNo(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(ToDoHaulageDetailFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResult.data;
        if (apiResponse.isSuccess != true) {
          if (apiResponse.message == constants.errorNoUpdateCNTR) {
            emit(ToDoHaulageDetailFailure(message: "5180".tr()));
          } else if (apiResponse.message == constants.errorValidateFormatCNTR) {
            emit(ToDoHaulageDetailFailure(message: "5486".tr()));
          } else {
            emit(ToDoHaulageDetailFailure(message: apiResponse.message ?? ''));
          }

          return;
        }

        final apiResultDetail = await _getDetailHaulage(
            woTaskId: currentState.detail.woTaskId!,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultDetail.isFailure) {
          emit(ToDoHaulageDetailFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        HaulageToDoDetail detail = apiResultDetail.data;
        emit(currentState.copyWith(detail: detail, isSuccess: true));
      }
    } catch (e) {
      emit(ToDoHaulageDetailFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getDetailHaulage(
      {required int woTaskId, required String subsidiaryId}) async {
    return await _todoLaugaleRepo.getToDoHaulageDetail(
        woTaskId: woTaskId, subsidiaryId: subsidiaryId);
  }
}
