part of 'haulage_daily_cntr_detail_bloc.dart';

sealed class HaulageDailyCntrDetailEvent extends Equatable {
  const HaulageDailyCntrDetailEvent();

  @override
  List<Object> get props => [];
}

class HaulageDailyCntrDetailViewLoaded extends HaulageDailyCntrDetailEvent {
  final CustomerBloc customerBloc;
  final String woNo;
  final String woItemNo;

  const HaulageDailyCntrDetailViewLoaded(
      {required this.customerBloc, required this.woNo, required this.woItemNo});
  @override
  List<Object> get props => [customerBloc, woNo, woItemNo];
}

class HaulageDailyCntrDetailDeleteNotify extends HaulageDailyCntrDetailEvent {
  final int itemNo;
  final String woNo;
  final CustomerBloc customerBloc;

  const HaulageDailyCntrDetailDeleteNotify({
    required this.itemNo,
    required this.woNo,
    required this.customerBloc,
  });
  @override
  List<Object> get props => [itemNo, woNo, customerBloc];
}

class HaulageDailyCntrDetailSaveNotify extends HaulageDailyCntrDetailEvent {
  final CustomerBloc customerBloc;

  final String messageType;
  final String notes;
  final String woNo;
  final String receiver;
  final int itemNo;

  const HaulageDailyCntrDetailSaveNotify({
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
