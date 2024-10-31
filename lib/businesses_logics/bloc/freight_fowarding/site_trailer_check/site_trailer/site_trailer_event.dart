part of 'site_trailer_bloc.dart';

abstract class SiteTrailerEvent extends Equatable {
  const SiteTrailerEvent();

  @override
  List<Object?> get props => [];
}

class SiteTrailerViewLoaded extends SiteTrailerEvent {
  final String? trailerNo;
  final String? cntrNo;

  final GeneralBloc generalBloc;
  const SiteTrailerViewLoaded(
      {this.trailerNo, this.cntrNo, required this.generalBloc});
  @override
  List<Object?> get props => [trailerNo, cntrNo, generalBloc];
}

class SiteTrailerPickCysite extends SiteTrailerEvent {
  final String? cySiteCode;
  final GeneralBloc generalBloc;

  const SiteTrailerPickCysite({
    this.cySiteCode,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [cySiteCode, generalBloc];
}

class SiteTrailerSave extends SiteTrailerEvent {
  final GeneralBloc generalBloc;
  final String trailerNo;
  final String cntrNo;
  final String remark;
  final String cntrStatus;
  final String containerLocker;
  final String barriers;
  final String landingGear;
  final String tireStatus;
  final String ledStatus;
  final String? cySiteName;
  final String? workingStatus;
  const SiteTrailerSave(
      {required this.trailerNo,
      required this.cntrNo,
      required this.remark,
      required this.cntrStatus,
      required this.containerLocker,
      required this.barriers,
      required this.landingGear,
      required this.tireStatus,
      required this.ledStatus,
      required this.generalBloc,
      this.cySiteName,
      required this.workingStatus});

  @override
  List<Object?> get props => [
        trailerNo,
        cntrNo,
        remark,
        cntrStatus,
        containerLocker,
        barriers,
        landingGear,
        tireStatus,
        ledStatus,
        cySiteName,
        generalBloc,
        workingStatus
      ];
}
