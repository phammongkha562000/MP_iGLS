part of 'picking_detail_bloc.dart';

sealed class PickingDetailState extends Equatable {
  const PickingDetailState();

  @override
  List<Object?> get props => [];
}

final class PickingDetailInitial extends PickingDetailState {}

final class PickingDetailLoading extends PickingDetailState {}

final class PickingDetailSuccess extends PickingDetailState {
  final PickingItemResponse pickingItem;

  const PickingDetailSuccess({required this.pickingItem});
  @override
  List<Object?> get props => [pickingItem];
}

final class PickingDetailFailure extends PickingDetailState {
  final int? errorCode;
  final String message;

  const PickingDetailFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

final class PickingDetailCheckGRSuccess extends PickingDetailState {
  final String grNoResult;

  const PickingDetailCheckGRSuccess({required this.grNoResult});
  @override
  List<Object> get props => [
        [grNoResult]
      ];
}

final class PickingDetailSaveSuccess extends PickingDetailState {
  final double remaining;

  const PickingDetailSaveSuccess({required this.remaining});
  @override
  List<Object?> get props => [remaining];
}
