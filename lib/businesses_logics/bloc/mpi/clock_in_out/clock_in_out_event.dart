part of 'clock_in_out_bloc.dart';

abstract class ClockInOutEvent extends Equatable {
  const ClockInOutEvent();

  @override
  List<Object> get props => [];
}

class ClockInOutViewLoaded extends ClockInOutEvent {}

class ClockInOutUpdate extends ClockInOutEvent {
  final int type;
  const ClockInOutUpdate({
    required this.type,
  });
  @override
  List<Object> get props => [type];
}
