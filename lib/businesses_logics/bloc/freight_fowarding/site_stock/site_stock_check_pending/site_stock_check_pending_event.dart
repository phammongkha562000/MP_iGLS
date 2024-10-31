part of 'site_stock_check_pending_bloc.dart';

sealed class SiteStockCheckPendingEvent extends Equatable {
  const SiteStockCheckPendingEvent();

  @override
  List<Object?> get props => [];
}

class SiteStockCheckPendingViewLoaded extends SiteStockCheckPendingEvent {
  final GeneralBloc generalBloc;
  const SiteStockCheckPendingViewLoaded({required this.generalBloc});
  @override
  List<Object> get props => [];
}

class SiteStockCheckPendingSearch extends SiteStockCheckPendingEvent {
  final String cySiteCode;
  final GeneralBloc generalBloc;
  final String dcCode;
  final int rangeDate;

  const SiteStockCheckPendingSearch({
    required this.cySiteCode,
    required this.generalBloc,
    required this.dcCode,
    required this.rangeDate,
  });
  @override
  List<Object?> get props => [cySiteCode, generalBloc, dcCode, rangeDate];
}
