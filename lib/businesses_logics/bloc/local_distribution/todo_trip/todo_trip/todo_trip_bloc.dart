import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/todo_request.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

import '../../../general/general_bloc.dart';

part 'todo_trip_event.dart';
part 'todo_trip_state.dart';

class ToDoTripBloc extends Bloc<ToDoTripEvent, ToDoTripState> {
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  final _driverCheckInRepo = getIt<DriverCheckInRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<TodoResult> todoLst = [];
  ToDoTripBloc() : super(ToDoTripInitial()) {
    on<ToDoTripViewLoaded>(_mapViewLoadedToState);
    on<ToDoTripCheckIn>(_mapCheckInToState);
    on<TodoTripPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(ToDoTripViewLoaded event, emit) async {
    emit(ToDoTripLoading());
    try {
      pageNumber = 1;
      endPage = false;
      todoLst.clear();
      quantity = 0;

      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final fromDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);

      final vehicleNo = sharedPref.equipmentNo;
      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      if (vehicleNo == null || vehicleNo == "" || driverId == "") {
        emit(const ToDoTripFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));

        emit(ToDoTripSuccess(
            normalTripList: const [],
            simpleTripList: const [],
            normalTripPending: const [],
            simpleTripPending: const [],
            equipmentNo: '',
            isAddTrip: false,
            serverWcf: '',
            url: '',
            userID: '',
            quantity: quantity,
            isPagingLoading: false));
        return;
      }

      final apiResult = await _driverCheckInRepo.getDriverTodayInfo(
          driverId: driverId,
          equipmentCode: sharedPref.equipmentNo,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(ToDoTripFailure(
          message: apiResult.getErrorMessage(),
          errorCode: apiResult.errorCode,
        ));
        return;
      }
      /* final dateValue = DateFormat(constants.yyyyMMdd).format(DateTime.now());

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
        emit(ToDoTripFailure(message: apiResult.getErrorMessage()));
        return;
      }
      MPiApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(ToDoTripFailure(message: apiResponse.error.errorMessage));
        return;
      }
      TimesheetResponse tsRes = apiResponse.payload;

      final timesheetList = tsRes.result ?? []; */

      DriverTodayInfo apiTodayInfo = apiResult.data;
      List<TodoResult> normalTrip = [];
      List<TodoResult> simpleTrip = [];
      List<TodoResult> normalTripPending = [];
      List<TodoResult> simpleTripPending = [];
      if (apiTodayInfo.equipmentCode != null) {
        final apiResult = await _toDoTripRepo.getListToDoTrips(
          content: TodoRequest(
              equipmentCode: '',
              driverId: driverId,
              etp: fromDate,
              companyId: userInfo.subsidiaryId ?? '',
              pageNumber: pageNumber,
              pageSize: constants.sizePaging),
        );
        if (apiResult.isFailure) {
          emit(ToDoTripFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode,
          ));
          return;
        }
        ApiResponse apiRes = apiResult.data;
        TodoResponse todoRes = apiRes.payload;
        List<TodoResult> todoList = todoRes.results ?? [];
        todoLst.addAll(todoList);
        quantity = todoRes.totalCount ?? 0;
        // ToDoTripResponse apiResponse = apiResult.data;
        normalTrip =
            todoLst.where((element) => element.tripType == 'Normal').toList();
        simpleTrip =
            todoLst.where((element) => element.tripType == 'Simple').toList();
      }
      // driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
      //     fromDate: fromDate,
      //     equipmentCode: '', //08/08/2023
      //     subsidiaryId: userInfo.subsidiaryId ?? ''

      normalTripPending = normalTrip
          .where((elm) => (elm.tripStatus == 'PICKUP_ARRIVAL' ||
              elm.tripStatus == 'START_DELIVERY'))
          .toList();
      for (var element in normalTripPending) {
        normalTrip.remove(element);
      }
      simpleTripPending = simpleTrip
          .where((elm) => (elm.tripStatus == 'PICKUP_ARRIVAL' ||
              elm.tripStatus == 'START_DELIVERY'))
          .toList();
      for (var element in simpleTripPending) {
        simpleTrip.remove(element);
      }

      final userId = event.generalBloc.generalUserInfo?.userId ?? '';

      final List<PageMenuPermissions> pageLocal = event.generalBloc.listMenu;
      final isAdd = pageLocal.where(
          (element) => element.tagVariant == constants.caseAddNewSimpleTrip);
      log(sharedPref.equipmentNo.toString());

      emit(ToDoTripSuccess(
          dateCheckIn: apiTodayInfo.onDate,
          isAddTrip: isAdd.isNotEmpty ? true : false,
          userID: userId,
          serverWcf: sharedPref.serverWcf!,
          url: endpoints.urlCheckListToDoTrip,
          normalTripList: normalTrip,
          simpleTripList: simpleTrip,
          normalTripPending: normalTripPending,
          simpleTripPending: simpleTripPending,
          equipmentNo: vehicleNo,
          quantity: quantity,
          isPagingLoading: false));
    } catch (e) {
      emit(ToDoTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapCheckInToState(ToDoTripCheckIn event, emit) async {
    try {
      final currentState = state;
      if (currentState is ToDoTripSuccess) {
        emit(ToDoTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final sharedPref = await SharedPreferencesService.instance;
        final userId = event.generalBloc.generalUserInfo?.userId ?? '';
        final dcCode = userInfo.defaultCenter;
        final equipmentCode = sharedPref.equipmentNo;
        final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
        final content = DriverCheckInRequest(
            equipmentCode: equipmentCode!.trim(),
            dcCode: dcCode!,
            driverId: driverId,
            userId: userId,
            onDate: DateFormat(constants.formatyyyyMMddHHmm)
                .format(DateTime.now()));
        final apiResult = await _driverCheckInRepo.saveDriverCheckIn(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(ToDoTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        StatusResponse apiSave = apiResult.data;
        if (apiSave.isSuccess != true) {
          emit(const ToDoTripFailure(message: strings.messError));
          return;
        }

        emit(currentState.copyWith(isSuccess: true));
        add(ToDoTripViewLoaded(generalBloc: event.generalBloc));
      }
    } catch (e) {
      emit(ToDoTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(TodoTripPaging event, emit) async {
    try {
      if (quantity == todoLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        final currentState = state;
        if (currentState is ToDoTripSuccess) {
          emit(currentState.copyWith(isPagingLoading: true));
          pageNumber++;

          final sharedPref = await SharedPreferencesService.instance;
          UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

          final fromDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);

          final vehicleNo = sharedPref.equipmentNo;
          final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
          if (vehicleNo == null || vehicleNo == "" || driverId == "") {
            emit(const ToDoTripFailure(
                message: strings.messErrorNoEquipment,
                errorCode: constants.errorNullEquipDriverId));

            emit(ToDoTripSuccess(
                normalTripList: const [],
                simpleTripList: const [],
                normalTripPending: const [],
                simpleTripPending: const [],
                equipmentNo: '',
                isAddTrip: false,
                serverWcf: '',
                url: '',
                userID: '',
                quantity: quantity,
                isPagingLoading: false));
            return;
          }
          final apiResult = await _driverCheckInRepo.getDriverTodayInfo(
              driverId: driverId,
              equipmentCode: sharedPref.equipmentNo,
              subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResult.isFailure) {
            emit(ToDoTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode,
            ));
            return;
          }

          DriverTodayInfo apiTodayInfo = apiResult.data;
          List<TodoResult> normalTrip = [];
          List<TodoResult> simpleTrip = [];
          List<TodoResult> normalTripPending = [];
          List<TodoResult> simpleTripPending = [];
          if (apiTodayInfo.equipmentCode != null) {
            // driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
            //     fromDate: fromDate,
            //     equipmentCode: '', //08/08/2023
            //     subsidiaryId: userInfo.subsidiaryId ?? ''
            final apiResult = await _toDoTripRepo.getListToDoTrips(
              content: TodoRequest(
                  equipmentCode: '',
                  driverId: driverId,
                  etp: fromDate,
                  companyId: userInfo.subsidiaryId ?? '',
                  pageNumber: pageNumber, //hardcode
                  pageSize: constants.sizePaging), //hardcode
            );
            if (apiResult.isFailure) {
              emit(ToDoTripFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode,
              ));
              return;
            }
            ApiResponse apiRes = apiResult.data;
            TodoResponse todoRes = apiRes.payload;
            List<TodoResult> todoList = todoRes.results ?? [];
            if (todoList.isNotEmpty && todoList != []) {
              todoLst.addAll(todoList);
            } else {
              endPage = true;
            }
            // ToDoTripResponse apiResponse = apiResult.data;
            normalTrip = todoLst
                .where((element) => element.tripType == 'Normal')
                .toList();
            simpleTrip = todoLst
                .where((element) => element.tripType == 'Simple')
                .toList();
          }

          normalTripPending = normalTrip
              .where((elm) => (elm.tripStatus == 'PICKUP_ARRIVAL' ||
                  elm.tripStatus == 'START_DELIVERY'))
              .toList();
          for (var element in normalTripPending) {
            normalTrip.remove(element);
          }
          simpleTripPending = simpleTrip
              .where((elm) => (elm.tripStatus == 'PICKUP_ARRIVAL' ||
                  elm.tripStatus == 'START_DELIVERY'))
              .toList();
          for (var element in simpleTripPending) {
            simpleTrip.remove(element);
          }

          emit(currentState.copyWith(
              normalTripList: normalTrip,
              simpleTripList: simpleTrip,
              normalTripPending: normalTripPending,
              simpleTripPending: simpleTripPending,
              isPagingLoading: false));
        }
      }
    } catch (e) {
      emit(ToDoTripFailure(message: e.toString()));
    }
  }
}
