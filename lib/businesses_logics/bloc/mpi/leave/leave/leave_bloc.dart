import 'package:equatable/equatable.dart';

import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/find_date.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/models/mpi/leave/leaves/leaves.dart';
import '../../../../../data/repository/mpi/leave/leave_repository.dart';
import '../../../../../data/services/services.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final _leaveRepo = getIt<LeaveRepository>();
  UserInfo? userInfo;
  List<LeaveResult> leaveLst = [];
  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;

  LeaveBloc() : super(LeaveInitial()) {
    on<LeaveLoaded>(_mapViewToState);
    on<LeavePaging>(_mapPagingToState);
  }

  Future<void> _mapViewToState(LeaveLoaded event, emit) async {
    try {
      emit(LeaveLoading());
      pageNumber = 1;
      endPage = false;
      leaveLst.clear();
      final today = event.date;
      ApiResult apiResult = await getLeave(date: today);
      if (apiResult.isFailure) {
        emit(LeaveFailure(message: apiResult.getErrorMessage()));
        return;
      }
      MPiApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(LeaveFailure(message: apiResponse.error.errorMessage));
        return;
      }
      LeavePayload leaveRes = apiResponse.payload;
      List<LeaveResult> listLeave = leaveRes.result ?? [];
      leaveLst.addAll(listLeave);
      quantity = leaveRes.totalRecord ?? 0;
      emit(LeaveLoadSuccess(
          leavePayload: listLeave, date: today, quantity: quantity));
    } catch (e) {
      emit(LeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(LeavePaging event, emit) async {
    try {
      if (quantity == leaveLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(LeavePagingLoading());
        pageNumber++;
        final apiLeave = await getLeave(
          date: event.date,
        );
        if (apiLeave.isFailure) {
          emit(LeaveFailure(message: apiLeave.getErrorMessage()));
          return;
        }
        MPiApiResponse apiRes = apiLeave.data;
        if (apiRes.success == false) {
          emit(LeaveFailure(message: apiRes.error.errorMessage));
          return;
        }
        LeavePayload leaveRes = apiRes.payload;
        List<LeaveResult> listLeave = leaveRes.result ?? [];

        if (listLeave.isNotEmpty && listLeave != []) {
          leaveLst.addAll(listLeave);
        } else {
          endPage = true;
        }
        emit(LeaveLoadSuccess(
            leavePayload: leaveLst, date: event.date, quantity: quantity));
      }
    } catch (e) {
      emit(LeaveFailure(message: e.toString()));
    }
  }

  Future<ApiResult> getLeave({required DateTime date}) async {
    final firstDateOfMonthYyyymmdd =
        FindDate.firstDateOfMonth_yyyyMMdd(today: date);
    final lastDateOfMonthYyyymmdd =
        FindDate.lastDateOfMonth_yyyyMMdd(today: date);
    final sharedPref = await SharedPreferencesService.instance;

    final content = LeaveRequest(
        status: "",
        leaveType: "",
        submitDateF: firstDateOfMonthYyyymmdd,
        submitDateT: lastDateOfMonthYyyymmdd,
        employeeCode: userInfo?.empCode,
        pageNumber: pageNumber,
        rowNumber: constants.sizePaging);
    return await _leaveRepo.getLeave(
        content: content,
        mpiUrl: sharedPref.serverMPi ?? '',
        baseUrl: sharedPref.serverAddress ?? '');
  }
}
