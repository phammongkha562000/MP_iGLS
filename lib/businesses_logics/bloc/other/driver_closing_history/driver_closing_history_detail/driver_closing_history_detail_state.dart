part of 'driver_closing_history_detail_bloc.dart';

sealed class DriverClosingHistoryDetailState extends Equatable {
  const DriverClosingHistoryDetailState();

  @override
  List<Object?> get props => [];
}

final class DriverClosingHistoryDetailInitial
    extends DriverClosingHistoryDetailState {}

final class DriverClosingHistoryDetailLoading
    extends DriverClosingHistoryDetailState {}

final class DriverClosingHistoryDetailSuccess
    extends DriverClosingHistoryDetailState {
  final DriverDailyClosingDetailResponse detail;

  const DriverClosingHistoryDetailSuccess({required this.detail});
}

final class DriverClosingHistoryDetailFailure
    extends DriverClosingHistoryDetailState {
  final String message;
  final int? errorCode;
  const DriverClosingHistoryDetailFailure(
      {required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

final class DriverClosingHistoryDetailSaveSuccess
    extends DriverClosingHistoryDetailState {}
