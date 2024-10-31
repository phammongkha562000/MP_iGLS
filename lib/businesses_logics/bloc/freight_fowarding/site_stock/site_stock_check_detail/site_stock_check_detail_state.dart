part of 'site_stock_check_detail_bloc.dart';

abstract class SiteStockCheckDetailState extends Equatable {
  const SiteStockCheckDetailState();

  @override
  List<Object?> get props => [];
}

class SiteStockCheckDetailInitial extends SiteStockCheckDetailState {}

class SiteStockCheckDetailLoading extends SiteStockCheckDetailState {}

class SiteStockCheckDetailSuccess extends SiteStockCheckDetailState {
  final List<CySiteResponse> cySiteList;
  final List<SiteStockCheckResponse> siteStockCheckList;
  final List<DcLocal> dcList;
  final List<SiteStockSummaryResponse> summaryList;
  const SiteStockCheckDetailSuccess(
      {required this.cySiteList,
      required this.siteStockCheckList,
      required this.summaryList,
      required this.dcList});
  @override
  List<Object?> get props =>
      [cySiteList, siteStockCheckList, dcList, summaryList];
}

class SiteStockCheckDetailFailure extends SiteStockCheckDetailState {
  final String message;
  final int? errorCode;
  const SiteStockCheckDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class GetSiteStockCheckDetailSuccess extends SiteStockCheckDetailState {
  final List<SiteStockCheckResponse> siteStockCheckList;
  final List<SiteStockSummaryResponse> summaryList;

  const GetSiteStockCheckDetailSuccess(
      {required this.siteStockCheckList, required this.summaryList});
  @override
  List<Object?> get props => [siteStockCheckList];
}

class SiteStockCheckDeleteSuccess extends SiteStockCheckDetailState {}
