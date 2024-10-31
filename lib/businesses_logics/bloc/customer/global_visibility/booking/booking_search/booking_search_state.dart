part of 'booking_search_bloc.dart';

sealed class BookingSearchState extends Equatable {
  const BookingSearchState();

  @override
  List<Object?> get props => [];
}

final class BookingSearchInitial extends BookingSearchState {}

final class BookingSearchLoading extends BookingSearchState {}

final class BookingSearchSuccess extends BookingSearchState {}

final class BookingSearchFailure extends BookingSearchState {
  final int? errorCode;
  final String message;

  const BookingSearchFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

final class GetUnlocPodSuccess extends BookingSearchState {
  final List<GetUnlocResult> lstUnloc;
  const GetUnlocPodSuccess({required this.lstUnloc});
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class GetUnlocFail extends BookingSearchState {
  final String message;
  const GetUnlocFail({required this.message});
  @override
  List<Object> get props => [];
}
