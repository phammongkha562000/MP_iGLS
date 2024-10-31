part of 'haulage_overview_cntr_detail_bloc.dart';

sealed class HaulageOverviewCntrDetailEvent extends Equatable {
  const HaulageOverviewCntrDetailEvent();

  @override
  List<Object> get props => [];
}

class HaulageOverviewCntrDetailViewLoaded
    extends HaulageOverviewCntrDetailEvent {
  final CustomerBloc customerBloc;
  final String woNo;
  final String woItemNo;

  const HaulageOverviewCntrDetailViewLoaded(
      {required this.customerBloc, required this.woNo, required this.woItemNo});
  @override
  List<Object> get props => [customerBloc, woNo, woItemNo];
}

class HaulageOverviewCntrDetailDeleteNotify
    extends HaulageOverviewCntrDetailEvent {
  final int itemNo;
  final String woNo;
  final CustomerBloc customerBloc;

  const HaulageOverviewCntrDetailDeleteNotify({
    required this.itemNo,
    required this.woNo,
    required this.customerBloc,
  });
  @override
  List<Object> get props => [itemNo, woNo, customerBloc];
}

class HaulageOverviewCntrDetailSaveNotify
    extends HaulageOverviewCntrDetailEvent {
  final CustomerBloc customerBloc;

  final String messageType;
  final String notes;
  final String woNo;
  final String receiver;
  final int itemNo;

  const HaulageOverviewCntrDetailSaveNotify({
    required this.customerBloc,
    required this.messageType,
    required this.notes,
    required this.woNo,
    required this.receiver,
    required this.itemNo,
  });
  @override
  List<Object> get props =>
      [messageType, notes, itemNo, receiver, woNo, customerBloc];
}
