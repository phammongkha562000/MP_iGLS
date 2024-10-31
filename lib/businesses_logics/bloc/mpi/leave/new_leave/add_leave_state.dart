part of 'add_leave_bloc.dart';

abstract class AddLeaveState extends Equatable {
  const AddLeaveState();

  @override
  List<Object?> get props => [];
}

class AddLeaveInitial extends AddLeaveState {}

class AddLeaveLoading extends AddLeaveState {}

class AddLeaveLoadSuccess extends AddLeaveState {
  final List<MPiStdCode>? listStdCodeHr;
  final List<WorkFlowResponse>? workFlow;

  final DateTime fromDate;
  final DateTime toDate;
  final MPiStdCode? typeLeave;
  final CheckLeaveResponse? leaveResponse;
  final String? pathImg;
  final String phoneNumber;
  final double calDate;
  const AddLeaveLoadSuccess(
      {this.listStdCodeHr,
      this.workFlow,
      required this.fromDate,
      required this.toDate,
      this.typeLeave,
      this.leaveResponse,
      this.pathImg,
      required this.phoneNumber,
      required this.calDate});
  @override
  List<Object?> get props => [
        listStdCodeHr,
        workFlow,
        fromDate,
        toDate,
        typeLeave,
        leaveResponse,
        pathImg,
        phoneNumber,
        calDate,
      ];

  AddLeaveLoadSuccess copyWith({
    List<MPiStdCode>? listStdCodeHr,
    List<WorkFlowResponse>? workFlow,
    DateTime? fromDate,
    DateTime? toDate,
    MPiStdCode? typeLeave,
    SessionType? sessionType,
    CheckLeaveResponse? leaveResponse,
    String? pathImg,
    String? phoneNumber,
    List<SessionType>? sessionTypes,
    double? calDate,
  }) {
    return AddLeaveLoadSuccess(
      listStdCodeHr: listStdCodeHr ?? this.listStdCodeHr,
      workFlow: workFlow ?? this.workFlow,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      typeLeave: typeLeave ?? this.typeLeave,
      leaveResponse: leaveResponse ?? this.leaveResponse,
      pathImg: pathImg ?? this.pathImg,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      calDate: calDate ?? this.calDate,
    );
  }
}

class AddLeaveFailure extends AddLeaveState {
  final String message;
  final int? errorCode;
  const AddLeaveFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class AddLeaveSuccessfully extends AddLeaveState {}
