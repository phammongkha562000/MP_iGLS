import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/leave_detail_response.dart';
import 'package:igls_new/data/repository/mpi/leave/leave_repository.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../../data/services/services.dart';

part 'leave_detail_event.dart';
part 'leave_detail_state.dart';

class LeaveDetailBloc extends Bloc<LeaveDetailEvent, LeaveDetailState> {
  final _leaveRepo = getIt<LeaveRepository>();

  LeaveDetailBloc() : super(LeaveDetailInitial()) {
    on<LeaveDetailLoaded>(_mapViewToState);
  }
  Future<void> _mapViewToState(LeaveDetailLoaded event, emit) async {
    try {
      emit(LeaveDetailLoading());
      final sharedPref = await SharedPreferencesService.instance;

      ApiResult apiResult = await _leaveRepo.getLeaveDetail(
          lvNo: event.lvNo,
          empCode: event.empCode,
          mpiUrl: sharedPref.serverMPi ?? '',
          baseUrl: sharedPref.serverAddress ?? '');
      if (apiResult.isFailure) {
        emit(LeaveDetailFailure(message: apiResult.getErrorMessage()));
        return;
      }
      MPiApiResponse getLeaveDetail = apiResult.data;
      if (getLeaveDetail.success == false) {
        emit(LeaveDetailFailure(message: getLeaveDetail.error.errorMessage));
        return;
      }
      if (getLeaveDetail.success == true) {
        emit(LeaveDetailLoadSuccess(leaveDetail: getLeaveDetail.payload));
      } else {
        emit(LeaveDetailFailure(message: "no_data".tr()));
      }
    } catch (e) {
      emit(LeaveDetailFailure(message: e.toString()));
    }
  }
}
