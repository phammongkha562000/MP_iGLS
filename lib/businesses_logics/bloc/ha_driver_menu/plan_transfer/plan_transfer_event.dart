part of 'plan_transfer_bloc.dart';

abstract class PlanTransferEvent extends Equatable {
  const PlanTransferEvent();

  @override
  List<Object> get props => [];
}

class PlanTransferLoaded extends PlanTransferEvent {
  final HaulageToDoDetail task;
  final GeneralBloc generalBloc;
  const PlanTransferLoaded({
    required this.task,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [task, generalBloc];
}

class PlanTransferSearch extends PlanTransferEvent {
  final String tractorNo;
  final GeneralBloc generalBloc;
  const PlanTransferSearch(
      {required this.tractorNo, required this.generalBloc});
  @override
  List<Object> get props => [tractorNo, generalBloc];
}

class PlanTransferUpdate extends PlanTransferEvent {
  final String priEquipment;
  final GeneralBloc generalBloc;
  const PlanTransferUpdate(
      {required this.priEquipment, required this.generalBloc});
  @override
  List<Object> get props => [priEquipment, generalBloc];
}
