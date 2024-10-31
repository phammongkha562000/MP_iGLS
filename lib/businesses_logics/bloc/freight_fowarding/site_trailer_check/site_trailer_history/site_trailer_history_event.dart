part of 'site_trailer_history_bloc.dart';

sealed class SiteTrailerHistoryEvent extends Equatable {
  const SiteTrailerHistoryEvent();

  @override
  List<Object> get props => [];
}

class SiteTrailerHistoryViewLoaded extends SiteTrailerHistoryEvent {
  final String trailer;
  final GeneralBloc generalBloc;

  const SiteTrailerHistoryViewLoaded(
      {required this.trailer, required this.generalBloc});
  @override
  List<Object> get props => [trailer, generalBloc];
}

class SiteTrailerHistorySearch extends SiteTrailerHistoryEvent {
  final String cySite;

  const SiteTrailerHistorySearch({required this.cySite});
  @override
  List<Object> get props => [cySite];
}
