import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_total_res.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inventory_wp/inventory_wp_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'inventory_wp_event.dart';
part 'inventory_wp_state.dart';

class CustomerInventoryWPBloc
    extends Bloc<CustomerInventoryWPEvent, CustomerInventoryWPState> {
  final _customerInventoryRepo = getIt<CustomerInventoryRepository>();

  CustomerInventoryWPBloc() : super(CustomerInventoryWPInitial()) {
    on<CustomerInventoryWPSearch>(_mapSearchToState);
  }

  Future<void> _mapSearchToState(CustomerInventoryWPSearch event, emit) async {
    try {  
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      emit(CustomerInventoryWPLoading());
      final content = event.model;
      if (event.model.isSummary == '1') {
        final api = await _customerInventoryRepo.getInventoryTotal(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (api.isFailure) {
          emit(CustomerInventoryWPFailure(
              message: api.getErrorMessage(), errorCode: api.errorCode));
          return;
        }
        emit(CustomerInventoryWPSuccess(
            lstInventoryTotal: api.data ?? [], lstInventory: const []));
      } else {
        final api = await _customerInventoryRepo.getInventory(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (api.isFailure) {
          emit(CustomerInventoryWPFailure(
              message: api.getErrorMessage(), errorCode: api.errorCode));
          return;
        }
        emit(CustomerInventoryWPSuccess(
            lstInventory: api.data ?? [], lstInventoryTotal: const []));
      }
    } catch (e) {
      emit(CustomerInventoryWPFailure(message: e.toString()));
    }
  }
}
