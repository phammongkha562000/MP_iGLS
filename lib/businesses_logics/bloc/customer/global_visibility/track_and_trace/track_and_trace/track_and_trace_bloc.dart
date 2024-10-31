import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';

import '../../../../../../data/models/customer/global_visibility/track_and_trace/get_track_and_trace_req.dart';
import '../../../../../../data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import '../../../../../../data/models/customer/global_visibility/track_and_trace/track_and_trace_status_res.dart';
import '../../../../../../data/repository/customer/global_visibility/track_and_trace/track_and_trace_repository.dart';
import '../../../../../../data/services/injection/injection_igls.dart';
import '../../../customer_bloc/customer_bloc.dart';

part 'track_and_trace_event.dart';
part 'track_and_trace_state.dart';

class TrackAndTraceBloc extends Bloc<TrackAndTraceEvent, TrackAndTraceState> {
  TrackAndTraceBloc() : super(TrackAndTraceInitial()) {
    on<TrackAndTraceLoaded>(_trackAndTraceLoaded);
    on<GetUnlocPodEvent>(_getUnlocPodEvent);
    on<GetUnlocPolEvent>(_getUnlocPolEvent);
    on<GetTrackAndTraceEvent>(_getTrackAndTrace);
  }
  final _trackTraceRepo = getIt<TrackAndTraceRepository>();

  Future<void> _trackAndTraceLoaded(TrackAndTraceLoaded event, emit) async {
    try {
      var result = await _trackTraceRepo.getTrackAndTraceStatus(
          updateBased: "",
          strCompany:
              event.customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '');
      if (result.isFailure) {
        emit(TrackAndTraceLoadedFail(message: result.getErrorMessage()));
        return;
      }
      emit(TrackAndTraceLoadedSuccess(lstStatus: [
        TrackAndTraceStatusRes(statusDesc: "", statusCode: ""),
        ...result.data
      ]));
    } catch (e) {
      emit(TrackAndTraceLoadedFail(message: e.toString()));
    }
  }

  Future<void> _getUnlocPodEvent(GetUnlocPodEvent event, emit) async {
    try {
      emit(ShowLoadingState());
      var result = await _trackTraceRepo.getUnloc(unLocCode: event.unlocCode);
      emit(HideLoadingState());

      if (result.isFailure) {
        emit(GetUnlocFailState(message: result.getErrorMessage()));
        return;
      }
      emit(GetUnlocPodSuccessState(lstUnloc: [
        GetUnlocResult(placeName: "", unlocCode: ""),
        ...result.data?.lstUnlocResult ?? []
      ]));
    } catch (e) {
      emit(GetUnlocFailState(message: e.toString()));
    }
  }

  Future<void> _getUnlocPolEvent(GetUnlocPolEvent event, emit) async {
    try {
      emit(ShowLoadingState());
      var result = await _trackTraceRepo.getUnloc(unLocCode: event.unlocCode);
      emit(HideLoadingState());

      if (result.isFailure) {
        emit(GetUnlocFailState(message: result.getErrorMessage()));
        return;
      }
      emit(GetUnlocPolSuccessState(lstUnloc: [
        GetUnlocResult(placeName: "", unlocCode: ""),
        ...result.data?.lstUnlocResult ?? []
      ]));
    } catch (e) {
      emit(GetUnlocFailState(message: e.toString()));
    }
  }

  Future<void> _getTrackAndTrace(GetTrackAndTraceEvent event, emit) async {
    try {
      emit(ShowLoadingState());
      var result = await _trackTraceRepo.getTrackAndTrace(
          model: event.model, strCompany: event.strCompany);
      emit(HideLoadingState());
      if (result.isFailure) {
        emit(GetTrackAndTraceFailState(message: result.getErrorMessage()));
        return;
      }
      emit(GetTrackAndTraceSuccessState(lstTrackTrace: result.data));
    } catch (e) {
      emit(GetTrackAndTraceFailState(message: e.toString()));
    }
  }
}
