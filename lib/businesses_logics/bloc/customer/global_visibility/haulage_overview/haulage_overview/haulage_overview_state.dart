part of 'haulage_overview_bloc.dart';

sealed class HaulageOverviewState extends Equatable {
  const HaulageOverviewState();

  @override
  List<Object?> get props => [];
}

final class HaulageOverviewInitial extends HaulageOverviewState {}

final class HaulageOverviewLoading extends HaulageOverviewState {}

final class HaulageOverviewSuccess extends HaulageOverviewState {
  final CustomerHaulageOverviewRes haulageOverview;

  const HaulageOverviewSuccess({required this.haulageOverview});
  @override
  List<Object?> get props => [haulageOverview];
  HaulageOverviewSuccess copyWith(
      {CustomerHaulageOverviewRes? haulageOverview}) {
    return HaulageOverviewSuccess(
      haulageOverview: haulageOverview ?? this.haulageOverview,
    );
  }
}

final class HaulageOverviewFailure extends HaulageOverviewState {
  final String message;
  final int? errorCode;

  const HaulageOverviewFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
