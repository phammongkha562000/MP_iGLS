part of 'haulage_overview_cntr_detail_bloc.dart';

sealed class HaulageOverviewCntrDetailState extends Equatable {
  const HaulageOverviewCntrDetailState();

  @override
  List<Object?> get props => [];
}

final class HaulageOverviewCntrDetailInitial
    extends HaulageOverviewCntrDetailState {}

final class HaulageOverviewCntrDetailLoading
    extends HaulageOverviewCntrDetailState {}

final class HaulageOverviewCntrDetailSuccess
    extends HaulageOverviewCntrDetailState {
  final GetDetailCntrHaulageRes detailCNTR;
  final GetNotifyCntrRes notifyRes;
  final List<GetStdCodeRes> lstStdNotify;

  const HaulageOverviewCntrDetailSuccess(
      {required this.detailCNTR,
      required this.notifyRes,
      required this.lstStdNotify});
  @override
  List<Object?> get props => [detailCNTR, notifyRes, lstStdNotify];
}

final class HaulageOverviewCntrDetailFailure
    extends HaulageOverviewCntrDetailState {
  final String message;
  final int? errorCode;

  const HaulageOverviewCntrDetailFailure(
      {required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

final class HaulageOverviewCntrDetailSaveNotifySuccess
    extends HaulageOverviewCntrDetailState {}
