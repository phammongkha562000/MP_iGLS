part of 'picking_detail_bloc.dart';

sealed class PickingDetailEvent extends Equatable {
  const PickingDetailEvent();

  @override
  List<Object> get props => [];
}

class PickingDetailCheckGrNo extends PickingDetailEvent {
  final String grNo;
  final String subsidiaryId;
  const PickingDetailCheckGrNo(
      {required this.grNo, required this.subsidiaryId});
  @override
  List<Object> get props => [grNo, subsidiaryId];
}

class PickingDetailSave extends PickingDetailEvent {
  final GeneralBloc generalBloc;
  final String waveNo;
  final int oOrderNo;
  final int waveItemNo;
  final int srItemNo;
  final int sbNo;
  final double qty;

  const PickingDetailSave(
      {required this.waveNo,
      required this.oOrderNo,
      required this.waveItemNo,
      required this.srItemNo,
      required this.sbNo,
      required this.generalBloc,
      required this.qty});
  @override
  List<Object> get props =>
      [waveNo, oOrderNo, waveItemNo, srItemNo, sbNo, qty, generalBloc];
}

class PickingSearch extends PickingDetailEvent {
  final String waveNo;
  final int waveItemNo;
  final GeneralBloc generalBloc;

  const PickingSearch({
    required this.waveNo,
    required this.waveItemNo,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [waveNo, waveItemNo, generalBloc];
}
