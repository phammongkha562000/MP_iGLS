import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/mpi/common/mpi_std_code_response.dart';
import 'package:igls_new/data/models/mpi/common/work_flow_request.dart';
import 'package:igls_new/data/models/mpi/common/work_flow_response.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/check_leave_request.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/check_leave_response.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/new_leave_request.dart';
import 'package:igls_new/data/repository/mpi/leave/leave_repository.dart';
import 'package:igls_new/data/repository/mpi/timesheet/timesheet_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/screen/mpi/leave/add_leave_view.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'add_leave_event.dart';
part 'add_leave_state.dart';

class AddLeaveBloc extends Bloc<AddLeaveEvent, AddLeaveState> {
  final _leaveRepo = getIt<LeaveRepository>();
  final _timesheetsRepo = getIt<TimesheetRepository>();

  GeneralBloc? generalBloc;

  AddLeaveBloc() : super(AddLeaveInitial()) {
    on<AddLeaveLoaded>(_mapViewToState);
    on<AddLeaveChangeFromDate>(_mapChangeFromDate);
    on<AddLeaveChangeToDate>(_mapChangeToDate);
    on<AddLeaveChangeTypeLeave>(_mapChangeTypeLeave);
    on<AddLeaveUploadImage>(_mapChooseImage);
    on<AddLeaveSubmit>(_mapAddLeaveToState);
  }
  Future<void> _mapViewToState(AddLeaveLoaded event, emit) async {
    try {
      emit(AddLeaveLoading());
      final sharedPref = await SharedPreferencesService.instance;

      final apiResult = await _timesheetsRepo.getStdCodeWithType(
          typeStdCode: 'HRLEAVETYPE',
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiResult.isFailure) {
        emit(AddLeaveFailure(message: apiResult.getErrorMessage()));
        return;
      }
      ApiResponse apiRes = apiResult.data;
      if (apiRes.success == false) {
        emit(AddLeaveFailure(message: apiRes.error?.message));
        return;
      }

      List<MPiStdCode> listTSPostType = apiRes.payload ?? [];

      final requestWorkflow = WorkFlowRequest(
          applicationCode: "HLV",
          deptCode: generalBloc?.generalUserInfo?.department!.trim() ?? '',
          divisionCode: generalBloc?.generalUserInfo?.divisionCode ?? '',
          empId: 0,
          employeeCode: generalBloc?.generalUserInfo?.empCode ?? '',
          localAmount: 0,
          subsidiryId: generalBloc?.generalUserInfo?.subsidiaryId ?? '');

      List<WorkFlowResponse> workFlow = [];
      final apitResultWorkflow = await _timesheetsRepo.getWorkFlow(
          content: requestWorkflow,
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apitResultWorkflow.isFailure) {
        emit(AddLeaveFailure(message: apitResultWorkflow.getErrorMessage()));
        return;
      }
      //*Cấn cấn
      MPiApiResponse apiResWL = apitResultWorkflow.data;
      if (apiResWL.success != true) {
        emit(AddLeaveFailure(message: apiResWL.error.errorMessage));
        return;
      }
      workFlow = apiResWL.payload;
    
      emit(AddLeaveLoadSuccess(
          calDate: 1,
          fromDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          toDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          listStdCodeHr: listTSPostType,
          workFlow: workFlow,
          leaveResponse: null,
          pathImg: "",
          phoneNumber: generalBloc?.generalUserInfo?.mobileNo ?? ''));
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeFromDate(AddLeaveChangeFromDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddLeaveLoadSuccess) {
        emit(AddLeaveLoading());
        final division = event.divisionCode;

        double calDate = calculatorDate(
            division: division,
            fromDate: event.fromDate,
            toDate: event.fromDate,);
        emit(currentState.copyWith(
            fromDate: event.fromDate,
            toDate: event.fromDate,
            calDate: calDate));
      }
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeToDate(AddLeaveChangeToDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddLeaveLoadSuccess) {
        emit(AddLeaveLoading());

        double calDate = calculatorDate(
            fromDate: currentState.fromDate,
            toDate: event.toDate,
            division: event.divisionCode);
        emit(currentState.copyWith(
            toDate: event.toDate,
            leaveResponse: currentState.leaveResponse,
            calDate: calDate));
      }
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeTypeLeave(AddLeaveChangeTypeLeave event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddLeaveLoadSuccess) {
        emit(AddLeaveLoading());
        final sharedPref = await SharedPreferencesService.instance;

        final dataRequest = CheckLeaveRequest(
          employeeCode: generalBloc?.generalUserInfo?.empCode ?? '',
          leavetype: event.typeLeave.codeId,
          lyear: DateTime.now().year.toString(),
        );

        ApiResult apiResult = await _leaveRepo.checkLeaveWithType(
            content: dataRequest,
            mpiUrl: sharedPref.serverMPi ?? '',
            baseUrl: sharedPref.serverAddress ?? '');
        if (apiResult.isFailure) {
          // Error error = apiResult.getErrorResponse();
          emit(AddLeaveFailure(message: apiResult.getErrorMessage()));
          return;
        }
        MPiApiResponse checkLeave = apiResult.data;
        CheckLeaveResponse leaveResponse;
        if (checkLeave.success == true) {
          if (checkLeave.payload != null) {
            leaveResponse = checkLeave.payload;
          } else {
            leaveResponse = CheckLeaveResponse(balance: 0);
          }

          emit(currentState.copyWith(
            typeLeave: event.typeLeave,
            leaveResponse: leaveResponse,
          ));
        } else {
          emit(AddLeaveFailure(message: checkLeave.error.errorMessage));
        }
      }
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChooseImage(AddLeaveUploadImage event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddLeaveLoadSuccess) {
        if (event.pathImg.isNotEmpty) {
          emit(AddLeaveLoading());

          emit(currentState.copyWith(pathImg: event.pathImg));
        } else {
          emit(AddLeaveFailure(message: "no_data".tr()));
        }
      }
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapAddLeaveToState(AddLeaveSubmit event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddLeaveLoadSuccess) {
        emit(AddLeaveLoading());
        final sharedPref = await SharedPreferencesService.instance;

        final request = NewLeaveRequest(
          employeeId: 0,
          employeeCode: generalBloc?.generalUserInfo?.empCode ?? '',
          fromDate:
              DateFormat(constants.yyyyMMdd).format(currentState.fromDate),
          toDate: DateFormat(constants.yyyyMMdd).format(currentState.toDate),
          leaveDays: currentState.calDate,
          leaveStatus: "NEW",
          leaveType: currentState.typeLeave!.codeId.toString(),
          // userId: int.parse(globalUser.employeeId.toString()),
          marker: /* isSarturday(
                  fromDate: currentState.fromDate, toDate: currentState.toDate)
              ? 'AM'
              : */
              'FULL',
          remark: event.remark,
        );
        ApiResult apiResult = await _leaveRepo.createNewLeave(
            content: request,
            mpiUrl: sharedPref.serverMPi ?? '',
            baseUrl: sharedPref.serverAddress ?? '');
        if (apiResult.isFailure) {
          // Error error = apiResult.getErrorResponse();
          emit(AddLeaveFailure(message: apiResult.getErrorMessage()));
          return;
        }
        MPiApiResponse createNewLeave = apiResult.data;
        if (createNewLeave.success == true && createNewLeave.payload != null) {
          log("$createNewLeave");
          if (createNewLeave.payload == "") {
            emit(AddLeaveFailure(message: "5712".tr()));
          } else {
            emit(AddLeaveSuccessfully());
          }
        } else {
          emit(AddLeaveFailure(
              message: createNewLeave.error.errorMessage ?? ''));
        }
      }
    } catch (e) {
      emit(AddLeaveFailure(message: e.toString()));
    }
  }

  // bool isSarturday({required DateTime fromDate, required DateTime toDate}) {
  //   final from = DateFormat(constants.ddMMyyyySlash).format(fromDate);
  //   final to = DateFormat(constants.ddMMyyyySlash).format(toDate);
  //   if (from == to) {
  //     for (int i = 0; i <= toDate.difference(fromDate).inDays;) {
  //       var weekday = fromDate.add(Duration(days: i)).weekday;
  //       if (weekday == 6) {
  //         return true;
  //       }
  //       return false;
  //     }
  //   }
  //   return false;
  // }

  double calculatorDate(
      {required DateTime fromDate,
      required DateTime toDate,
      required String division}) {
    double countDay = 0;
    final from = DateFormat(constants.ddMMyyyySlash).format(fromDate);
    final to = DateFormat(constants.ddMMyyyySlash).format(toDate);
    if (from == to) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        var weekday = fromDate.add(Duration(days: i)).weekday;
        if (weekday == 7) {
          countDay = countDay;
        }
        countDay = 1;
      }
    } else {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        var weekday = fromDate.add(Duration(days: i)).weekday;
        if (weekday == 7) {
          countDay = countDay;
        } /* else if (weekday == 6) {
          if (division == 'DNA') {
            countDay = countDay + 1;
          } else {
            countDay = countDay + 1 /* 0.5 */;
          }
        }  */
        else {
          countDay++;
        }
      }
    }
    return countDay;
  }
}
