part of 'picking_bloc.dart';

sealed class PickingState extends Equatable {
  const PickingState();

  @override
  List<Object?> get props => [];
}

final class PickingInitial extends PickingState {}

final class PickingLoading extends PickingState {}

final class PickingSuccess extends PickingState {
  final List<PickingItemResponse> lstItem;

  const PickingSuccess({required this.lstItem});
  @override
  List<Object?> get props => [lstItem];
}

final class PickingFailure extends PickingState {
  final int? errorCode;
  final String message;

  const PickingFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
