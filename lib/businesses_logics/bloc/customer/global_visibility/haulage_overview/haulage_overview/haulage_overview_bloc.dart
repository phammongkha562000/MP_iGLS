import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_res.dart';
import 'package:igls_new/data/repository/customer/global_visibility/haulage_overview/haulage_overview_repository.dart';

import '../../../../../../data/services/services.dart';

part 'haulage_overview_event.dart';
part 'haulage_overview_state.dart';

class HaulageOverviewBloc
    extends Bloc<HaulageOverviewEvent, HaulageOverviewState> {
  final _haulageOverviewRepo = getIt<CustomerHaulageOverviewRepository>();
  HaulageOverviewBloc() : super(HaulageOverviewInitial()) {
    on<HaulageOverviewSearch>(_mapSearchToState);
  }

  Future<void> _mapSearchToState(HaulageOverviewSearch event, emit) async {
    try {
      emit(HaulageOverviewLoading());
      final content = event.model;
      final api =
          await _haulageOverviewRepo.getHaulageOverview(content: content);
      if (api.isFailure) {
        emit(HaulageOverviewFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      emit(HaulageOverviewSuccess(haulageOverview: api.data));
    } catch (e) {
      emit(HaulageOverviewFailure(message: e.toString()));
    }
  }
}
