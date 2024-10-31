part of 'site_trailer_pending_bloc.dart';

sealed class SiteTrailerPendingEvent extends Equatable {
  const SiteTrailerPendingEvent();

  @override
  List<Object?> get props => [];
}

class SiteTrailerPendingLoad extends SiteTrailerPendingEvent {
  final GeneralBloc generalBloc;
  final CySiteResponse? cyPending;
  const SiteTrailerPendingLoad({required this.generalBloc, this.cyPending});
  @override
  List<Object> get props => [];
}

// class SiteTrailerPendingFilterByCY extends SiteTrailerPendingEvent {
//   final CySiteResponse? cyPending;
//   final GeneralBloc generalBloc;

//   const SiteTrailerPendingFilterByCY(
//       {this.cyPending, required this.generalBloc});
//   @override
//   List<Object?> get props => [cyPending, generalBloc];
// }

class SiteTrailerIsPendingChanged extends SiteTrailerPendingEvent {
  final bool isPending;
  final GeneralBloc generalBloc;
  final CySiteResponse? cyPending;

  const SiteTrailerIsPendingChanged(
      {required this.isPending, required this.generalBloc, this.cyPending});
  @override
  List<Object?> get props => [isPending, generalBloc, cyPending];
}
