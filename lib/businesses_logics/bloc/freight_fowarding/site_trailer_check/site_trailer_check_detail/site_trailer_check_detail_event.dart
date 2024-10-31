part of 'site_trailer_check_detail_bloc.dart';

abstract class SiteTrailerCheckDetailEvent extends Equatable {
  const SiteTrailerCheckDetailEvent();

  @override
  List<Object?> get props => [];
}

class SiteTrailerCheckDetailViewLoaded extends SiteTrailerCheckDetailEvent {
  final String cyName;
  final GeneralBloc generalBloc;

  const SiteTrailerCheckDetailViewLoaded({
    required this.cyName,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [cyName, generalBloc];
}

class SiteTrailerCheckDetailPickCysite extends SiteTrailerCheckDetailEvent {
  final String? cySiteCode;
  final GeneralBloc generalBloc;

  const SiteTrailerCheckDetailPickCysite({
    this.cySiteCode,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [cySiteCode, generalBloc];
}

class SiteTrailerDelete extends SiteTrailerCheckDetailEvent {
  final int tRLId;
  final String updateUser;
  final String subsidiaryId;
  const SiteTrailerDelete({
    required this.tRLId,
    required this.updateUser,
    required this.subsidiaryId,
  });
  @override
  List<Object?> get props => [tRLId, updateUser, subsidiaryId];
}
