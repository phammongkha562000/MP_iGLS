part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeEvent {
  final String lang;
  final GeneralBloc generalBloc;
  const HomeLoaded({required this.lang, required this.generalBloc});
  @override
  List<Object> get props => [generalBloc, lang];
}

class HomeAnnouncementLoaded extends HomeEvent {
  final GeneralBloc generalBloc;
  const HomeAnnouncementLoaded({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class LogOut extends HomeEvent {
  final GeneralBloc generalBloc;
  const LogOut({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}
