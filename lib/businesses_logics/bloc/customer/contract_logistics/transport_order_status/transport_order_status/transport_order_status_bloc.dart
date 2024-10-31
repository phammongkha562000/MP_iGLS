import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_res.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/transport_order_status/transport_order_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../../data/models/models.dart';

part 'transport_order_status_event.dart';
part 'transport_order_status_state.dart';

class CustomerTOSBloc extends Bloc<CustomerTOSEvent, CustomerTOSState> {
  final _tosRepo = getIt<CustomerTOSRepository>();

  CustomerTOSBloc() : super(CustomerTOSInitial()) {
    on<CustomerTOSViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(CustomerTOSViewLoaded event, emit) async {
    emit(CustomerTOSLoading());
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();

      final apiTOS = await _tosRepo.getTOS(
          content: event.content, subsidiaryId: userInfo.subsidiaryId ?? '');

      if (apiTOS.isFailure) {
        emit(CustomerTOSFailure(
            message: apiTOS.getErrorMessage(), errorCode: apiTOS.errorCode));
        return;
      }
      emit(CustomerTOSSuccess(
        lstTOS: apiTOS.data ?? [],
      ));
    } catch (e) {
      emit(CustomerTOSFailure(message: e.toString()));
    }
  }
}
