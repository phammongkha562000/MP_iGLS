part of 'transport_order_status_bloc.dart';

sealed class CustomerTOSState extends Equatable {
  const CustomerTOSState();

  @override
  List<Object?> get props => [];
}

final class CustomerTOSInitial extends CustomerTOSState {}

final class CustomerTOSLoading extends CustomerTOSState {}

final class CustomerTOSSuccess extends CustomerTOSState {
  final List<CustomerTOSRes> lstTOS;

  const CustomerTOSSuccess({required this.lstTOS});

  CustomerTOSSuccess copyWith({
    List<CustomerTOSRes>? lstTOS,
  }) {
    return CustomerTOSSuccess(
      lstTOS: lstTOS ?? this.lstTOS,
    );
  }

  @override
  List<Object?> get props => [lstTOS];
}

final class CustomerTOSFailure extends CustomerTOSState {
  final String message;
  final int? errorCode;

  const CustomerTOSFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
