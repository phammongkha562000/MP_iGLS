import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/mpi/common/mpi_std_code_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_request.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_update_wh_request.dart';
import 'package:igls_new/data/repository/mpi/timesheet/timesheet_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/datetime_format.dart';

part 'timesheets_detail_event.dart';
part 'timesheets_detail_state.dart';

class TimesheetsDetailBloc
    extends Bloc<TimesheetsDetailEvent, TimesheetsDetailState> {
  final _timesheetsRepo = getIt<TimesheetRepository>();

  TimesheetsDetailBloc() : super(TimesheetsDetailInitial()) {
    on<TimesheetsDetailViewLoaded>(_mapViewLoadedToState);
    on<TimesheetsDetailUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(
      TimesheetsDetailViewLoaded event, emit) async {
    emit(TimesheetsDetailLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiResult = await _timesheetsRepo.getStdCodeWithType(
          typeStdCode: 'TSPOSTTYPE',
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiResult.isFailure) {
        emit(TimesheetsDetailFailure(message: apiResult.getErrorMessage()));
        return;
      }
      ApiResponse apiRes = apiResult.data;
      if (apiRes.success == false) {
        emit(TimesheetsDetailFailure(message: apiRes.error?.message));
        return;
      }

      List<MPiStdCode> listTSPostType = apiRes.payload ?? [];

      emit(TimesheetsDetailSuccess(
        timesheetsItem: event.timesheetsItem,
        name: event.generalBloc.generalUserInfo?.userName ?? '',
        stdCodeList: listTSPostType,
        updateSuccess: false, /* employeeId: globalUser.employeeId ?? 0 */
      ));
    } catch (e) {
      emit(TimesheetsDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(TimesheetsDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is TimesheetsDetailSuccess) {
        emit(currentState.copyWith(updateSuccess: false));
        emit(TimesheetsDetailLoading());
        final sharedPref = await SharedPreferencesService.instance;

        final content = event.timesheets;
        ApiResult apiResult = await _timesheetsRepo.updateTimesheets(
            content: content,
            mpiUrl: sharedPref.serverMPi ?? '',
            baseUrl: sharedPref.serverAddress ?? '');
        if (apiResult.isFailure) {
          emit(TimesheetsDetailFailure(message: apiResult.getErrorMessage()));
          return;
        }
        MPiApiResponse apiTimesheetDetail = apiResult.data;

        if (!apiTimesheetDetail.success ||
            apiTimesheetDetail.error.errorCode != null) {
          emit(TimesheetsDetailFailure(
              message: apiTimesheetDetail.error.errorMessage));
          return;
        }

        final firstDay =
            '${FormatDateConstants.convertUTCDateTimeShort2(currentState.timesheetsItem.startTime!)} 00:00:00';
        final lastDay =
            '${FormatDateConstants.convertUTCDateTimeShort2(currentState.timesheetsItem.endTime!)} 23:59:59';

        final contentTimesheet = TimesheetsRequest(
            status: '',
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            employeeCode: event.generalBloc.generalUserInfo?.empCode ?? '',
            submitDateF: firstDay,
            submitDateT: lastDay,
            isCheckTime: '0',
            skipRecord: 0,
            takeRecord: 10,
            pageNumber: 1,
            rowNumber: 1);
        ApiResult apiResultGetTS = await _timesheetsRepo.getTimesheets(
            content: contentTimesheet,
            mpiUrl: sharedPref.serverMPi ?? '',
            baseUrl: sharedPref.serverAddress ?? '');

        if (apiResultGetTS.isFailure) {
          emit(TimesheetsDetailFailure(
              message: apiResultGetTS.getErrorMessage()));
          return;
        }
        MPiApiResponse apiTimesheet = apiResultGetTS.data;
        TimesheetResponse tsRes = apiTimesheet.payload;
        List<TimesheetResult> tsLst = tsRes.result ?? [];

        emit(currentState.copyWith(
            updateSuccess: true, timesheetsItem: tsLst.first));
      }
    } catch (e) {
      emit(TimesheetsDetailFailure(message: e.toString()));
    }
  }
}
