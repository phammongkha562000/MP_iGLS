part of 'cntr_ageing_bloc.dart';

sealed class CntrAgeingState extends Equatable {
  const CntrAgeingState();

  @override
  List<Object> get props => [];
}

final class CntrAgeingInitial extends CntrAgeingState {}

final class GetWoCntrAgeingSuccess extends CntrAgeingState {
  final List<GetCntrAgeingRes> lstWoCntrAgeing;
  final List<BarChartGroupData> lstBarChartData;
  const GetWoCntrAgeingSuccess(
      {required this.lstWoCntrAgeing, required this.lstBarChartData});
  @override
  List<Object> get props => [];
}

final class GetWoCntrAgeingFail extends CntrAgeingState {
  final String message;
  const GetWoCntrAgeingFail({required this.message});
  @override
  List<Object> get props => [];
}

final class AgeingShowLoadingState extends CntrAgeingState {}
