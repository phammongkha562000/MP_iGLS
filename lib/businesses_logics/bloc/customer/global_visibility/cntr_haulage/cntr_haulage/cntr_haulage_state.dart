part of 'cntr_haulage_bloc.dart';

sealed class CntrHaulageState extends Equatable {
  const CntrHaulageState();

  @override
  List<Object> get props => [];
}

final class CntrHaulageInitial extends CntrHaulageState {}

final class CntrHaulageLoading extends CntrHaulageState {}

final class CntrHaulageLoadFail extends CntrHaulageState {
  final String message;
  const CntrHaulageLoadFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetCntrHaulageSuccess extends CntrHaulageState {
  final List<GetCntrHaulageRes> lstCntrHaulage;
  const GetCntrHaulageSuccess({required this.lstCntrHaulage});
  @override
  List<Object> get props => [];
}

final class GetCntrHaulageFail extends CntrHaulageState {
  final String message;
  const GetCntrHaulageFail({required this.message});
  @override
  List<Object> get props => [identityHashCode(this)];
}
