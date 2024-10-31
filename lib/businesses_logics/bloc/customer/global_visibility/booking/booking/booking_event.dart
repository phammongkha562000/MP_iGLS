part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookingSearch extends BookingEvent {
  final CustomerBookingReq content;
  final String subsidiaryId;

  const BookingSearch({
    required this.content,
    required this.subsidiaryId,
  });
  @override
  List<Object> get props => [content, subsidiaryId];
}
