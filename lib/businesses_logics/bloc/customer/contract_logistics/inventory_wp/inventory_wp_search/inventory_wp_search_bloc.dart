import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inventory_wp/inventory_wp/inventory_wp_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inventory_wp/inventory_wp_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'inventory_wp_search_event.dart';
part 'inventory_wp_search_state.dart';

class InventoryWpSearchBloc
    extends Bloc<InventoryWpSearchEvent, InventoryWpSearchState> {
  final _customerInventoryRepo = getIt<CustomerInventoryRepository>();

  InventoryWpSearchBloc() : super(InventoryWpSearchInitial()) {
    on<InventoryWpSearchViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      InventoryWpSearchViewLoaded event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();

      List<GetStdCodeRes> contactStdGrade =
          event.customerBloc.contactStdGrade ?? [];
      List<GetStdCodeRes> contactStdItemStatus =
          event.customerBloc.contactStdItemStatus ?? [];

      if (contactStdGrade == [] || contactStdItemStatus == []) {
        final apiGrade = await _customerInventoryRepo.getContactStd(
            stdType: constants.customerSTDGrade,
            contactCode: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiGrade.isFailure) {
          emit(CustomerInventoryWPFailure(
              message: apiGrade.getErrorMessage(),
              errorCode: apiGrade.errorCode));
          return;
        }
        contactStdGrade = apiGrade.data;
        event.customerBloc.contactStdGrade = contactStdGrade;
        final apiItemStatus = await _customerInventoryRepo.getContactStd(
            stdType: constants.customerSTDItemsStatus,
            contactCode: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiItemStatus.isFailure) {
          emit(CustomerInventoryWPFailure(
              message: apiItemStatus.getErrorMessage(),
              errorCode: apiItemStatus.errorCode));
          return;
        }
        contactStdItemStatus = apiItemStatus.data;
        event.customerBloc.contactStdItemStatus = contactStdItemStatus;
      }
      List<UserDCResult> lstDC =
          event.customerBloc.cusPermission?.userDCResult ?? [];
      emit(InventoryWpSearchSuccess(
          lstGrade: contactStdGrade,
          lstItemStatus: contactStdItemStatus,
          lstDC: lstDC));
    } catch (e) {
      emit(InventoryWpSearchFailure(message: e.toString()));
    }
  }
}
