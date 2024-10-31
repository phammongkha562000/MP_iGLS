import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/ha_driver_menu/task_history/task_history_repo.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'task_history_detail_event.dart';
part 'task_history_detail_state.dart';

class TaskHistoryDetailBloc
    extends Bloc<TaskHistoryDetailEvent, TaskHistoryDetailState> {
  final _taskHistoryRepo = getIt<TaskHistoryRepository>();
  TaskHistoryDetailBloc() : super(TaskHistoryDetailInitial()) {
    on<TaskHistoryDetailLoaded>(_mapTaskHistoryDetailToState);
  }
  Future<void> _mapTaskHistoryDetailToState(
      TaskHistoryDetailLoaded event, emit) async {
    emit(TaskHistoryDetailLoading());
    try {    UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();


      final apiResult = await _taskHistoryRepo.getHistoryDetail(
          id: event.id, subsidiaryId:  userInfo.subsidiaryId?? '');
      if (apiResult.isFailure) {
        emit(TaskHistoryDetailFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      HistoryDetail apiResponse = apiResult.data;
      final listDetail = apiResponse.listDetail;
      final task = apiResponse.dailyTask;
      emit(TaskHistoryDetailSuccess(listDetail: listDetail, dailyTask: task));
    } catch (e) {
      emit(TaskHistoryDetailFailure(message: strings.messError.tr()));
    }
  }
}
