part of 'site_stock_check_pending_bloc.dart';

sealed class SiteStockCheckPendingState extends Equatable {
  const SiteStockCheckPendingState();

  @override
  List<Object?> get props => [];
}

final class SiteStockCheckPendingInitial extends SiteStockCheckPendingState {}

final class SiteStockCheckPendingLoading extends SiteStockCheckPendingState {}

final class SiteStockCheckPendingSuccess extends SiteStockCheckPendingState {
  final List<TrailerPendingRes> pendingList;
  final List<DcLocal> dcList;
  final List<CySiteResponse> cySiteList;

  const SiteStockCheckPendingSuccess({
    required this.pendingList,
    required this.dcList,
    required this.cySiteList,
  });
  @override
  List<Object?> get props => [pendingList, dcList, cySiteList];
}

final class SiteStockCheckPendingFailure extends SiteStockCheckPendingState {
  final int? errorCode;
  final String message;

  const SiteStockCheckPendingFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

final class GetSiteStockCheckPendingSuccess extends SiteStockCheckPendingState {
  final List<TrailerPendingRes> pendingList;

  const GetSiteStockCheckPendingSuccess({required this.pendingList});
  @override
  List<Object?> get props => [pendingList];
}
