part of 'site_stock_check_bloc.dart';

abstract class SiteStockCheckEvent extends Equatable {
  const SiteStockCheckEvent();

  @override
  List<Object?> get props => [];
}

class SiteStockCheckViewLoaded extends SiteStockCheckEvent {
  final String? trailerNo;
  final String? cntrNo;
  final GeneralBloc generalBloc;
  const SiteStockCheckViewLoaded(
      {this.trailerNo, this.cntrNo, required this.generalBloc});
  @override
  List<Object?> get props => [trailerNo, cntrNo, generalBloc];
}

class SiteStockCheckGetCY extends SiteStockCheckEvent {
  final GeneralBloc generalBloc;

  const SiteStockCheckGetCY({required this.generalBloc});
  @override
  List<Object?> get props => [generalBloc];
}

class SiteStockCheckGetEquipment extends SiteStockCheckEvent {
  final GeneralBloc generalBloc;
  final String dcCode;

  const SiteStockCheckGetEquipment(
      {required this.generalBloc, required this.dcCode});
  @override
  List<Object?> get props => [generalBloc, dcCode];
}

class SiteStockCheckPickCysite extends SiteStockCheckEvent {
  final String? cySiteName;
  final GeneralBloc generalBloc;

  const SiteStockCheckPickCysite({this.cySiteName, required this.generalBloc});
  @override
  List<Object?> get props => [cySiteName, generalBloc];
}

class SiteStockCheckSave extends SiteStockCheckEvent {
  final GeneralBloc generalBloc;
  final String trailerNo;
  final String? cySiteCode;
  final String? remark;

  const SiteStockCheckSave(
      {required this.trailerNo,
      required this.generalBloc,
      this.cySiteCode,
      required this.remark});

  @override
  List<Object?> get props => [generalBloc, trailerNo, cySiteCode, remark];
}
