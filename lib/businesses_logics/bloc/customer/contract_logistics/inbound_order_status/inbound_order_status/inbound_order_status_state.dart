part of 'inbound_order_status_bloc.dart';

sealed class CustomerIOSState extends Equatable {
  const CustomerIOSState();

  @override
  List<Object> get props => [];
}

final class CustomerIOSInitial extends CustomerIOSState {}

final class CustomerIOSLoaded extends CustomerIOSState {
  final List<GetStdCodeRes> lstInboundDateser;
  final List<GetStdCodeRes> lstOrdStatus;
  final List<UserDCResult> lstDC;
  const CustomerIOSLoaded(
      {required this.lstInboundDateser,
      required this.lstOrdStatus,
      required this.lstDC});
  @override
  List<Object> get props => [];
}

final class CustomerIOSLoadedFail extends CustomerIOSState {
  final String message;
  const CustomerIOSLoadedFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetInboundOrderSuccess extends CustomerIOSState {
  final List<GetInboundOrderRes> lstInboundOrder;
  const GetInboundOrderSuccess({
    required this.lstInboundOrder,
  });
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class GetInboundOrderFail extends CustomerIOSState {
  final String message;
  const GetInboundOrderFail({required this.message});
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class IOSShowLoadingState extends CustomerIOSState {}
