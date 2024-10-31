part of 'haulage_daily_cntr_detail_bloc.dart';

sealed class HaulageDailyCntrDetailState extends Equatable {
  const HaulageDailyCntrDetailState();

  @override
  List<Object?> get props => [];
}

final class HaulageDailyCntrDetailInitial extends HaulageDailyCntrDetailState {}

final class HaulageDailyCntrDetailLoading extends HaulageDailyCntrDetailState {}

final class HaulageDailyCntrDetailSuccess extends HaulageDailyCntrDetailState {
  final GetDetailCntrHaulageRes detailCNTR;
  final GetNotifyCntrRes notifyRes;
  final List<GetStdCodeRes> lstStdNotify;

  const HaulageDailyCntrDetailSuccess(
      {required this.detailCNTR,
      required this.notifyRes,
      required this.lstStdNotify});
  @override
  List<Object?> get props => [detailCNTR, notifyRes, lstStdNotify];
}

final class HaulageDailyCntrDetailFailure extends HaulageDailyCntrDetailState {
  final String message;
  final int? errorCode;

  const HaulageDailyCntrDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

final class HaulageDailyCntrDetailSaveNotifySuccess
    extends HaulageDailyCntrDetailState {}
