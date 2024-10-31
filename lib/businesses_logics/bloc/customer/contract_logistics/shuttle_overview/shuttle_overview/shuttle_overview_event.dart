part of 'shuttle_overview_bloc.dart';

sealed class ShuttleOverviewEvent extends Equatable {
  const ShuttleOverviewEvent();

  @override
  List<Object> get props => [];
}

class ShuttlerOverviewViewLoaded extends ShuttleOverviewEvent {
  final String contactCode;
  final String dcCode;
  final String subsidiaryId;

  const ShuttlerOverviewViewLoaded(
      {required this.contactCode,
      required this.dcCode,
      required this.subsidiaryId});
}
