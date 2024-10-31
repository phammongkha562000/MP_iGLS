import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_request.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_response.dart';
import 'package:igls_new/data/repository/customer/global_visibility/booking/booking_repository.dart';

import '../../../../../../data/services/injection/injection_igls.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final _bookingRepo = getIt<BookingRepository>();

  BookingBloc() : super(BookingInitial()) {
    on<BookingSearch>(_mapSearchEvent);
  }
  Future<void> _mapSearchEvent(BookingSearch event, emit) async {
    emit(BookingLoading());
    try {
      final content = event.content;
      final api = await _bookingRepo.getBooking(
          subsidiaryId: event.subsidiaryId, content: content);
      if (api.isFailure) {
        emit(BookingFailure(message: api.getErrorMessage()));
        return;
      }
      emit(BookingSuccess(lstBooking: api.data));
    } catch (e) {
      emit(BookingFailure(message: e.toString()));
    }
  }
}
