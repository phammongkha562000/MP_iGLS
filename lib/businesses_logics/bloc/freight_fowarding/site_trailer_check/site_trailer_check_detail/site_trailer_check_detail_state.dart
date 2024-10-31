part of 'site_trailer_check_detail_bloc.dart';

abstract class SiteTrailerCheckDetailState extends Equatable {
  const SiteTrailerCheckDetailState();

  @override
  List<Object?> get props => [];
}

class SiteTrailerCheckDetailInitial extends SiteTrailerCheckDetailState {}

class SiteTrailerCheckDetailLoading extends SiteTrailerCheckDetailState {}

class SiteTrailerCheckDetailSuccess extends SiteTrailerCheckDetailState {
  final List<CySiteResponse> cySiteList;
  final List<SiteTrailerResponse> siteTrailerList;
  final CySiteResponse? cySite;
  final List<SiteTrailerSumaryRes> lstTrailerSumary;
  const SiteTrailerCheckDetailSuccess(
      {required this.cySiteList,
      required this.siteTrailerList,
      this.cySite,
      required this.lstTrailerSumary});
  @override
  List<Object?> get props =>
      [cySiteList, siteTrailerList, cySite, lstTrailerSumary];

  SiteTrailerCheckDetailSuccess copyWith({
    List<CySiteResponse>? cySiteList,
    List<SiteTrailerResponse>? siteTrailerList,
    CySiteResponse? cySite,
    List<SiteTrailerSumaryRes>? lstTrailerSumary,
  }) {
    return SiteTrailerCheckDetailSuccess(
        cySiteList: cySiteList ?? this.cySiteList,
        cySite: cySite,
        siteTrailerList: siteTrailerList ?? this.siteTrailerList,
        lstTrailerSumary: lstTrailerSumary ?? this.lstTrailerSumary);
  }
}

class SiteTrailerCheckDetailFailure extends SiteTrailerCheckDetailState {
  final String message;
  final int? errorCode;
  const SiteTrailerCheckDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class SiteTrailerCheckDeleteSuccess extends SiteTrailerCheckDetailState {}
