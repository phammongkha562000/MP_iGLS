// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_widget/google_maps_widget.dart';

// part 'history_tracking_event.dart';
// part 'history_tracking_state.dart';

// class HistoryTrackingBloc
//     extends Bloc<HistoryTrackingEvent, HistoryTrackingState> {
//   HistoryTrackingBloc() : super(HistoryTrackingInitial()) {
//     on<HistoryTrackingViewLoaded>(_mapViewLoadedToState);
//   }
//   void _mapViewLoadedToState(HistoryTrackingViewLoaded event, emit) {
//     emit(HistoryTrackingLoading());
//     try {
//       List<LatLng> latLngLst = [
//         const LatLng(10.94232914572568, 107.13910104279365),
//         const LatLng(10.723691077365832, 106.60118700956924),
//         const LatLng(10.56168281935464, 106.4188601960726),
//       ];
//       emit(HistoryTrackingSuccess(latLngLst: latLngLst));
//     } catch (e) {
//       emit(HistoryTrackingFailure());
//     }
//   }
// }
