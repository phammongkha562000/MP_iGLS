part of 'cntr_haulage_search_bloc.dart';

sealed class CNTRHaulageSearchState extends Equatable {
  const CNTRHaulageSearchState();

  @override
  List<Object?> get props => [];
}

final class CNTRHaulageSearchInitial extends CNTRHaulageSearchState {}

final class CNTRHaulageSearchLoading extends CNTRHaulageSearchState {}

final class CNTRHaulageSearchSuccess extends CNTRHaulageSearchState {
  final List<TradeType> lstTradeType;
  final List<Status> lstStatus;
  final List<DayType> lstDayType;
  const CNTRHaulageSearchSuccess(
      {required this.lstTradeType,
      required this.lstStatus,
      required this.lstDayType});
  @override
  List<Object> get props => [lstTradeType, lstStatus, lstDayType];
}

final class CNTRHaulageSearchFailure extends CNTRHaulageSearchState {
  final String message;
  final int? errorCode;

  const CNTRHaulageSearchFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

final class GetUnlocPodSuccess extends CNTRHaulageSearchState {
  final List<GetUnlocResult> lstUnloc;
  const GetUnlocPodSuccess({required this.lstUnloc});
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class GetUnlocFail extends CNTRHaulageSearchState {
  final String message;
  const GetUnlocFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetUnlocPolSuccess extends CNTRHaulageSearchState {
  final List<GetUnlocResult> lstUnloc;
  const GetUnlocPolSuccess({required this.lstUnloc});
  @override
  List<Object> get props => [];
}
