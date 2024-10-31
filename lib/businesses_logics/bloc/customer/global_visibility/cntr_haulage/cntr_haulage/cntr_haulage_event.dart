part of 'cntr_haulage_bloc.dart';

sealed class CntrHaulageEvent extends Equatable {
  const CntrHaulageEvent();

  @override
  List<Object> get props => [];
}

class CntrHaulageLoad extends CntrHaulageEvent {
  final GetCntrHaulageReq model;
  final String strCompany;
  const CntrHaulageLoad({required this.model, required this.strCompany});
  @override
  List<Object> get props => [];
}