import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/ware_house/inventory/gr_tracking_response.dart';
import 'package:igls_new/data/repository/ware_house/inventory/inventory_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'barcode_tracking_event.dart';
part 'barcode_tracking_state.dart';

class BarcodeTrackingBloc
    extends Bloc<BarcodeTrackingEvent, BarcodeTrackingState> {
  final _inventoryRepo = getIt<InventoryRepository>();

  BarcodeTrackingBloc() : super(BarcodeTrackingInitial()) {
    on<BarcodeTrackingSearch>(_mapSearchToState);
  }
  Future<void> _mapSearchToState(BarcodeTrackingSearch event, emit) async {
    emit(BarcodeTrackingLoading());
    try {
      final apiTracking = await _inventoryRepo.getGRTracking(
          grNo: event.grNo, subsidiaryId: event.subsidiaryId);
      if (apiTracking.isFailure) {
        emit(BarcodeTrackingFailure(message: apiTracking.getErrorMessage()));
        return;
      }
      emit(BarcodeTrackingSuccess(lstTracking: apiTracking.data));
    } catch (e) {
      emit(BarcodeTrackingFailure(message: e.toString()));
    }
  }
}
