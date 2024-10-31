part of 'inbound_order_detail_bloc.dart';

sealed class InboundOrderDetailEvent extends Equatable {
  const InboundOrderDetailEvent();

  @override
  List<Object> get props => [];
}

class InboundOrderDetailLoaded extends InboundOrderDetailEvent {
  final String orderId;
  final String strCompany;
  const InboundOrderDetailLoaded(
      {required this.orderId, required this.strCompany});
  @override
  List<Object> get props => [];
}

class DownloadFileEvent extends InboundOrderDetailEvent {
  final String docNo;
  final String fileName;
  final String strCompany;
  const DownloadFileEvent(
      {required this.docNo, required this.fileName, required this.strCompany});
  @override
  List<Object> get props => [];
}
