part of 'cash_cost_approval_bloc.dart';

abstract class CashCostApprovalEvent extends Equatable {
  const CashCostApprovalEvent();

  @override
  List<Object?> get props => [];
}

class CashCostApprovalViewLoaded extends CashCostApprovalEvent {
  final DateTime date;
  final String tradeType;
  final GeneralBloc generalBloc;
  const CashCostApprovalViewLoaded(
      {required this.date, required this.tradeType, required this.generalBloc});
  @override
  List<Object> get props => [date, tradeType, generalBloc];
}

class CashCostApprovalPreviousDateLoaded extends CashCostApprovalEvent {
  final GeneralBloc generalBloc;
  const CashCostApprovalPreviousDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class CashCostApprovalNextDateLoaded extends CashCostApprovalEvent {
  final GeneralBloc generalBloc;
  const CashCostApprovalNextDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class CashCostApprovalPickDate extends CashCostApprovalEvent {
  final DateTime? date;
  final String? tradeType;
  final GeneralBloc generalBloc;

  const CashCostApprovalPickDate(
      {this.date, this.tradeType, required this.generalBloc});
  @override
  List<Object?> get props => [date, tradeType, generalBloc];
}

class CashCostApprovalSelected extends CashCostApprovalEvent {
  final bool isSelected;
  final int index;
  final List<CashCostApproval> cashCostList;
  const CashCostApprovalSelected(
      {required this.isSelected,
      required this.index,
      required this.cashCostList});

  @override
  List<Object> get props => [isSelected, index, cashCostList];
}

class CashCostApprovalUpdate extends CashCostApprovalEvent {
  final GeneralBloc generalBloc;
  const CashCostApprovalUpdate({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class CashCostApprovalPaging extends CashCostApprovalEvent {
  final UserInfo userInfo;

  const CashCostApprovalPaging({required this.userInfo});
  @override
  List<Object?> get props => [userInfo];
}
