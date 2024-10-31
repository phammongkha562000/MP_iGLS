part of 'outbound_order_status_search_bloc.dart';

sealed class OutboundOrderStatusSearchState extends Equatable {
  const OutboundOrderStatusSearchState();

  @override
  List<Object?> get props => [];
}

final class OutboundOrderStatusSearchInitial
    extends OutboundOrderStatusSearchState {}

final class OutboundOrderStatusSearchLoading
    extends OutboundOrderStatusSearchState {}

final class OutboundOrderStatusSearchSuccess
    extends OutboundOrderStatusSearchState {
  final List<GetStdCodeRes> lstOutboundDateser;
  final List<GetStdCodeRes> lstOrdStatus;
  final List<UserDCResult> lstDC;

  const OutboundOrderStatusSearchSuccess(
      {required this.lstOutboundDateser,
      required this.lstOrdStatus,
      required this.lstDC});
  @override
  List<Object?> get props => [lstOutboundDateser, lstOrdStatus, lstDC];
}

final class OutboundOrderStatusSearchFailure
    extends OutboundOrderStatusSearchState {
  final int? errorCode;
  final String message;

  const OutboundOrderStatusSearchFailure(
      {this.errorCode, required this.message});

  @override
  List<Object?> get props => [errorCode, message];
}
