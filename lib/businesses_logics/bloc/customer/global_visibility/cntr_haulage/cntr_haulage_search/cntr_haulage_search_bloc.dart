import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import '../../../../../../data/repository/repository.dart';
import '../../../../../../data/services/injection/injection_igls.dart';
import '../../../../../../presentations/screen/customer/global_visibility/cntr_haulage/cntr_haulage_search_view.dart';

part 'cntr_haulage_search_event.dart';
part 'cntr_haulage_search_state.dart';

class CNTRHaulageSearchBloc
    extends Bloc<CNTRHaulageSearchEvent, CNTRHaulageSearchState> {
  final _trackTraceRepo = getIt<TrackAndTraceRepository>();
  CNTRHaulageSearchBloc() : super(CNTRHaulageSearchInitial()) {
    on<CNTRHaulageSearchViewLoaded>(_mapSearchToState);
    on<GetUnlocPodEvent>(_getUnlocPodEvent);
    on<GetUnlocPolEvent>(_getUnlocPolEvent);
  }

  void _mapSearchToState(CNTRHaulageSearchViewLoaded event, emit) {
    try {
      List<TradeType> lstTradeType = [
        TradeType(typeName: "", typeCode: ""),
        TradeType(typeName: "Import", typeCode: "I"),
        TradeType(typeName: "Export", typeCode: "E")
      ];
      List<Status> lstStatus = [
        Status(statusName: "", statusCode: ""),
        Status(statusName: "New", statusCode: "NEW"),
        Status(statusName: "Process", statusCode: "PROCESS"),
        Status(statusName: "Completed", statusCode: "COMPLETED"),
      ];
      List<DayType> lstDayType = [
        DayType(dateTypeName: "ETD/ETA", dateTypeCode: "ETDETA"),
        DayType(dateTypeName: "Service Date", dateTypeCode: "SVDATE"),
        DayType(dateTypeName: "Pickup Date", dateTypeCode: "PICDATE"),
        DayType(dateTypeName: "Delivery Date", dateTypeCode: "DELDATE"),
      ];
      emit(CNTRHaulageSearchSuccess(
          lstTradeType: lstTradeType,
          lstStatus: lstStatus,
          lstDayType: lstDayType));
    } catch (e) {
      emit(CNTRHaulageSearchFailure(message: e.toString()));
    }
  }

  Future<void> _getUnlocPodEvent(GetUnlocPodEvent event, emit) async {
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

  Future<void> _getUnlocPolEvent(GetUnlocPolEvent event, emit) async {
    try {
      var result = await _trackTraceRepo.getUnloc(unLocCode: event.unlocCode);

      if (result.isFailure) {
        emit(GetUnlocFail(message: result.getErrorMessage()));
        return;
      }
      emit(GetUnlocPolSuccess(lstUnloc: [
        GetUnlocResult(placeName: "", unlocCode: ""),
        ...result.data?.lstUnlocResult ?? []
      ]));
    } catch (e) {
      emit(GetUnlocFail(message: e.toString()));
    }
  }
}
