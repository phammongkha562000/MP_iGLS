import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';

import '../../../../../../data/repository/repository.dart';
import '../../../../../../data/services/services.dart';

part 'booking_search_event.dart';
part 'booking_search_state.dart';

class BookingSearchBloc extends Bloc<BookingSearchEvent, BookingSearchState> {
  final _trackTraceRepo = getIt<TrackAndTraceRepository>();

  BookingSearchBloc() : super(BookingSearchInitial()) {
    on<BookingSearchViewLoaded>(_mapViewLoadedToState);
    on<GetUnlocPodEvent>(_mapUnlocPodEvent);
  }
  void _mapViewLoadedToState(BookingSearchViewLoaded event, emit) {
    emit(BookingSearchLoading());
    try {
      emit(BookingSearchSuccess());
    } catch (e) {
      emit(BookingSearchFailure(message: e.toString()));
    }
  }

  Future<void> _mapUnlocPodEvent(GetUnlocPodEvent event, emit) async {
    try {
      var result = await _trackTraceRepo.getUnloc(unLocCode: event.unlocCode);

      if (result.isFailure) {
        emit(GetUnlocFail(message: result.getErrorMessage()));
        return;
      }
      emit(GetUnlocPodSuccess(lstUnloc: [
        GetUnlocResult(placeName: "", unlocCode: ""),
        ...result.data?.lstUnlocResult ?? []
      ]));
    } catch (e) {
      emit(GetUnlocFail(message: e.toString()));
    }
  }
}
