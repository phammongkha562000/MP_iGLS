part of 'haulage_daily_bloc.dart';

sealed class HaulageDailyState extends Equatable {
  const HaulageDailyState();

  @override
  List<Object?> get props => [];
}

final class HaulageDailyInitial extends HaulageDailyState {}

final class HaulageDailyLoading extends HaulageDailyState {}

final class HaulageDailySuccess extends HaulageDailyState {
  final CustomerHaulageDailyRes haulageDaily;
  final List<HaulageDailyDetail> details;
  const HaulageDailySuccess(
      {required this.haulageDaily, required this.details});
  @override
  List<Object?> get props => [haulageDaily, details];
  HaulageDailySuccess copyWith(
      {CustomerHaulageDailyRes? haulageDaily,
      List<HaulageDailyDetail>? details}) {
    return HaulageDailySuccess(
      haulageDaily: haulageDaily ?? this.haulageDaily,
      details: details ?? this.details,
    );
  }
}

final class HaulageDailyFailure extends HaulageDailyState {
  final String message;
  final int? errorCode;

  const HaulageDailyFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
