part of 'driver_closing_history_bloc.dart';

abstract class DriverClosingHistoryState extends Equatable {
  const DriverClosingHistoryState();

  @override
  List<Object?> get props => [];
}

class DriverClosingHistoryInitial extends DriverClosingHistoryState {}

class DriverClosingHistoryLoading extends DriverClosingHistoryState {}

class DriverClosingHistorySuccess extends DriverClosingHistoryState {
  final DateTime date;
  final bool? isSuccess;
  final List<DriverClosingHistoryResponse> historyList;
  final List<ContactLocal>? localList;
  const DriverClosingHistorySuccess(
      {required this.date,
      required this.historyList,
      this.isSuccess,
      this.localList});
  @override
  List<Object?> get props => [date, historyList, isSuccess, localList];

  DriverClosingHistorySuccess copyWith({
    DateTime? date,
    List<DriverClosingHistoryResponse>? historyList,
    bool? isSuccess,
    List<ContactLocal>? localList,
  }) {
    return DriverClosingHistorySuccess(
      date: date ?? this.date,
      historyList: historyList ?? this.historyList,
      isSuccess: isSuccess ?? this.isSuccess,
      localList: localList ?? this.localList,
    );
  }
}

class DriverClosingHistoryFailure extends DriverClosingHistoryState {
  final String message;
  final int? errorCode;
  final List<ContactLocal>? contactList;
  const DriverClosingHistoryFailure(
      {required this.message, this.errorCode, this.contactList});
  @override
  List<Object?> get props => [message, errorCode, contactList];
}
