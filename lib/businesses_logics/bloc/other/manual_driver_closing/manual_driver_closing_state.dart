part of 'manual_driver_closing_bloc.dart';

abstract class ManualDriverClosingState extends Equatable {
  const ManualDriverClosingState();

  @override
  List<Object?> get props => [];
}

class ManualDriverClosingInitial extends ManualDriverClosingState {}

class ManualDriverClosingLoading extends ManualDriverClosingState {}

class ManualDriverClosingSuccess extends ManualDriverClosingState {
  // final List<ContactLocal>? localList;
  // final bool? isSuccess;
  final DateTime? date;
  // final DriverDailyClosingDetailResponse? detail;
  const ManualDriverClosingSuccess({
    // this.localList,
    this.date,
    // this.detail,
    /* this.isSuccess */
  });
  @override
  List<Object?> get props => [
        // localList,
        date,
        // detail, /*  isSuccess */
      ];

  ManualDriverClosingSuccess copyWith(
      {List<ContactLocal>? localList,
      DateTime? date,
      /* bool? isSuccess, */
      DriverDailyClosingDetailResponse? detail}) {
    return ManualDriverClosingSuccess(
      // localList: localList ?? this.localList,
      date: date ?? this.date,
      /* isSuccess: isSuccess ?? this.isSuccess, */
      /*  detail: detail ?? this.detail */
    );
  }
}

class ManualDriverClosingFailure extends ManualDriverClosingState {
  final String message;
  final int? errorCode;
  const ManualDriverClosingFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class ManualDriverClosingSaveSuccess extends ManualDriverClosingState {}
