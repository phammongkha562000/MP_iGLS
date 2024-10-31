part of 'cntr_haulage_detail_bloc.dart';

sealed class CntrHaulageDetailState extends Equatable {
  const CntrHaulageDetailState();

  @override
  List<Object> get props => [];
}

final class CntrHaulageDetailInitial extends CntrHaulageDetailState {}

final class DetailCntrHaulageLoadFail extends CntrHaulageDetailState {
  final String message;
  const DetailCntrHaulageLoadFail({required this.message});
  @override
  List<Object> get props => [];
}

final class DetailCntrHaulageLoadSuccess extends CntrHaulageDetailState {
  final List<WOCDetail> lstWOCDetail;
  final GetNotifyCntrRes notifyRes;
  final String email;
  const DetailCntrHaulageLoadSuccess(
      {required this.lstWOCDetail,
      required this.notifyRes,
      required this.email});
  @override
  List<Object> get props => [email];
}

final class GetStdCodeFail extends CntrHaulageDetailState {
  final String message;
  const GetStdCodeFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetStdCodeSuccess extends CntrHaulageDetailState {
  final List<GetStdCodeRes> stdCodeRes;
  const GetStdCodeSuccess({required this.stdCodeRes});
  @override
  List<Object> get props => [];
}

final class UpdateNotifySettingSuccess extends CntrHaulageDetailState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class UpdateNotifySettingFail extends CntrHaulageDetailState {
  final String message;
  const UpdateNotifySettingFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetNotifySuccess extends CntrHaulageDetailState {}

final class DetailShowLoadingState extends CntrHaulageDetailState {}

final class HideLoadingState extends CntrHaulageDetailState {}
