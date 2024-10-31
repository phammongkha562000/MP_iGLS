part of 'stock_count_bloc.dart';

abstract class StockCountState extends Equatable {
  const StockCountState();

  @override
  List<Object?> get props => [];
}

class StockCountInitial extends StockCountState {}

class StockCountLoading extends StockCountState {}

class StockCountSuccess extends StockCountState {
  final bool? saveSuccess;
  final bool? deleteSucess;
  final int round;
  final List<StockCountResponse> stockCountList;
  final List<LocationStockCountResponse> locationList;
  final List<ItemCodeResponse> itemCodeList;
  final double totalQty;
  final List<StdCode> uomLst;
  const StockCountSuccess({
    this.saveSuccess,
    this.deleteSucess,
    required this.round,
    required this.stockCountList,
    required this.locationList,
    required this.itemCodeList,
    required this.totalQty,
    required this.uomLst,
  });

  @override
  List<Object?> get props => [
        round,
        stockCountList,
        locationList,
        itemCodeList,
        saveSuccess,
        deleteSucess,
        uomLst
      ];

  StockCountSuccess copyWith(
      {bool? saveSuccess,
      bool? deleteSucess,
      int? round,
      List<StockCountResponse>? stockCountList,
      List<LocationStockCountResponse>? locationList,
      List<ItemCodeResponse>? itemCodeList,
      double? totalQty,
      List<StdCode>? uomLst}) {
    return StockCountSuccess(
      saveSuccess: saveSuccess ?? this.saveSuccess,
      deleteSucess: deleteSucess ?? this.deleteSucess,
      round: round ?? this.round,
      stockCountList: stockCountList ?? this.stockCountList,
      locationList: locationList ?? this.locationList,
      itemCodeList: itemCodeList ?? this.itemCodeList,
      totalQty: totalQty ?? this.totalQty,
      uomLst: uomLst ?? this.uomLst,
    );
  }
}

class StockCountFailure extends StockCountState {
  final String message;
  final int? errorCode;
  const StockCountFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
