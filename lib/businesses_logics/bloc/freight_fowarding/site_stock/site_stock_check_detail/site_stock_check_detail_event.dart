part of 'site_stock_check_detail_bloc.dart';

abstract class SiteStockCheckDetailEvent extends Equatable {
  const SiteStockCheckDetailEvent();

  @override
  List<Object?> get props => [];
}

class SiteStockCheckDetailViewLoaded extends SiteStockCheckDetailEvent {
  final String cyCode;
  final GeneralBloc generalBloc;

  const SiteStockCheckDetailViewLoaded(
      {required this.cyCode, required this.generalBloc});
  @override
  List<Object> get props => [cyCode, generalBloc];
}

class SiteStockCheckDetailSearch extends SiteStockCheckDetailEvent {
  final String cySiteCode;
  final GeneralBloc generalBloc;
  final String dcCode;
  final int rangeDate;

  const SiteStockCheckDetailSearch({
    required this.cySiteCode,
    required this.generalBloc,
    required this.dcCode,
    required this.rangeDate,
  });
  @override
  List<Object?> get props => [cySiteCode, generalBloc, dcCode, rangeDate];
}

class SiteStockCheckDetailDelete extends SiteStockCheckDetailEvent {
  final int trsId;
  final String updateUser;
  final String subsidiaryId;

  const SiteStockCheckDetailDelete({
    required this.trsId,
    required this.updateUser,
    required this.subsidiaryId,
  });
  @override
  List<Object?> get props => [trsId, updateUser];
}
