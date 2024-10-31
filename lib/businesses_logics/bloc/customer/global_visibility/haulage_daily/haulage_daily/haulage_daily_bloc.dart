import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_res.dart';
import 'package:igls_new/data/repository/customer/global_visibility/haulage_daily/haulage_dailly_repository.dart';

import '../../../../../../data/services/services.dart';

part 'haulage_daily_event.dart';
part 'haulage_daily_state.dart';

class HaulageDailyBloc extends Bloc<HaulageDailyEvent, HaulageDailyState> {
  final _haulageDailyRepo = getIt<CustomerHaulageDailyRepository>();
  HaulageDailyBloc() : super(HaulageDailyInitial()) {
    on<HaulageDailySearch>(_mapSearchToState);
    on<HaulageDailyFilterDetail>(_mapFilterToState);
  }

  Future<void> _mapSearchToState(HaulageDailySearch event, emit) async {
    emit(HaulageDailyLoading());

    try {
      final api = await _haulageDailyRepo.getHaulageDaily(
          content: event.content, subsidiaryId: event.subsidiaryId);
      if (api.isFailure) {
        emit(HaulageDailyFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      CustomerHaulageDailyRes haulageDaily = api.data;
      emit(HaulageDailySuccess(
        details: haulageDaily.details ?? [],
        haulageDaily: haulageDaily,
      ));
    } catch (e) {
      emit(HaulageDailyFailure(message: e.toString()));
    }
  }

  void _mapFilterToState(HaulageDailyFilterDetail event, emit) {
    try {
      final currentState = state;
      if (currentState is HaulageDailySuccess) {
        List<HaulageDailyDetail> lstDetail = [];
        if (event.status == 0) {
          lstDetail = currentState.haulageDaily.details ?? [];
        }
        if (event.status == 1) {
          lstDetail = currentState.haulageDaily.details!
              .where((element) => element.actualEnd != null)
              .toList();
        } else if (event.status == 2) {
          lstDetail = currentState.haulageDaily.details!
              .where((element) =>
                  (element.actualEnd == null || element.actualEnd == ''))
              .toList();
        }
        emit(currentState.copyWith(details: lstDetail));
      }
    } catch (e) {
      emit(HaulageDailyFailure(message: e.toString()));
    }
  }
}
