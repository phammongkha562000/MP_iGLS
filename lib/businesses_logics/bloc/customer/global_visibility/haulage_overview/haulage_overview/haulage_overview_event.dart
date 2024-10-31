part of 'haulage_overview_bloc.dart';

sealed class HaulageOverviewEvent extends Equatable {
  const HaulageOverviewEvent();

  @override
  List<Object> get props => [];
}

class HaulageOverviewSearch extends HaulageOverviewEvent {
  final CustomerHaulageOverviewReq model;

  const HaulageOverviewSearch({required this.model});
  @override
  List<Object> get props => [model];
}
