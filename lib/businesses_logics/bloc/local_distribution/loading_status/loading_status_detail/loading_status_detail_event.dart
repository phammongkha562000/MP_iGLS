part of 'loading_status_detail_bloc.dart';

abstract class LoadingStatusDetailEvent extends Equatable {
  const LoadingStatusDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadingStatusDetailViewLoaded extends LoadingStatusDetailEvent {
  final String tripNo;
  final LoadingStatusResponse detail;
  final DateTime etp;
  const LoadingStatusDetailViewLoaded({
    required this.tripNo,
    required this.detail,
    required this.etp,
  });
  @override
  List<Object> get props => [tripNo, detail, etp];
}

class LoadingStatusSave extends LoadingStatusDetailEvent {
  final String loadingMemo;
  final String loadingStart;
  final String? loadingEnd;
  final String tripNo;
  final GeneralBloc generalBloc;

  const LoadingStatusSave(
      {required this.loadingMemo,
      required this.loadingStart,
      required this.generalBloc,
      this.loadingEnd,
      required this.tripNo});
  @override
  List<Object?> get props =>
      [loadingMemo, loadingStart, loadingEnd, tripNo, generalBloc];
}

class LoadingNormalTripUpdateStatus extends LoadingStatusDetailEvent {
  final int orgItemNo;
  final String eventType;
  final String tripNo;
  final GeneralBloc generalBloc;
  const LoadingNormalTripUpdateStatus(
      {required this.orgItemNo,
      required this.eventType,
      required this.tripNo,
      required this.generalBloc});
  @override
  List<Object> get props => [orgItemNo, eventType, tripNo, generalBloc];
}

class LoadingTripDetailUpdateStatus extends LoadingStatusDetailEvent {
  final String tripNo;
  final String eventType;
  final int? orgItemNo;
  final int? orderId;
  final String? deliveryResult;
  final GeneralBloc generalBloc;
  const LoadingTripDetailUpdateStatus(
      {required this.tripNo,
      required this.eventType,
      this.orgItemNo,
      this.orderId,
      this.deliveryResult,
      required this.generalBloc});
  @override
  List<Object?> get props =>
      [tripNo, eventType, orgItemNo, orderId, deliveryResult, generalBloc];
}
