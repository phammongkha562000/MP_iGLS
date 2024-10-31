import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/local_distribution/history_todo/history_todo_repository.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../data/models/models.dart';
import '../../../../data/services/injection/injection_igls.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/services/result/result.dart';
import '../../general/general_bloc.dart';

part 'history_todo_event.dart';
part 'history_todo_state.dart';

class HistoryTodoBloc extends Bloc<HistoryTodoEvent, HistoryTodoState> {
  final _historyTodoRepository = getIt<HistoryTodoRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<HistoryTrip> historyLst = [];
  HistoryTodoBloc() : super(HistoryTodoInitial()) {
    on<HistoryTodoLoaded>(_mapViewToState);
    on<HistoryTodoPaging>(_mapPagingToState);
  }

  Future<ApiResult> _getHistoryTodo(
      {required DateTime eventDate,
      required String empCode,
      required String subsidiaryId,
      required int pageNumber}) async {
    final date = DateFormat(constants.formatyyyyMMdd).format(eventDate);
    return await _historyTodoRepository.getListHistoryTodo(
      content: HistoryTodoRequest(
          equipmentCode: "",
          etp: date,
          driverId: empCode,
          pageNumber: pageNumber,
          pageSize: constants.sizePaging),
      subsidiaryId: subsidiaryId,
    );
  }

  void _mapViewToState(HistoryTodoLoaded event, emit) async {
    try {
      emit(HistoryTodoLoading());
      endPage = false;
      pageNumber = 1;
      historyLst.clear();

      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final equipmentCode = sharedPref.equipmentNo;
      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      if (equipmentCode == null || equipmentCode == "" || driverId == "") {
        emit(const HistoryTodoFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        emit(const HistoryTodoSuccess(historyList: [], quantity: 0));
        return;
      }
      final apiResultHistory = await _getHistoryTodo(
          subsidiaryId: userInfo.subsidiaryId ?? "",
          pageNumber: 1,
          empCode: event.generalBloc.generalUserInfo?.empCode ?? '',
          eventDate: DateTime(event.date.year, event.date.month, 15));
      if (apiResultHistory.isFailure) {
        emit(HistoryTodoFailure(
            message: apiResultHistory.getErrorMessage(),
            errorCode: apiResultHistory.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResultHistory.data;
      if (apiResponse.success != true) {
        emit(HistoryTodoFailure(
            message: apiResponse.error?.message,
            errorCode: apiResponse.error?.errorCode));
        return;
      }
      HistoryTodoResponse todoHaulageRes = apiResponse.payload;
      List<HistoryTrip> listHistory = todoHaulageRes.results ?? [];
      historyLst.addAll(listHistory);
      quantity = todoHaulageRes.totalCount ?? 0;
      emit(HistoryTodoSuccess(historyList: historyLst, quantity: quantity));
    } catch (e) {
      emit(HistoryTodoFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(HistoryTodoPaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is HistoryTodoSuccess) {
        if (historyLst.length == quantity) {
          endPage = true;
          emit(currentState);
          return;
        }
        if (endPage == false) {
          emit(HistoryTodoPagingLoading());
          pageNumber++;
          UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

          final apiResultHistory = await _getHistoryTodo(
              subsidiaryId: userInfo.subsidiaryId ?? "",
              pageNumber: pageNumber,
              empCode: event.generalBloc.generalUserInfo?.empCode ?? '',
              eventDate: DateTime(event.date.year, event.date.month, 15));
          if (apiResultHistory.isFailure) {
            emit(HistoryTodoFailure(
                message: apiResultHistory.getErrorMessage(),
                errorCode: apiResultHistory.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResultHistory.data;
          if (apiResponse.success != true) {
            emit(HistoryTodoFailure(
                message: apiResponse.error?.message,
                errorCode: apiResponse.error?.errorCode));
            return;
          }
          HistoryTodoResponse todoHaulageRes = apiResponse.payload;
          List<HistoryTrip> listHistory = todoHaulageRes.results ?? [];
          if (listHistory != [] && listHistory.isNotEmpty) {
            historyLst.addAll(listHistory);
            emit(HistoryTodoSuccess(
                historyList: historyLst, quantity: quantity));
          } else {
            endPage = true;
            emit(currentState);
          }
        }
      }
    } catch (e) {
      emit(HistoryTodoFailure(message: e.toString()));
    }
  }
}
