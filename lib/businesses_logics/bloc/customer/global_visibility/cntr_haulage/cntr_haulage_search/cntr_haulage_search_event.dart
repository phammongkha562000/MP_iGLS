part of 'cntr_haulage_search_bloc.dart';

sealed class CNTRHaulageSearchEvent extends Equatable {
  const CNTRHaulageSearchEvent();

  @override
  List<Object> get props => [];
}

class CNTRHaulageSearchViewLoaded extends CNTRHaulageSearchEvent {}

class GetUnlocPodEvent extends CNTRHaulageSearchEvent {
  final String unlocCode;
  const GetUnlocPodEvent({required this.unlocCode});
  @override
  List<Object> get props => [];
}

class GetUnlocPolEvent extends CNTRHaulageSearchEvent {
  final String unlocCode;
  const GetUnlocPolEvent({required this.unlocCode});
  @override
  List<Object> get props => [];
}
