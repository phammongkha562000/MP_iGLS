import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:collection/collection.dart';

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import '../../../general/general_bloc.dart';

part 'history_todo_detail_normal_event.dart';
part 'history_todo_detail_normal_state.dart';

class HistoryTodoDetailNormalBloc
    extends Bloc<HistoryTodoDetailNormalEvent, HistoryTodoDetailNormalState> {
  final _historyTodoRepository = getIt<HistoryTodoRepository>();
  static final _userProfileRepo = getIt<UserProfileRepository>();

  HistoryTodoDetailNormalBloc() : super(HistoryTodoDetailNormalInitial()) {
    on<HistoryTodoDetailNormalLoaded>(_mapViewToState);
  }

  void _mapViewToState(HistoryTodoDetailNormalLoaded event, emit) async {
    try {
      emit(HistoryTodoDetailNormalLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final subsidiaryId = userInfo.subsidiaryId ?? '';
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;

      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userProfileRepo.getLocal(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId!);
        if (apiResult.isFailure) {
          emit(HistoryTodoDetailNormalFailure(
              message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }

      final dcCode = dcLocalList.map((e) => e.dcCode).join(",");
      final apiResult = await _historyTodoRepository.getNormaHistoryDetail(
        tripNoNormal: event.tripNoNormal,
        dcCode: dcCode,
        subsidiaryId: subsidiaryId,
      );
      if (apiResult.isFailure) {
        emit(HistoryTodoDetailNormalFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      NormalTripDetailResponse normalDetail = apiResult.data;

      List<List<TripPlanOrder>> orderGroupByList = [];
      final List<TripPlanOrder>? listTripPlanOrder =
          normalDetail.tripPlanOrders;
      if (listTripPlanOrder != null && listTripPlanOrder != []) {
        final tripGroupBy = groupBy(
          listTripPlanOrder,
          (TripPlanOrder elm) => elm.clientRefNo,
        );

        orderGroupByList =
            tripGroupBy.entries.map((entry) => entry.value).toList();
      }

      emit(HistoryTodoDetailNormalSuccess(
          tripNormal: normalDetail,
          listTripPlanOrder: listTripPlanOrder,
          listGroupByOrder: orderGroupByList));
    } catch (e) {
      emit(HistoryTodoDetailNormalFailure(message: e.toString()));
    }
  }
}
