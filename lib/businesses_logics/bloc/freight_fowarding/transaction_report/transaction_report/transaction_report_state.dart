part of 'transaction_report_bloc.dart';

sealed class TransactionReportState extends Equatable {
  const TransactionReportState();

  @override
  List<Object?> get props => [];
}

final class TransactionReportInitial extends TransactionReportState {}

final class TransactionReportLoading extends TransactionReportState {}

final class TransactionReportSuccess extends TransactionReportState {
  final DateTime dateTime;

  final TransactionReportResponse report;

  const TransactionReportSuccess(
      {required this.report, required this.dateTime});
  @override
  List<Object?> get props => [report, dateTime];
}

final class TransactionReportFailure extends TransactionReportState {
  final int? errorCode;
  final String message;

  const TransactionReportFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
