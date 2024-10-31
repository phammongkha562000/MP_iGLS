// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';

part 'task_history_event.dart';
part 'task_history_state.dart';

class TaskHistoryBloc extends Bloc<TaskHistoryEvent, TaskHistoryState> {
  final _taskHistoryRepo = getIt<TaskHistoryRepository>();
  TaskHistoryBloc() : super(TaskHistoryInitial()) {
    on<TaskHistoryLoaded>(_mapViewToState);
    on<TaskHistoryPreviousMonthLoaded>(_mapPreviousToState);
    on<TaskHistoryNextMonthLoaded>(_mapNextToState);
    on<TaskHistoryFilterLoaded>(_mapFilterToState);
  }

  Future<void> _mapViewToState(TaskHistoryLoaded event, emit) async {
    try {
      emit(TaskHistoryLoading());

      final sharedPref = await SharedPreferencesService.instance;

      final equipmentCode = sharedPref.equipmentNo;
      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      if (equipmentCode == null || equipmentCode == "" || driverId == "") {
        emit(const TaskHistoryFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        emit(const TaskHistorySuccess(listTask: [], eventStatus: ''));
        return;
      }
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult = await taskByMonth(
          subsidiaryId: userInfo.subsidiaryId ?? "",
          eventDate: event.dateTime ?? DateTime.now(),
          eventStatus: event.status ?? '',
          empCode: driverId);
      if (apiResult.isFailure) {
        emit(TaskHistoryFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      ApiResponse apiRes = apiResult.data;
      TaskHistoryResponse? taskResponse = apiRes.payload;

      List<TaskHistoryResult> listTask =
          taskResponse == null ? [] : taskResponse.results ?? [];
      log("Status: ${event.status}");

      emit(TaskHistorySuccess(
          dateTime: event.dateTime,
          listTask: listTask,
          eventStatus: event.status!));
    } catch (e) {
      emit(TaskHistoryFailure(message: strings.messError.tr()));
    }
  }

  Future<void> _mapFilterToState(TaskHistoryFilterLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is TaskHistorySuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await taskByMonth(
            subsidiaryId: userInfo.subsidiaryId ?? "",
            empCode: event.generalBloc.generalUserInfo?.empCode ?? '',
            eventDate: currentState.dateTime ?? DateTime.now(),
            eventStatus: event.status ?? '');
        log("Status: ${event.status}");
        if (apiResult.isFailure) {
          emit(TaskHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiRes = apiResult.data;
        TaskHistoryResponse? taskResponse = apiRes.payload;

        List<TaskHistoryResult> listTask =
            taskResponse == null ? [] : taskResponse.results ?? [];
        emit(currentState.copyWith(
            listTask: listTask, eventStatus: event.status));
      }
    } catch (e) {
      emit(TaskHistoryFailure(message: strings.messError.tr()));
    }
  }

  Future<void> _mapPreviousToState(
      TaskHistoryPreviousMonthLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is TaskHistorySuccess) {
        final eventDate = DateTime(
            currentState.dateTime!.year,
            currentState.dateTime!.month - 1,
            15); //lấy ngày 15 của tháng hiện tại, trừ 1 tháng
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await taskByMonth(
            subsidiaryId: userInfo.subsidiaryId ?? "",
            empCode: event.generalBloc.generalUserInfo?.empCode ?? '',
            eventDate: eventDate,
            eventStatus: currentState.eventStatus);
        if (apiResult.isFailure) {
          emit(TaskHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        // List<TaskHistoryResponse> listTask = apiResult.data;
        ApiResponse apiRes = apiResult.data;
        TaskHistoryResponse? taskResponse = apiRes.payload;

        List<TaskHistoryResult> listTask =
            taskResponse == null ? [] : taskResponse.results ?? [];
        emit(currentState.copyWith(listTask: listTask, dateTime: eventDate));
      }
    } catch (e) {
      emit(const TaskHistoryFailure(message: strings.messError));
    }
  }

  Future<void> _mapNextToState(TaskHistoryNextMonthLoaded event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final currentState = state;
      if (currentState is TaskHistorySuccess) {
        final eventDate = DateTime(
            currentState.dateTime!.year,
            currentState.dateTime!.month + 1,
            15); //lấy ngày 15 của tháng hiện tại, trừ 1 tháng
        final apiResult = await taskByMonth(
            subsidiaryId: userInfo.subsidiaryId ?? "",
            empCode: event.generalBloc.generalUserInfo?.empCode ?? '',
            eventDate: eventDate,
            eventStatus: currentState.eventStatus);
        if (apiResult.isFailure) {
          emit(TaskHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        // List<TaskHistoryResponse> listTask = apiResult.data;
        ApiResponse apiRes = apiResult.data;
        TaskHistoryResponse? taskResponse = apiRes.payload;

        List<TaskHistoryResult> listTask =
            taskResponse == null ? [] : taskResponse.results ?? [];
        emit(currentState.copyWith(listTask: listTask, dateTime: eventDate));
      }
    } catch (e) {
      emit(const TaskHistoryFailure(message: strings.messError));
    }
  }

  Future<ApiResult> taskByMonth(
      {required DateTime eventDate,
      required String eventStatus,
      required String empCode,
      required String subsidiaryId}) async {
    final date = DateFormat(constants.formatyyyyMMdd)
        .format(DateTime(eventDate.year, eventDate.month, 15));
    final dataRequest = TaskHistoryRequest(
        driverId: empCode,
        equipmentCode: "",
        status: eventStatus,
        taskDate: date);

    return await _taskHistoryRepo.getTaskHistory(
        content: dataRequest, subsidiaryId: subsidiaryId);
  }
}
 