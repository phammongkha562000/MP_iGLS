part of 'stock_count_bloc.dart';

abstract class StockCountEvent extends Equatable {
  const StockCountEvent();

  @override
  List<Object?> get props => [];
}

class StockCountViewLoaded extends StockCountEvent {
  final int round;
  // final String? pageId;
  // final String? pageName;
  final GeneralBloc generalBloc;
  const StockCountViewLoaded(
      {required this.round,
      // this.pageId,
      // this.pageName,
      required this.generalBloc});
  @override
  List<Object?> get props => [round, /*  pageId, pageName, */ generalBloc];
}

class StockCountSave extends StockCountEvent {
  final int round;
  final String locCode;
  final String itemCode;
  final String yyyymm;
  final double quantity;
  final String memo;
  final GeneralBloc generalBloc;
  final String uom;
  const StockCountSave(
      {required this.round,
      required this.locCode,
      required this.itemCode,
      required this.yyyymm,
      required this.quantity,
      required this.memo,
      required this.generalBloc,
      required this.uom});

  @override
  List<Object> get props =>
      [round, locCode, itemCode, yyyymm, quantity, memo, generalBloc, uom];
}

class DeleteStockCount extends StockCountEvent {
  final int id;
  final GeneralBloc generalBloc;
  const DeleteStockCount({required this.id, required this.generalBloc});
  @override
  List<Object> get props => [id, generalBloc];
}
