part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingSuccess extends BookingState {
  final List<CustomerBookingRes> lstBooking;

  const BookingSuccess({required this.lstBooking});
  @override
  List<Object> get props => [lstBooking];
}

final class BookingFailure extends BookingState {
  final int? errorCode;
  final String message;

  const BookingFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
