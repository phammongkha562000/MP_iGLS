part of 'outbound_order_status_bloc.dart';

sealed class CustomerOOSState extends Equatable {
  const CustomerOOSState();

  @override
  List<Object?> get props => [];
}

final class CustomerOOSInitial extends CustomerOOSState {}

final class CustomerOOSLoading extends CustomerOOSState {}

final class CustomerOOSSuccess extends CustomerOOSState {
  final List<CustomerOOSRes> oosList;

  const CustomerOOSSuccess({required this.oosList});
  @override
  List<Object?> get props => [oosList];

  CustomerOOSSuccess copyWith({List<CustomerOOSRes>? oosList}) {
    return CustomerOOSSuccess(oosList: oosList ?? this.oosList);
  }
}

final class CustomerOOSFailure extends CustomerOOSState {
  final String message;
  final int? errorCode;

  const CustomerOOSFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
