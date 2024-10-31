part of 'staffs_bloc.dart';

abstract class StaffsState extends Equatable {
  const StaffsState();

  @override
  List<Object?> get props => [];
}

class StaffsInitial extends StaffsState {}

class StaffsLoading extends StaffsState {}

class StaffsSuccess extends StaffsState {
  final List<StaffsResponse> staffList;
  final List<StaffsResponse> staffListSearch;
  final List<DcLocal> dcList;
  final List<StdCode> roleTypeList;
  final String staffNameSearch;
  final String staffIDSearch;
  final StdCode roleTypeSearch;
  final DcLocal dcLocalSearch;
  final bool isDeleted;

  const StaffsSuccess(
      {required this.staffList,
      required this.staffListSearch,
      required this.dcList,
      required this.roleTypeList,
      required this.staffNameSearch,
      required this.staffIDSearch,
      required this.roleTypeSearch,
      required this.dcLocalSearch,
      required this.isDeleted});
  @override
  List<Object?> get props => [
        staffList,
        staffListSearch,
        dcList,
        roleTypeList,
        staffNameSearch,
        staffIDSearch,
        roleTypeSearch,
        dcLocalSearch,
      ];

  StaffsSuccess copyWith(
      {List<StaffsResponse>? staffList,
      List<StaffsResponse>? staffListSearch,
      List<DcLocal>? dcList,
      List<StdCode>? roleTypeList,
      String? staffNameSearch,
      String? staffIDSearch,
      StdCode? roleTypeSearch,
      DcLocal? dcLocalSearch,
      String? phoneNoSearch,
      bool? isDeleted}) {
    return StaffsSuccess(
        staffList: staffList ?? this.staffList,
        staffListSearch: staffListSearch ?? this.staffListSearch,
        dcList: dcList ?? this.dcList,
        roleTypeList: roleTypeList ?? this.roleTypeList,
        staffNameSearch: staffNameSearch ?? this.staffNameSearch,
        staffIDSearch: staffIDSearch ?? this.staffIDSearch,
        roleTypeSearch: roleTypeSearch ?? this.roleTypeSearch,
        dcLocalSearch: dcLocalSearch ?? this.dcLocalSearch,
        isDeleted: isDeleted ?? this.isDeleted);
  }
}

class StaffsFailure extends StaffsState {
  final String message;
  final int? errorCode;
  const StaffsFailure({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
