import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_request.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_response.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/transport_overview/transport_overview_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'transport_overview_event.dart';
part 'transport_overview_state.dart';

class TransportOverviewBloc
    extends Bloc<TransportOverviewEvent, TransportOverviewState> {
  final _transportOverviewRepo = getIt<TransportOverviewRepository>();
  TransportOverviewBloc() : super(TransportOverviewInitial()) {
    on<TransportOverviewViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      TransportOverviewViewLoaded event, emit) async {
    emit(TransportOverviewLoading());
    try {
      final api = await _transportOverviewRepo.getTransportOverview(
          content: event.content);
      if (api.isFailure) {
        emit(TransportOverviewFailure(message: api.getErrorMessage()));
        return;
      }
      emit(TransportOverviewSuccess(transportOverview: api.data));
    } catch (e) {
      emit(TransportOverviewFailure(message: e.toString()));
    }
  }
}
