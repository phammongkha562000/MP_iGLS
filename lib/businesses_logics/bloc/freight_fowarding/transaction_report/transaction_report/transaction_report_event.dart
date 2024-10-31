part of 'transaction_report_bloc.dart';

sealed class TransactionReportEvent extends Equatable {
  const TransactionReportEvent();

  @override
  List<Object?> get props => [];
}

class TransactionReportViewLoaded extends TransactionReportEvent {
  final GeneralBloc generalBloc;
  final DateTime? dateTime;
  const TransactionReportViewLoaded({required this.generalBloc, this.dateTime});
  @override
  List<Object?> get props => [generalBloc, dateTime];
}
