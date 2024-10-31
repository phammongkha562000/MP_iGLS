import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_req.dart';
import '../../../../../../data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_res.dart';
import '../../../../../../data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import '../../../../../../data/models/customer/home/customer_permission_res.dart';
import '../../../../../../data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import '../../../../../../data/services/injection/injection_igls.dart';
import '../../../customer_bloc/customer_bloc.dart';

part 'inbound_order_status_event.dart';
part 'inbound_order_status_state.dart';

class CustomerIOSBloc extends Bloc<CustomerIOSEvent, CustomerIOSState> {
  CustomerIOSBloc() : super(CustomerIOSInitial()) {
    on<CustomerGetInboundOrder>(_getInboundOrder);
  }
  final _iosRepo = getIt<CustomerIOSRepository>();

  

  Future<void> _getInboundOrder(CustomerGetInboundOrder event, emit) async {
    try {
      emit(IOSShowLoadingState());
      var resutl = await _iosRepo.getInboundOrder(
          model: event.model, subsidiaryId: event.subsidiaryId);
      if (resutl.isFailure) {
        emit(GetInboundOrderFail(message: resutl.getErrorMessage()));
        return;
      }
      emit(GetInboundOrderSuccess(lstInboundOrder: resutl.data));
    } catch (e) {
      emit(GetInboundOrderFail(message: e.toString()));
    }
  }
}
