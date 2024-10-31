part of 'put_away_search_bloc.dart';

sealed class PutAwaySearchState extends Equatable {
  const PutAwaySearchState();

  @override
  List<Object?> get props => [];
}

final class PutAwaySearchInitial extends PutAwaySearchState {}

final class PutAwaySearchLoading extends PutAwaySearchState {}

final class PutAwaySearchSuccess extends PutAwaySearchState {
  final List<OrderTypeRes> lstOrderType;
  final List<StaffsResponse> lstStaffWorking;

  const PutAwaySearchSuccess(
      {required this.lstOrderType, required this.lstStaffWorking});
  @override
  List<Object?> get props => [lstOrderType, lstStaffWorking];
}

final class PutAwaySearchFailure extends PutAwaySearchState {
  final int? errorCode;
  final String message;

  const PutAwaySearchFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
