part of 'goods_receipt_detail_bloc.dart';

abstract class GoodsReceiptDetailState extends Equatable {
  const GoodsReceiptDetailState();

  @override
  List<Object?> get props => [];
}

class GoodsReceiptDetailInitial extends GoodsReceiptDetailState {}

class GoodsReceiptDetailLoading extends GoodsReceiptDetailState {}

class GoodsReceiptDetailSuccess extends GoodsReceiptDetailState {
  final List<StdCode> stdCodeGrade;
  final List<StdCode> stdCodeStatus;
  final List<LocationStockCountResponse> locationList;
  final List<SkuResponse> skuResponse;
  final bool? saveSuccess;
  const GoodsReceiptDetailSuccess({
    required this.stdCodeGrade,
    required this.stdCodeStatus,
    required this.locationList,
    required this.skuResponse,
    this.saveSuccess,
  });
  @override
  List<Object?> get props =>
      [stdCodeGrade, stdCodeStatus, locationList, skuResponse, saveSuccess];

  GoodsReceiptDetailSuccess copyWith({
    List<StdCode>? stdCodeGrade,
    List<StdCode>? stdCodeStatus,
    List<LocationStockCountResponse>? locationList,
    List<SkuResponse>? skuResponse,
    bool? saveSuccess,
  }) {
    return GoodsReceiptDetailSuccess(
      stdCodeGrade: stdCodeGrade ?? this.stdCodeGrade,
      stdCodeStatus: stdCodeStatus ?? this.stdCodeStatus,
      locationList: locationList ?? this.locationList,
      skuResponse: skuResponse ?? this.skuResponse,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}

class GoodsReceiptDetailFailure extends GoodsReceiptDetailState {
  final String message;
  final int? errorCode;
  const GoodsReceiptDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class GoodsReceiptDetailSaveSuccess extends GoodsReceiptDetailState {}
