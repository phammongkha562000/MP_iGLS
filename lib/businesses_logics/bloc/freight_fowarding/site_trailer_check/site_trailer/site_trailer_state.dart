part of 'site_trailer_bloc.dart';

abstract class SiteTrailerState extends Equatable {
  const SiteTrailerState();

  @override
  List<Object?> get props => [];
}

class SiteTrailerInitial extends SiteTrailerState {}

class SiteTrailerLoading extends SiteTrailerState {}

class SiteTrailerSuccess extends SiteTrailerState {
  final CySiteResponse? cySite;
  final List<CySiteResponse> cySiteList;
  final List<EquipmentResponse> equipmentList;
  const SiteTrailerSuccess({
    this.cySite,
    required this.cySiteList,
    required this.equipmentList,
  });
  @override
  List<Object?> get props => [
        cySite,
        cySiteList,
        equipmentList,
      ];

  SiteTrailerSuccess copyWith({
    CySiteResponse? cySite,
    List<SiteTrailerResponse>? siteTrailerList,
    List<EquipmentResponse>? equipmentList,
    List<CySiteResponse>? cySiteList,
  }) {
    return SiteTrailerSuccess(
      cySite: cySite ?? this.cySite,
      equipmentList: equipmentList ?? this.equipmentList,
      cySiteList: cySiteList ?? this.cySiteList,
    );
  }
}

class SiteTrailerFailure extends SiteTrailerState {
  final String message;
  final int? errorCode;
  const SiteTrailerFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class SiteTrailerSaveSuccess extends SiteTrailerState {}
