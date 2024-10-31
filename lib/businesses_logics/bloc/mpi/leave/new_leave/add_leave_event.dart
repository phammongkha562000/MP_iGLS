part of 'add_leave_bloc.dart';

abstract class AddLeaveEvent extends Equatable {
  const AddLeaveEvent();

  @override
  List<Object?> get props => [];
}

class AddLeaveLoaded extends AddLeaveEvent {}

class AddLeaveChangeFromDate extends AddLeaveEvent {
  final String divisionCode;

  final DateTime fromDate;

  const AddLeaveChangeFromDate({
    required this.divisionCode,
    required this.fromDate,
  });
  @override
  List<Object?> get props => [fromDate, divisionCode];
}

class AddLeaveChangeToDate extends AddLeaveEvent {
  final String divisionCode;
  final DateTime toDate;

  const AddLeaveChangeToDate({
    required this.divisionCode,
    required this.toDate,
  });
  @override
  List<Object?> get props => [toDate, divisionCode];
}

class AddLeaveChangeTypeLeave extends AddLeaveEvent {
  final MPiStdCode typeLeave;
  const AddLeaveChangeTypeLeave({
    required this.typeLeave,
  });
  @override
  List<Object?> get props => [typeLeave];
}

class AddLeaveUploadImage extends AddLeaveEvent {
  final String pathImg;
  const AddLeaveUploadImage({
    required this.pathImg,
  });
  @override
  List<Object?> get props => [pathImg];
}

class AddLeaveSubmit extends AddLeaveEvent {
  final String remark;

  const AddLeaveSubmit({required this.remark});
  @override
  List<Object?> get props => [remark];
}
