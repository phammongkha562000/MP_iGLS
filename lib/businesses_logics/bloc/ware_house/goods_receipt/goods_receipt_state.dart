part of 'goods_receipt_bloc.dart';

abstract class GoodsReceiptState extends Equatable {
  const GoodsReceiptState();

  @override
  List<Object?> get props => [];
}

class GoodsReceiptInitial extends GoodsReceiptState {}

class GoodsReceiptLoading extends GoodsReceiptState {}

class GoodsReceiptSuccess extends GoodsReceiptState {
  final DateTime date;
  final List<OrderResponse> orderList;
  final GoodsReceiptResponse? goodsReceipt;
  final String? orderNo;

  const GoodsReceiptSuccess({
    required this.date,
    required this.orderList,
    this.goodsReceipt,
    this.orderNo,
  });
  @override
  List<Object?> get props => [date, orderList, goodsReceipt, orderNo];

  GoodsReceiptSuccess copyWith(
      {DateTime? date,
      List<OrderResponse>? orderList,
      GoodsReceiptResponse? goodsReceipt,
      String? orderNo,
      List<GoodReceiptOrderResponse>? goodsReceiptList,
      bool? isLoading}) {
    return GoodsReceiptSuccess(
      date: date ?? this.date,
      orderList: orderList ?? this.orderList,
      goodsReceipt: goodsReceipt,
      orderNo: orderNo == '' ? null : orderNo ?? this.orderNo,
    );
  }
}

class GoodsReceiptFailure extends GoodsReceiptState {
  final String message;
  final int? errorCode;
  const GoodsReceiptFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
