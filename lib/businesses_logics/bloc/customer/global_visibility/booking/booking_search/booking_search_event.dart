part of 'booking_search_bloc.dart';

sealed class BookingSearchEvent extends Equatable {
  const BookingSearchEvent();

  @override
  List<Object> get props => [];
}

class BookingSearchViewLoaded extends BookingSearchEvent {}

class GetUnlocPodEvent extends BookingSearchEvent {
  final String unlocCode;
  const GetUnlocPodEvent({required this.unlocCode});
  @override
  List<Object> get props => [];
}
