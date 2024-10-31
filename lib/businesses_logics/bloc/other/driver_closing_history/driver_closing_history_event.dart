part of 'driver_closing_history_bloc.dart';

abstract class DriverClosingHistoryEvent extends Equatable {
  const DriverClosingHistoryEvent();

  @override
  List<Object?> get props => [];
}

class DriverClosingHistoryViewLoaded extends DriverClosingHistoryEvent {
  final DateTime date;
  final String? orderNo;
  final String? tripNo;
  // final String? pageId;
  // final String? pageName;
  final GeneralBloc generalBloc;

  const DriverClosingHistoryViewLoaded(
      {required this.date,
      this.orderNo,
      this.tripNo,
      // this.pageId,
      // this.pageName,
      required this.generalBloc});
  @override
  List<Object?> get props =>
      [date, orderNo, tripNo, /*  pageId, pageName, */ generalBloc];
}

class DriverClosingHistoryPreviousDateLoaded extends DriverClosingHistoryEvent {
  final GeneralBloc generalBloc;
  final String contactCode;
  const DriverClosingHistoryPreviousDateLoaded(
      {required this.generalBloc, required this.contactCode});
  @override
  List<Object> get props => [generalBloc, contactCode];
}

class DriverClosingHistoryNextDateLoaded extends DriverClosingHistoryEvent {
  final GeneralBloc generalBloc;
  final String contactCode;
  const DriverClosingHistoryNextDateLoaded(
      {required this.generalBloc, required this.contactCode});
  @override
  List<Object> get props => [generalBloc, contactCode];
}

class DriverClosingHistoryPickDate extends DriverClosingHistoryEvent {
  final DateTime? date;
  final String? orderNo;
  final String? tripNo;
  final ContactLocal? contact;
  final GeneralBloc generalBloc;

  const DriverClosingHistoryPickDate(
      {this.date,
      this.orderNo,
      this.tripNo,
      this.contact,
      required this.generalBloc});
  @override
  List<Object?> get props => [date, tripNo, orderNo, contact, generalBloc];
}

class DriverClosingHistoryContactLocal extends DriverClosingHistoryEvent {}
