part of 'transport_order_status_search_bloc.dart';

sealed class CustomerTOSSearchState extends Equatable {
  const CustomerTOSSearchState();

  @override
  List<Object?> get props => [];
}

final class CustomerTOSSearchInitial extends CustomerTOSSearchState {}

final class CustomerTOSSearchLoading extends CustomerTOSSearchState {}

final class CustomerTOSSearchSuccess extends CustomerTOSSearchState {
  final List<CustomerCompanyRes> lstCompany;
  final List<GetStdCodeRes> lstOrderStatus;

  const CustomerTOSSearchSuccess({
    required this.lstCompany,
    required this.lstOrderStatus,
  });

  CustomerTOSSearchSuccess copyWith({
    List<CustomerCompanyRes>? lstCompany,
    List<GetStdCodeRes>? lstOrderStatus,
  }) {
    return CustomerTOSSearchSuccess(
        lstOrderStatus: lstOrderStatus ?? this.lstOrderStatus,
        lstCompany: lstCompany ?? this.lstCompany);
  }

  @override
  List<Object?> get props => [lstCompany, lstOrderStatus];
}

final class CustomerTOSSearchFailure extends CustomerTOSSearchState {
  final String message;
  final int? errorCode;

  const CustomerTOSSearchFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
