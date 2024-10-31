import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/services/result/result.dart';
import '../../../general/general_bloc.dart';

part 'todo_haulage_event.dart';
part 'todo_haulage_state.dart';

class ToDoHaulageBloc extends Bloc<ToDoHaulageEvent, ToDoHaulageState> {
  final todoHaulageRepo = getIt<ToDoHaulageRepository>();
  // final _timesheetsRepo = getIt<TimesheetRepository>();
  final _driverCheckInRepo = getIt<DriverCheckInRepository>();
  int pageNumber = 1;
  bool endPage = false;
  List<TodoHaulageResult> todoLst = [];

  bool isCheckIn = false;
  int quantity = 0;
  ToDoHaulageBloc() : super(ToDoHaulageInitial()) {
    on<ToDoHaulageViewLoaded>(_mapViewLoadedToState);
    on<ToDoHaulageCheckIn>(_mapCheckInToState);
    on<TodoHaulagePaging>(_mapPagingToState);
  }

  void _mapViewLoadedToState(
      ToDoHaulageViewLoaded event, Emitter<ToDoHaulageState> emit) async {
    emit(ToDoHaulageLoading());
    try {
      endPage = false;
      pageNumber = 1;
      todoLst.clear();
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final equipmentCode = sharedPref.equipmentNo;

      final driverId = userInfo.empCode ?? '';

      if (equipmentCode == null || equipmentCode == "" || driverId == "") {
        emit(const ToDoHaulageFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        emit(const ToDoHaulageSuccess(listToDo: [], quantity: 0, dateTime: ''));
        return;
      }
      final apiResultCheckinToday = await _driverCheckInRepo.getDriverTodayInfo(
        driverId: driverId,
        equipmentCode: equipmentCode,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (apiResultCheckinToday.isFailure) {
        emit(ToDoHaulageFailure(
            message: apiResultCheckinToday.getErrorMessage(),
            errorCode: apiResultCheckinToday.errorCode));
        return;
      }
      DriverTodayInfo apiTodayInfo = apiResultCheckinToday.data;

      /*
      final dateValue = DateFormat(constants.yyyyMMdd).format(DateTime.now());
      
       TimesheetsRequest content = TimesheetsRequest(
          status: '',
          userId: userInfo.userId ?? '',
          employeeCode: userInfo.empCode ?? '',
          submitDateF: dateValue,
          submitDateT: dateValue,
          isCheckTime: '0',
          skipRecord: 0,
          takeRecord: 10,
          pageNumber: pageNumber,
          rowNumber: constants.sizePaging);

      ApiResult apiResult = await _timesheetsRepo.getTimesheets(
          content: content,
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiResult.isFailure) {
        emit(ToDoHaulageFailure(message: apiResult.getErrorMessage()));
        return;
      }
      MPiApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(ToDoHaulageFailure(message: apiResponse.error.errorMessage));
        return;
      }
      TimesheetResponse tsRes = apiResponse.payload;

      final timesheetList = tsRes.result ?? []; */

      List<TodoHaulageResult> listToDo = [];

      /* if (timesheetList != [] && timesheetList.isNotEmpty) {
        DateTime startTime = FormatDateConstants.convertUTCtoDateTime(
            timesheetList[0].startTime!);
        if (startTime.hour != 0 && startTime.minute != 0) { */
      if (apiTodayInfo.equipmentCode != null) {
        isCheckIn = true;
        final dateFrom = DateFormat(constants.formatMMddyyyy)
            .format(DateTime.now().subtract(const Duration(days: 40)));
        final dateTo = DateFormat(constants.formatMMddyyyy)
            .format(DateTime.now().add(const Duration(days: 5)));
        final contentListTodo = ListToDoHaulageRequest(
            dateFrom: dateFrom,
            dateTo: dateTo,
            equipmentCode: '', //sửa 07/08/2023
            driverID: driverId,
            isOnlyPending: '1',
            pageNumber: pageNumber,
            pageSize: constants.sizePaging); //hard
        final apiResult = await todoHaulageRepo.getListToDoHaulage(
            content: contentListTodo,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(ToDoHaulageFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(ToDoHaulageFailure(
              message: apiResponse.error?.message,
              errorCode: apiResponse.error?.errorCode));
          return;
        }
        TodoHaulageResponse todoHaulageRes = apiResponse.payload;
        listToDo = todoHaulageRes.todoHaulageResult ?? [];
        todoLst.addAll(listToDo);
        quantity = todoHaulageRes.totalCount ?? 0;
      }
      /* } */

      emit(ToDoHaulageSuccess(
          dateTime: apiTodayInfo.onDate,
          listToDo: listToDo,
          quantity: quantity));
    } catch (e) {
      emit(ToDoHaulageFailure(message: e.toString()));
    }
  }

  Future<void> _mapCheckInToState(ToDoHaulageCheckIn event, emit) async {
    try {
      emit(ToDoHaulageLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final sharedPref = await SharedPreferencesService.instance;
      final userId = event.generalBloc.generalUserInfo?.userId ?? '';
      final dcCode = userInfo.defaultCenter;
      final equipmentCode = sharedPref.equipmentNo;
      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      final content = DriverCheckInRequest(
          equipmentCode: equipmentCode!,
          dcCode: dcCode!,
          driverId: driverId,
          userId: userId,
          onDate:
              DateFormat(constants.formatyyyyMMddHHmm).format(DateTime.now()));
      final apiResultSave = await _driverCheckInRepo.saveDriverCheckIn(
          content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultSave.isFailure) {
        emit(ToDoHaulageFailure(
            message: apiResultSave.getErrorMessage(),
            errorCode: apiResultSave.errorCode));
        return;
      }
      StatusResponse apiSave = apiResultSave.data;

      if (apiSave.isSuccess != true) {
        emit(ToDoHaulageFailure(message: apiSave.message.toString()));
        return;
      }
      add(ToDoHaulageViewLoaded(generalBloc: event.generalBloc));
    } catch (e) {
      emit(ToDoHaulageFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(TodoHaulagePaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoHaulageSuccess) {
        if (todoLst.length == quantity) {
          endPage = true;
          emit(currentState);
          return;
        }
        if (endPage == false) {
          emit(ToDoHaulagePagingLoading());

          pageNumber++;
          UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
          final dateFrom = DateFormat(constants.formatMMddyyyy)
              .format(DateTime.now().subtract(const Duration(days: 40)));
          final dateTo = DateFormat(constants.formatMMddyyyy)
              .format(DateTime.now().add(const Duration(days: 5)));
          final contentListTodo = ListToDoHaulageRequest(
              dateFrom: dateFrom,
              dateTo: dateTo,
              equipmentCode: '', //sửa 07/08/2023
              driverID: userInfo.empCode ?? '',
              isOnlyPending: '1',
              pageNumber: pageNumber,
              pageSize: constants.sizePaging); //hard
          final apiResult = await todoHaulageRepo.getListToDoHaulage(
              content: contentListTodo,
              subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResult.isFailure) {
            emit(ToDoHaulageFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResult.data;
          if (apiResponse.success == false) {
            emit(ToDoHaulageFailure(
                message: apiResponse.error?.message,
                errorCode: apiResponse.error?.errorCode));
            return;
          }
          TodoHaulageResponse todoHaulageRes = apiResponse.payload;
          List<TodoHaulageResult> todoHaulageLst =
              todoHaulageRes.todoHaulageResult ?? [];
          if (todoHaulageLst != [] && todoHaulageLst.isNotEmpty) {
            todoLst.addAll(todoHaulageLst);
            emit(ToDoHaulageSuccess(
                listToDo: todoLst,
                dateTime: currentState.dateTime,
                quantity: quantity));
          } else {
            endPage = true;
            emit(currentState);
          }
        }
      }
    } catch (e) {
      emit(ToDoHaulageFailure(message: e.toString()));
    }
  }
}
