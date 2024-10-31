
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_res.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/outbound_order_status/outbound_order_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'outbound_order_status_event.dart';
part 'outbound_order_status_state.dart';

class CustomerOOSBloc extends Bloc<CustomerOOSEvent, CustomerOOSState> {
  final _oosRepo = getIt<CustomerOOSRepository>();
  CustomerOOSBloc() : super(CustomerOOSInitial()) {
    on<CustomerOOSSearch>(_mapSearchToState);
  }
  
  Future<void> _mapSearchToState(CustomerOOSSearch event, emit) async {
    try {
      emit(CustomerOOSLoading());

      final content = event.model;
      final api = await _oosRepo.getOOS(
          content: content, subsidiaryId: event.subsidiaryId);
      if (api.isFailure) {
        emit(CustomerOOSFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      List<CustomerOOSRes> oosList = api.data;

      emit(CustomerOOSSuccess(oosList: oosList));
    } catch (e) {
      emit(CustomerOOSFailure(message: e.toString()));
    }
  }
}
