part of 'leave_detail_bloc.dart';

abstract class LeaveDetailEvent extends Equatable {
  const LeaveDetailEvent();

  @override
  List<Object?> get props => [];
}

class LeaveDetailLoaded extends LeaveDetailEvent {
  final String lvNo;
  final String empCode;
  const LeaveDetailLoaded({
    required this.lvNo,
    required this.empCode,
  });
  @override
  List<Object> get props => [lvNo, empCode];
}
