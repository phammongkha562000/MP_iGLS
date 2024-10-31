part of 'inbound_order_status_search_bloc.dart';

sealed class InboundOrderStatusSearchState extends Equatable {
  const InboundOrderStatusSearchState();

  @override
  List<Object?> get props => [];
}

final class InboundOrderStatusSearchInitial
    extends InboundOrderStatusSearchState {}

final class InboundOrderStatusSearchLoading
    extends InboundOrderStatusSearchState {}

final class InboundOrderStatusSearchSuccess
    extends InboundOrderStatusSearchState {
  final List<GetStdCodeRes> lstInboundDateser;
  final List<GetStdCodeRes> lstOrdStatus;
  final List<UserDCResult> lstDC;
  const InboundOrderStatusSearchSuccess(
      {required this.lstInboundDateser,
      required this.lstOrdStatus,
      required this.lstDC});
  @override
  List<Object> get props => [lstInboundDateser, lstOrdStatus, lstDC];
}

final class InboundOrderStatusSearchFailure
    extends InboundOrderStatusSearchState {
  final int? errorCode;
  final String message;

  const InboundOrderStatusSearchFailure(
      {this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
