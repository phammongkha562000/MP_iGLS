part of 'barcode_tracking_bloc.dart';

sealed class BarcodeTrackingState extends Equatable {
  const BarcodeTrackingState();

  @override
  List<Object?> get props => [];
}

final class BarcodeTrackingInitial extends BarcodeTrackingState {}

final class BarcodeTrackingLoading extends BarcodeTrackingState {}

final class BarcodeTrackingSuccess extends BarcodeTrackingState {
  final List<GrTrackingResponse> lstTracking;

  const BarcodeTrackingSuccess({required this.lstTracking});
  @override
  List<Object?> get props => [lstTracking];
}

final class BarcodeTrackingFailure extends BarcodeTrackingState {
  final int? errorCode;
  final String message;

  const BarcodeTrackingFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
