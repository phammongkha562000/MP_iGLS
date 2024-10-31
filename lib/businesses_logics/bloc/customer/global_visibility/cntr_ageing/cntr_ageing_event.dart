part of 'cntr_ageing_bloc.dart';

sealed class CntrAgeingEvent extends Equatable {
  const CntrAgeingEvent();

  @override
  List<Object> get props => [];
}

class GetWoCntrAgeingEvent extends CntrAgeingEvent {
  final String subsidiaryId;
  final GetCntrAgeingReq model;
  const GetWoCntrAgeingEvent({required this.subsidiaryId, required this.model});
  @override
  List<Object> get props => [];
}
