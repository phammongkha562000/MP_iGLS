import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/to_do_trip_detail_response.dart';
import 'package:igls_new/data/repository/local_distribution/to_do_local_distribution/to_do_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'transport_overview_detail_trip_event.dart';
part 'transport_overview_detail_trip_state.dart';

class TransportOverviewDetailTripBloc extends Bloc<
    TransportOverviewDetailTripEvent, TransportOverviewDetailTripState> {
  final _todoTripRepo = getIt<ToDoTripRepository>();

  TransportOverviewDetailTripBloc()
      : super(TransportOverviewDetailTripInitial()) {
    on<TransportOverviewDetailTripViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      TransportOverviewDetailTripViewLoaded event, emit) async {
    emit(TransportOverviewDetailTripLoading());
    try {
      final api = await _todoTripRepo.getToDoTripDetail(
          subsidiaryId: event.subsidiaryId, tripNo: event.tripNo);
      if (api.isFailure) {
        emit(
            TransportOverviewDetailTripFailure(message: api.getErrorMessage()));
        return;
      }
      emit(TransportOverviewDetailTripSuccess(detail: api.data));
    } catch (e) {
      emit(TransportOverviewDetailTripFailure(message: e.toString()));
    }
  }
}
