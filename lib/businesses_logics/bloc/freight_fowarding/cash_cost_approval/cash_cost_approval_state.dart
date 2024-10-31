part of 'cash_cost_approval_bloc.dart';

abstract class CashCostApprovalState extends Equatable {
  const CashCostApprovalState();

  @override
  List<Object?> get props => [];
}

class CashCostApprovalInitial extends CashCostApprovalState {}

class CashCostApprovalLoading extends CashCostApprovalState {}

class CashCostApprovalSuccess extends CashCostApprovalState {
  final bool? isSuccess;
  final DateTime date;
  final String tradeType;
  final List<CashCostApprovalResult> cashCostList;
  const CashCostApprovalSuccess(
      {this.isSuccess,
      required this.date,
      required this.tradeType,
      required this.cashCostList});
  @override
  List<Object?> get props => [date, tradeType, cashCostList, isSuccess];

  CashCostApprovalSuccess copyWith(
      {DateTime? date,
      String? tradeType,
      bool? isSuccess,
      List<CashCostApprovalResult>? cashCostList}) {
    return CashCostApprovalSuccess(
        date: date ?? this.date,
        tradeType: tradeType ?? this.tradeType,
        isSuccess: isSuccess,
        cashCostList: cashCostList ?? this.cashCostList);
  }
}

class CashCostApprovalFailure extends CashCostApprovalState {
  final String message;
  final int? errorCode;
  const CashCostApprovalFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
