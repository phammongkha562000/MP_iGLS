part of 'add_put_away_bloc.dart';

sealed class AddPutAwayEvent extends Equatable {
  const AddPutAwayEvent();

  @override
  List<Object> get props => [];
}

class SeachPutAwayItem extends AddPutAwayEvent {
  final GeneralBloc generalBloc;
  final String grNo;

  const SeachPutAwayItem({required this.grNo, required this.generalBloc});
  @override
  List<Object> get props => [grNo, generalBloc];
}

class SavePutAway extends AddPutAwayEvent {
  final double pwQty;
  final String locCode;
  final String grNo;
  final String userId;
  final String subsidiaryId;
  const SavePutAway(
      {required this.pwQty,
      required this.locCode,
      required this.grNo,
      required this.userId,
      required this.subsidiaryId});
  @override
  List<Object> get props => [pwQty, grNo, locCode, userId, subsidiaryId];
}
