part of 'haulage_activity_bloc.dart';

abstract class HaulageActivityEvent extends Equatable {
  const HaulageActivityEvent();

  @override
  List<Object?> get props => [];
}

class HaulageActivityViewLoaded extends HaulageActivityEvent {
  final GeneralBloc generalBloc;
  const HaulageActivityViewLoaded({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

class HaulageActivityPressed extends HaulageActivityEvent {
  final int hour;
  final String contactCode;
  final GeneralBloc generalBloc;
  const HaulageActivityPressed(
      {required this.hour,
      required this.contactCode,
      required this.generalBloc});
  @override
  List<Object> get props => [hour, contactCode, generalBloc];
}
