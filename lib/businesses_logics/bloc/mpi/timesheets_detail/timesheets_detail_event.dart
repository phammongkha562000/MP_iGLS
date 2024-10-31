part of 'timesheets_detail_bloc.dart';

abstract class TimesheetsDetailEvent extends Equatable {
  const TimesheetsDetailEvent();

  @override
  List<Object> get props => [];
}

class TimesheetsDetailViewLoaded extends TimesheetsDetailEvent {
  final TimesheetResult timesheetsItem;
  final GeneralBloc generalBloc;
  const TimesheetsDetailViewLoaded(
      {required this.timesheetsItem, required this.generalBloc});
  @override
  List<Object> get props => [timesheetsItem, generalBloc];
}

class TimesheetsDetailUpdate extends TimesheetsDetailEvent {
  final TimesheetsUpdateRequest timesheets;
  final GeneralBloc generalBloc;

  const TimesheetsDetailUpdate(
      {required this.timesheets, required this.generalBloc});
  @override
  List<Object> get props => [timesheets, generalBloc];
}
