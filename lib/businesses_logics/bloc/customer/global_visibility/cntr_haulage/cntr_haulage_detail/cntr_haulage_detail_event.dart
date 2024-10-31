part of 'cntr_haulage_detail_bloc.dart';

sealed class CntrHaulageDetailEvent extends Equatable {
  const CntrHaulageDetailEvent();

  @override
  List<Object> get props => [];
}

class DetailCntrHauLageLoad extends CntrHaulageDetailEvent {
  final String woNo;
  final String woItemNo;
  final String subsidiaryId;
  const DetailCntrHauLageLoad(
      {required this.woNo, required this.woItemNo, required this.subsidiaryId});
  @override
  List<Object> get props => [];
}

class GetStdCodeNotify extends CntrHaulageDetailEvent {
  final String subsidiaryId;
  const GetStdCodeNotify({required this.subsidiaryId});
  @override
  List<Object> get props => [];
}

final class SaveNotifySettingEvent extends CntrHaulageDetailEvent {
  final SaveNotifySettingReq model;
  final String subsidiaryId;
  const SaveNotifySettingEvent(
      {required this.model, required this.subsidiaryId});
  @override
  List<Object> get props => [];
}

final class DelNotifySettingEvent extends CntrHaulageDetailEvent {
  final String subsidiaryId;
  final String woNo;
  final int itemNo;
  final String userId;
  final CustomerBloc customerBloc;
  const DelNotifySettingEvent(
      {required this.subsidiaryId,
      required this.woNo,
      required this.userId,
      required this.itemNo,
      required this.customerBloc});
  @override
  List<Object> get props => [];
}
