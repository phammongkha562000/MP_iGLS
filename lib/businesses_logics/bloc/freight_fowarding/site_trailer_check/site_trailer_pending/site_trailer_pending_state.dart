part of 'site_trailer_pending_bloc.dart';

sealed class SiteTrailerPendingState extends Equatable {
  const SiteTrailerPendingState();

  @override
  List<Object> get props => [];
}

final class SiteTrailerPendingInitial extends SiteTrailerPendingState {}

final class SiteTrailerPendingSuccess extends SiteTrailerPendingState {
  final List<TrailerPendingRes> lstTrailerPendingFilter;

  const SiteTrailerPendingSuccess({
    required this.lstTrailerPendingFilter,
  });

  @override
  List<Object> get props => [lstTrailerPendingFilter];
}

final class SiteTrailerPendingLoading extends SiteTrailerPendingState {}

final class SiteTrailerPendingFailure extends SiteTrailerPendingState {
  final String message;
  final int? errorCode;
  const SiteTrailerPendingFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object> get props => [];
}
