// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/ha_driver_menu/task_history/task_history_repo.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import '../../../general/general_bloc.dart';

part 'task_history_detail_item_event.dart';
part 'task_history_detail_item_state.dart';

class TaskHistoryDetailItemBloc
    extends Bloc<TaskHistoryDetailItemEvent, TaskHistoryDetailItemState> {
  final _taskHistoryRepo = getIt<TaskHistoryRepository>();

  TaskHistoryDetailItemBloc() : super(TaskHistoryDetailItemInitial()) {
    on<TaskHistoryDetailItemLoaded>(_mapHistoryDetailItemToState);
    on<UpdateWordOrderWithDataLoaded>(_mapUpdateWorkOrderWithDataToState);
  }

  Future<void> _mapHistoryDetailItemToState(
      TaskHistoryDetailItemLoaded event, emit) async {
    emit(TaskHistoryDetailItemLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult = await _taskHistoryRepo.getHistoryDetailItem(
          dtdId: event.dtdId, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(TaskHistoryDetailItemFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      HistoryDetailItem adetailItem = apiResult.data;
      final contentEquipment = EquipmentRequest(
        equipmentCode: '',
        equipmentDesc: '',
        equipTypeNo: '',
        ownership: '',
        equipmentGroup: 'TL',
        dcCode: userInfo.defaultCenter ?? '',
      );
      if (apiResult.isFailure) {}
      final apiResultEquipment = await _taskHistoryRepo.getEquipment(
          content: contentEquipment, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultEquipment.isFailure) {
        emit(TaskHistoryDetailItemFailure(
            message: apiResultEquipment.getErrorMessage(),
            errorCode: apiResultEquipment.errorCode));
        return;
      }
      List<EquipmentResponse> apiEquipment = apiResultEquipment.data;
      emit(TaskHistoryDetailItemSuccess(
          detailItem: adetailItem, equipmentList: apiEquipment));
    } catch (e) {
      emit(TaskHistoryDetailItemFailure(message: strings.messError.tr()));
    }
  }

  Future<void> _mapUpdateWorkOrderWithDataToState(
      UpdateWordOrderWithDataLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is TaskHistoryDetailItemSuccess) {
        emit(TaskHistoryDetailItemLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final dataUpdateWorkOrder = UpdateWorkOrderRequest(
            woTaskId: event.woTaskId,
            dataValue: event.dataChange,
            dataType: event.type,
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
            sealNo: event.sealNo);

        if (event.type == 4) {
          //Check equipment
          final dataRequest = CheckEquipmentsRequest(
            equipmentCode: event.dataChange,
            equipmentDesc: "",
            equipTypeNo: "",
            ownership: "",
            equipmentGroup: "TL",
            dcCode: userInfo.defaultCenter ?? '',
          );
          final apiResultCheckEquipment = await _taskHistoryRepo.checkEquipment(
            equipmentsRequest: dataRequest,
            subsidiaryId: userInfo.subsidiaryId ?? '',
          );
          if (apiResultCheckEquipment.isFailure) {
            emit(TaskHistoryDetailItemFailure(
                message: apiResultCheckEquipment.getErrorMessage(),
                errorCode: apiResultCheckEquipment.errorCode));
            return;
          }
          // CheckEquipmentsResponse checkEquipment = apiResultCheckEquipment.data;
          StatusResponse checkEquipment = apiResultCheckEquipment.data;
          if (checkEquipment.isSuccess == true) {
            final apiResultTrailerNo =
                await _taskHistoryRepo.updateWordOrderWithDataType(
                    updateWorkOrderRequest: dataUpdateWorkOrder,
                    subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultTrailerNo.isFailure) {
              emit(TaskHistoryDetailItemFailure(
                  message: apiResultTrailerNo.getErrorMessage(),
                  errorCode: apiResultTrailerNo.errorCode));
              return;
            }
            StatusResponse updateTrailerNo = apiResultTrailerNo.data;
            if (updateTrailerNo.isSuccess == true) {
              final apiResultDetail =
                  await _taskHistoryRepo.getHistoryDetailItem(
                      dtdId: currentState.detailItem.dtdId!,
                      subsidiaryId: userInfo.subsidiaryId ?? '');
              if (apiResultDetail.isFailure) {
                emit(TaskHistoryDetailItemFailure(
                    message: apiResultDetail.getErrorMessage(),
                    errorCode: apiResultDetail.errorCode));
                return;
              }
              HistoryDetailItem apiGetHistoryDetailItem = apiResultDetail.data;
              emit(TaskHistoryDetailItemSuccess(
                  detailItem: apiGetHistoryDetailItem,
                  checkEquipment: true,
                  saveSuccess: true,
                  equipmentList: currentState.equipmentList));
            }
          } else {
            final apiResultDetail = await _taskHistoryRepo.getHistoryDetailItem(
                dtdId: currentState.detailItem.dtdId!,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultDetail.isFailure) {
              emit(TaskHistoryDetailItemFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            HistoryDetailItem apiGetHistoryDetailItem = apiResultDetail.data;
            emit(TaskHistoryDetailItemSuccess(
                detailItem: apiGetHistoryDetailItem,
                checkEquipment: false,
                equipmentList: currentState.equipmentList));

            return;
          }
        } else if (event.type == 1 || event.type == 2 || event.type == 3) {
          final apiResultUpdate =
              await _taskHistoryRepo.updateWordOrderWithDataType(
                  updateWorkOrderRequest: dataUpdateWorkOrder,
                  subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultUpdate.isFailure) {
            emit(TaskHistoryDetailItemFailure(
                message: apiResultUpdate.getErrorMessage(),
                errorCode: apiResultUpdate.errorCode));
            return;
          }
          StatusResponse updateWorkOrderResponse = apiResultUpdate.data;
          if (updateWorkOrderResponse.isSuccess == true) {
            final apiResultDetail = await _taskHistoryRepo.getHistoryDetailItem(
                dtdId: currentState.detailItem.dtdId!,
                subsidiaryId: userInfo.subsidiaryId ?? '');
            if (apiResultDetail.isFailure) {
              emit(TaskHistoryDetailItemFailure(
                  message: apiResultDetail.getErrorMessage(),
                  errorCode: apiResultDetail.errorCode));
              return;
            }
            HistoryDetailItem apiGetHistoryDetailItem = apiResultDetail.data;
            emit(TaskHistoryDetailItemSuccess(
                detailItem: apiGetHistoryDetailItem,
                saveSuccess: true,
                equipmentList: currentState.equipmentList));
          } else {
            if (updateWorkOrderResponse.message ==
                constants.errorNoUpdateCNTR) {
              emit(TaskHistoryDetailItemFailure(message: "5180".tr()));
            } else if (updateWorkOrderResponse.message ==
                constants.errorValidateFormatCNTR) {
              emit(TaskHistoryDetailItemFailure(message: "5486".tr()));
            } else {
              emit(const TaskHistoryDetailItemFailure(
                  message: strings.messError));
            }
            emit(currentState.copyWith(saveSuccess: false));
          }
        }
      }
    } catch (e) {
      emit(TaskHistoryDetailItemFailure(message: e.toString()));
    }
  }
}
