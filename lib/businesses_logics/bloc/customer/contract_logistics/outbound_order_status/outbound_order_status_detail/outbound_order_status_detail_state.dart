part of 'outbound_order_status_detail_bloc.dart';

sealed class CustomerOOSDetailState extends Equatable {
  const CustomerOOSDetailState();

  @override
  List<Object?> get props => [];
}

final class CustomerOOSDetailInitial extends CustomerOOSDetailState {}

final class CustomerOOSDetailLoading extends CustomerOOSDetailState {}

final class CustomerOOSDetailSuccess extends CustomerOOSDetailState {
  final CustomerOOSDetailRes detail;

  const CustomerOOSDetailSuccess({required this.detail});
  @override
  List<Object?> get props => [detail];
}

final class CustomerOOSDetailFailure extends CustomerOOSDetailState {
  final String message;
  final int? errorCode;

  const CustomerOOSDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
