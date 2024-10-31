import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/customer/contract_logistics/shuttle_overview/shuttle_overview_response.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/shuttle_overview/shuttle_overview_repository.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../../data/services/services.dart';

part 'shuttle_overview_event.dart';
part 'shuttle_overview_state.dart';

class ShuttleOverviewBloc
    extends Bloc<ShuttleOverviewEvent, ShuttleOverviewState> {
  final _shuttleOverviewRepo = getIt<ShuttleOverviewRepository>();
  ShuttleOverviewBloc() : super(ShuttleOverviewInitial()) {
    on<ShuttlerOverviewViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      ShuttlerOverviewViewLoaded event, emit) async {
    emit(ShuttleOverviewLoading());
    try {
      final api = await _shuttleOverviewRepo.getShuttleOverview(
          date: DateFormat(constants.formatyyyyMMdd).format(DateTime.now()),
          contactCode: event.contactCode,
          dcCode: event.dcCode,
          subsidiaryId: event.subsidiaryId);
      if (api.isFailure) {
        emit(ShuttleOverviewFailure(message: api.getErrorMessage()));
        return;
      }
      emit(ShuttleOverviewSuccess(shuttleOverview: api.data));
    } catch (e) {
      emit(ShuttleOverviewFailure(message: e.toString()));
    }
  }
}