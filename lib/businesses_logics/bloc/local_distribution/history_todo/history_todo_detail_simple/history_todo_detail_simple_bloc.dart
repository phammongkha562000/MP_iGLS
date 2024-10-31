import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/local_distribution/to_do_local_distribution/to_do_repository.dart';
import '../../../../../data/services/injection/injection_igls.dart';

import '../../../general/general_bloc.dart';

part 'history_todo_detail_simple_event.dart';
part 'history_todo_detail_simple_state.dart';

class HistoryTodoDetailSimpleBloc
    extends Bloc<HistoryTodoDetailSimpleEvent, HistoryTodoDetailSimpleState> {
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  HistoryTodoDetailSimpleBloc() : super(HistoryTodoDetailSimpleInitial()) {
    on<HistoryTodoDetailSimpleLoaded>(_mapViewToState);
  }

  void _mapViewToState(HistoryTodoDetailSimpleLoaded event, emit) async {
    try {
      emit(HistoryTodoDetailSimpleLoading());

    UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult = await _toDoTripRepo.getToDoTripDetail(
        tripNo: event.tripNo,
        subsidiaryId:  userInfo.subsidiaryId?? ''
      );
      if (apiResult.isFailure) {
        emit(HistoryTodoDetailSimpleFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      ToDoTripDetailResponse getDetailSimple = apiResult.data;
      final List<SimpleOrderDetail> listSimpleOrther =
          getDetailSimple.simpleOrderDetails!;

      emit(HistoryTodoDetailSimpleSuccess(
        simpleTodoDetal: getDetailSimple,
        listSimpleOrderDetail: listSimpleOrther,
        tripClass: event.tripClass,
      ));
    } catch (e) {
      emit(HistoryTodoDetailSimpleFailure(message: e.toString()));
    }
  }
}
