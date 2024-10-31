// ignore_for_file: unused_field

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/repository/ha_driver_menu/driver_check_in/driver_check_in_repository.dart';
import 'package:igls_new/data/repository/ha_driver_menu/task_history/task_history_repo.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../general/general_bloc.dart';

part 'plan_transfer_event.dart';
part 'plan_transfer_state.dart';

class PlanTransferBloc extends Bloc<PlanTransferEvent, PlanTransferState> {
  final todoHaulageRepo = getIt<ToDoHaulageRepository>();
  final _driverCheckInRepo = getIt<DriverCheckInRepository>();
  final _repoTaskHistory = getIt<TaskHistoryRepository>();

  PlanTransferBloc() : super(PlanTransferInitial()) {
    on<PlanTransferLoaded>(_mapViewToState);
    on<PlanTransferSearch>(_mapSearchToState);
    on<PlanTransferUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewToState(PlanTransferLoaded event, emit) async {
    emit(PlanTransferLoading());
    try {
      emit(PlanTransferSuccess(task: event.task));
    } catch (e) {
      emit(PlanTransferFailure(message: 'MessError'.tr()));
    }
  }

  void _mapSearchToState(PlanTransferSearch event, emit) async {
    try {
      final currentState = state;
      if (currentState is PlanTransferSuccess) {
        emit(PlanTransferLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final dataRequest = CheckEquipmentsRequest(
          equipmentCode: event.tractorNo,
          equipmentDesc: "",
          equipTypeNo: "",
          ownership: "",
          equipmentGroup: "",
          dcCode: userInfo.defaultCenter ?? '',
        );

        final checkEquipment = await _repoTaskHistory.checkEquipment(
          equipmentsRequest: dataRequest,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (checkEquipment.isSuccess == true) {
          final apiResult = await _getTaskList(
              equipmentCode: event.tractorNo,
              subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResult.isFailure) {
            emit(PlanTransferFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }
          TodoHaulageResponse apiResponse = apiResult.data;
          List<TodoHaulageResult> listTodo =
              apiResponse.todoHaulageResult ?? [];
          emit(currentState.copyWith(listToDo: listTodo));
        } else {
          emit(PlanTransferFailure(message: 'no_searchs_equipment'.tr()));
          emit(currentState.copyWith(listToDo: []));
        }
      }
    } catch (e) {
      emit(PlanTransferFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(PlanTransferUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is PlanTransferSuccess) {
        emit(PlanTransferLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final eventTask = currentState.task;
        final content = PlanTransferRequest(
            woNo: eventTask.woNoOrginal!,
            woTaskId: eventTask.woTaskId!,
            priEquipmentCode: event.priEquipment,
            secEquipmentCode: eventTask.secEquipmentCode!,
            createUser: event.generalBloc.generalUserInfo?.userId ?? '',
            driverId: currentState.listToDo![0].driverId ?? '',
            dtdId: eventTask.dtdId!,
            dtId: eventTask.dtId!,
            dtIdChanged: currentState.listToDo![0].dtId ?? 0);
        final apiResponse = await todoHaulageRepo.getUpdateTransfer(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResponse.isSuccess != true) {
          emit(const PlanTransferFailure(message: strings.messError));
          return;
        }

        final apiResult = await _getTaskList(
            equipmentCode: event.priEquipment,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(PlanTransferFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        TodoHaulageResponse apiResponse1 = apiResult.data;
        List<TodoHaulageResult> listTodo = apiResponse1.todoHaulageResult ?? [];
        emit(currentState.copyWith(isSuccess: true, listToDo: listTodo));
      }
    } catch (e) {
      emit(const PlanTransferFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getTaskList(
      {required String equipmentCode, required String subsidiaryId}) async {
    final dateFrom = DateFormat(constants.formatMMddyyyy)
        .format(DateTime.now().add(const Duration(days: -5)));
    final dateTo = DateFormat(constants.formatMMddyyyy)
        .format(DateTime.now().add(const Duration(days: 5)));
    final contentListTodo = ListToDoHaulageRequest(
        dateFrom: dateFrom,
        dateTo: dateTo,
        equipmentCode: equipmentCode,
        isOnlyPending: '1',
        pageNumber: 1, //hardcode
        pageSize: 2 //hardcode
        ); //hard
    return await todoHaulageRepo.getListToDoHaulage(
        content: contentListTodo, subsidiaryId: subsidiaryId);
  }
}
