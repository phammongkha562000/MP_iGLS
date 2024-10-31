part of 'site_trailer_history_bloc.dart';

sealed class SiteTrailerHistoryState extends Equatable {
  const SiteTrailerHistoryState();

  @override
  List<Object?> get props => [];
}

final class SiteTrailerHistoryInitial extends SiteTrailerHistoryState {}

final class SiteTrailerHistoryLoading extends SiteTrailerHistoryState {}

final class SiteTrailerHistorySuccess extends SiteTrailerHistoryState {
  final List<SiteTrailerResponse> historyList;
  final List<SiteTrailerResponse> historyFilterList;
  final List<CySiteResponse> cySiteList;

  const SiteTrailerHistorySuccess(
      {required this.historyList,
      required this.cySiteList,
      required this.historyFilterList});

  SiteTrailerHistorySuccess copyWith({
    List<SiteTrailerResponse>? historyList,
    List<SiteTrailerResponse>? historyFilterList,
    List<CySiteResponse>? cySiteList,
  }) {
    return SiteTrailerHistorySuccess(
      cySiteList: cySiteList ?? this.cySiteList,
      historyList: historyList ?? this.historyList,
      historyFilterList: historyFilterList ?? this.historyFilterList,
    );
  }

  @override
  List<Object> get props => [historyList, cySiteList, historyFilterList];
}

final class SiteTrailerHistoryFailure extends SiteTrailerHistoryState {
  final String message;
  final int? errorCode;
  const SiteTrailerHistoryFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
