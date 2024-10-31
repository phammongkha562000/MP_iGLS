part of 'goods_receipt_bloc.dart';

abstract class GoodsReceiptEvent extends Equatable {
  const GoodsReceiptEvent();

  @override
  List<Object?> get props => [];
}

class GoodsReceiptViewLoaded extends GoodsReceiptEvent {
  final DateTime date;
  final String? orderNo;
  final GeneralBloc generalBloc;
  // final String? pageId;
  // final String? pageName;
  const GoodsReceiptViewLoaded(
      {required this.date, this.orderNo, required this.generalBloc
      // this.pageId,
      // this.pageName,
      });
  @override
  List<Object?> get props =>
      [date, orderNo, generalBloc /* pageId, pageName */];
}

class GoodsReceiptSearch extends GoodsReceiptEvent {
  final String orderNo;
  final GeneralBloc generalBloc;

  const GoodsReceiptSearch({
    required this.orderNo,
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [orderNo, generalBloc];
}

class GoodsReceiptPickDate extends GoodsReceiptEvent {
  final DateTime date;
  final String? orderNo;
  final GeneralBloc generalBloc;
  const GoodsReceiptPickDate(
      {required this.date, this.orderNo, required this.generalBloc});
  @override
  List<Object?> get props => [date, orderNo];
}

class GoodsReceiptPickOrderNo extends GoodsReceiptEvent {
  final String orderNo;
  const GoodsReceiptPickOrderNo({required this.orderNo});
  @override
  List<Object?> get props => [orderNo];
}
