import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/mpi/timesheet/timesheet_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/data/shared/utils/find_date.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/mpi/timesheet/timesheets/timesheets.dart';

part 'timesheets_event.dart';
part 'timesheets_state.dart';

class TimesheetsBloc extends Bloc<TimesheetsEvent, TimesheetsState> {
  final _timesheetsRepo = getIt<TimesheetRepository>();

  int pageNumber = 1;
  int quantity = 0;
  bool endPage = false;
  List<TimesheetResult> timesheetLst = [];
  UserInfo? userInfo;
  TimesheetsBloc() : super(TimesheetsInitial()) {
    on<TimesheetsViewLoaded>(_mapViewLoadedToState);
    on<TimesheetsChangeDate>(_mapChangeDateToState);
    on<TimesheetsPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(TimesheetsViewLoaded event, emit) async {
    emit(TimesheetsLoading());
    try {
      pageNumber = 1;
      endPage = false;
      quantity = 0;
      timesheetLst.clear();
      final fromDate = event.fromDate ?? DateTime.now().firstDayOfMonth;
      final toDate = event.toDate ?? DateTime.now().lastDayOfMonth;
      final firstDay = event.fromDate == null
          ? FindDate.firstDateOfMonth_yyyyMMdd(today: DateTime.now())
          : DateFormat(constants.yyyyMMdd)
              .format(event.fromDate ?? DateTime.now());
      final lastDay = event.toDate == null
          ? FindDate.lastDateOfMonth_yyyyMMdd(today: DateTime.now())
          : DateFormat(constants.yyyyMMdd)
              .format(event.toDate ?? DateTime.now());
      final content = _getContentRequest(dateF: firstDay, dateT: lastDay);
      final sharedPref = await SharedPreferencesService.instance;

      ApiResult apiResult = await _timesheetsRepo.getTimesheets(
          content: content,
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiResult.isFailure) {
        emit(TimesheetsFailure(message: apiResult.getErrorMessage()));
        return;
      }
      MPiApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(TimesheetsFailure(message: apiResponse.error.errorMessage));
        return;
      }
      TimesheetResponse tsRes = apiResponse.payload;

      final timesheetList = tsRes.result ?? [];
      timesheetLst.addAll(timesheetList);
      quantity = tsRes.totalRecord ?? 0;
      emit(TimesheetsSuccess(
          timesheetsList: timesheetList,
          fromDate: fromDate,
          toDate: toDate,
          quantity: quantity,
          isLoading: false,
          isPagingLoading: false));
    } catch (e) {
      emit(TimesheetsFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeDateToState(TimesheetsChangeDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is TimesheetsSuccess) {
        pageNumber = 1;
        endPage = false;
        quantity = 0;
        timesheetLst.clear();

        emit(currentState.copyWith(isLoading: true));
        final sharedPref = await SharedPreferencesService.instance;

        final fromDate = event.fromDate;
        final toDate = event.toDate;

        final firstDay = FindDate.convertDateyyyyMMdd(
            today: event.fromDate ?? currentState.fromDate);

        final lastDay = FindDate.convertDateyyyyMMdd(
            today: event.toDate ?? currentState.toDate);
        log(firstDay.toString());
        log(lastDay.toString());
        final content = _getContentRequest(dateF: firstDay, dateT: lastDay);

        ApiResult apiResult = await _timesheetsRepo.getTimesheets(
            content: content,
            mpiUrl: sharedPref.serverMPi ?? '',
            baseUrl: sharedPref.serverAddress ?? '');
        if (apiResult.isFailure) {
          emit(TimesheetsFailure(message: apiResult.getErrorMessage()));
          return;
        }
        MPiApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(TimesheetsFailure(message: apiResponse.error.errorMessage));
          return;
        }
        TimesheetResponse tsRes = apiResponse.payload;

        final timesheetList = tsRes.result ?? [];
        timesheetLst.addAll(timesheetList);
        quantity = tsRes.totalRecord ?? 0;
        emit(currentState.copyWith(
            fromDate: fromDate,
            timesheetsList: timesheetList,
            toDate: toDate,
            quantity: quantity,
            isLoading: false));
      }
    } catch (e) {
      emit(TimesheetsFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(TimesheetsPaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is TimesheetsSuccess) {
        if (quantity == timesheetLst.length) {
          endPage = true;
          emit(currentState);
          return;
        }
        if (endPage == false) {
          emit(currentState.copyWith(isPagingLoading: true));

          pageNumber++;
          final firstDay =
              FindDate.convertDateyyyyMMdd(today: currentState.fromDate);

          final lastDay =
              FindDate.convertDateyyyyMMdd(today: currentState.toDate);
          final content = _getContentRequest(dateF: firstDay, dateT: lastDay);
          final sharedPref = await SharedPreferencesService.instance;

          ApiResult apiResult = await _timesheetsRepo.getTimesheets(
              content: content,
              mpiUrl: sharedPref.serverMPi ?? '',
              baseUrl: sharedPref.serverAddress ?? '');
          if (apiResult.isFailure) {
            emit(TimesheetsFailure(message: apiResult.getErrorMessage()));
            return;
          }
          MPiApiResponse apiResponse = apiResult.data;
          if (apiResponse.success == false) {
            emit(TimesheetsFailure(message: apiResponse.error.errorMessage));
            return;
          }
          TimesheetResponse tsRes = apiResponse.payload;

          final timesheetList = tsRes.result ?? [];
          if (timesheetList != [] && timesheetList.isNotEmpty) {
            timesheetLst.addAll(timesheetList);
          } else {
            endPage = true;
          }
          emit(currentState.copyWith(
              timesheetsList: timesheetLst, isPagingLoading: false));
        }
      }
    } catch (e) {
      emit(TimesheetsFailure(message: e.toString()));
    }
  }

  TimesheetsRequest _getContentRequest(
      {required String dateF, required String dateT}) {
    return TimesheetsRequest(
        status: '',
        userId: userInfo?.userId ?? '',
        employeeCode: userInfo?.empCode ?? '',
        submitDateF: dateF,
        submitDateT: dateT,
        isCheckTime: '0',
        skipRecord: 0,
        takeRecord: 10,
        pageNumber: pageNumber,
        rowNumber: constants.sizePaging);
  }
}
