import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status/transport_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../../data/models/models.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../../data/repository/repository.dart';

part 'transport_order_status_search_event.dart';
part 'transport_order_status_search_state.dart';

class CustomerTOSSearchBloc
    extends Bloc<CustomerTOSSearchEvent, CustomerTOSSearchState> {
  final _iosRepo = getIt<CustomerIOSRepository>();
  final _tosRepo = getIt<CustomerTOSRepository>();

  CustomerTOSSearchBloc() : super(CustomerTOSSearchInitial()) {
    on<CustomerTOSSearchViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      CustomerTOSSearchViewLoaded event, emit) async {
    emit(CustomerTOSSearchLoading());
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      List<GetStdCodeRes> stdOrdStatus = event.customerBloc.stdOrdStatus ?? [];
      List<CustomerCompanyRes> companyLst = event.customerBloc.companyLst ?? [];

      if (stdOrdStatus == [] || companyLst == []) {
        final content = CustomerCompanyReq(
            companyCode: '',
            companyName: '',
            companyType: '',
            contactCode: userInfo.defaultClient ?? '');
        final api = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDOOSStatus,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (api.isFailure) {
          emit(CustomerTOSSearchFailure(
              message: api.getErrorMessage(), errorCode: api.errorCode));
          return;
        }
        stdOrdStatus = api.data;
        event.customerBloc.stdOrdStatus = stdOrdStatus;

        final apiCompany = await _tosRepo.getCompany(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiCompany.isFailure) {
          emit(CustomerTOSSearchFailure(
              message: apiCompany.getErrorMessage(),
              errorCode: apiCompany.errorCode));
          return;
        }
        companyLst = apiCompany.data;
        event.customerBloc.companyLst = apiCompany.data;
      }

      emit(CustomerTOSSearchSuccess(
        lstCompany: [CustomerCompanyRes(companyCode: ''), ...companyLst],
        lstOrderStatus: [GetStdCodeRes(), ...stdOrdStatus],
      ));
    } catch (e) {
      emit(CustomerTOSFailure(message: e.toString()));
    }
  }
}
