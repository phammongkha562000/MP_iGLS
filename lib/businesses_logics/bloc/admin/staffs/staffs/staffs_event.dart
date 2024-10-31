part of 'staffs_bloc.dart';

abstract class StaffsEvent extends Equatable {
  const StaffsEvent();

  @override
  List<Object?> get props => [];
}

class StaffsViewLoaded extends StaffsEvent {
  final GeneralBloc generalBloc;
  const StaffsViewLoaded({required this.generalBloc});
  @override
  List<Object> get props => [generalBloc];
}

class StaffsSearch extends StaffsEvent {
  final String staffID;
  final String staffName;
  final StdCode? roleType;
  final DcLocal? dcCode;
  final bool isDeleted;
  final GeneralBloc generalBloc;

  const StaffsSearch(
      {required this.staffID,
      required this.staffName,
      this.roleType,
      this.dcCode,
      required this.generalBloc,
      required this.isDeleted});

  @override
  List<Object?> get props =>
      [staffID, staffName, roleType, dcCode, isDeleted, isDeleted, generalBloc];
}

class StaffsQuickSearch extends StaffsEvent {
  final String textSearch;
  const StaffsQuickSearch({required this.textSearch});
  @override
  List<Object?> get props => [textSearch];
}
