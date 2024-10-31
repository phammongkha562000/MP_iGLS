part of 'picking_bloc.dart';

sealed class PickingEvent extends Equatable {
  const PickingEvent();

  @override
  List<Object> get props => [];
}

class PickingSearch extends PickingEvent {
  final String waveNo;
  final GeneralBloc generalBloc;
  const PickingSearch({required this.waveNo, required this.generalBloc});
  @override
  List<Object> get props => [waveNo, generalBloc];
}
