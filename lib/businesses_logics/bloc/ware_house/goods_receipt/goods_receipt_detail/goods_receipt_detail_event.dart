part of 'goods_receipt_detail_bloc.dart';

abstract class GoodsReceiptDetailEvent extends Equatable {
  const GoodsReceiptDetailEvent();

  @override
  List<Object> get props => [];
}

class GoodsReceiptDetailViewLoaded extends GoodsReceiptDetailEvent {
  final int iOrderNo;
  final GeneralBloc generalBloc;
  const GoodsReceiptDetailViewLoaded({
    required this.iOrderNo,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [iOrderNo, generalBloc];
}

class GoodsReceiptDetailSave extends GoodsReceiptDetailEvent {
  final GeneralBloc generalBloc;
  final GoodReceiptOrderResponse goodsReceiptDetail;
  final double grQty;
  final String grade;
  final String status;
  final String locCode;
  final String propDate;
  final String expDate;
  final String lotCode;
  final bool isSplit;
  final SkuResponse sku;
  const GoodsReceiptDetailSave({
    required this.generalBloc,
    required this.goodsReceiptDetail,
    required this.grQty,
    required this.grade,
    required this.status,
    required this.locCode,
    required this.propDate,
    required this.expDate,
    required this.lotCode,
    required this.isSplit,
    required this.sku,
  });
  @override
  List<Object> get props => [
        generalBloc,
        goodsReceiptDetail,
        grQty,
        grade,
        status,
        locCode,
        propDate,
        expDate,
        lotCode,
        isSplit,
        sku
      ];
}
