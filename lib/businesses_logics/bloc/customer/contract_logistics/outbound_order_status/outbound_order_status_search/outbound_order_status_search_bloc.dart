import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'outbound_order_status_search_event.dart';
part 'outbound_order_status_search_state.dart';

class OutboundOrderStatusSearchBloc extends Bloc<OutboundOrderStatusSearchEvent,
    OutboundOrderStatusSearchState> {
  final _iosRepo = getIt<CustomerIOSRepository>();

  OutboundOrderStatusSearchBloc() : super(OutboundOrderStatusSearchInitial()) {
    on<OutboundOrderStatusSearchViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      OutboundOrderStatusSearchViewLoaded event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();

      List<UserDCResult> lstDC =
          event.customerBloc.cusPermission?.userDCResult ?? [];
      List<GetStdCodeRes> stdOUTBOUNDDATESER =
          event.customerBloc.stdOUTBOUNDDATESER ?? [];
      List<GetStdCodeRes> stdOrdStatus = event.customerBloc.stdOrdStatus ?? [];

      if (stdOUTBOUNDDATESER == [] || stdOrdStatus == []) {
        final apiOutbounddateser = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDOOS,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        final apiOrdStatus = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDOOSStatus,
            subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiOutbounddateser.isFailure) {
          emit(OutboundOrderStatusSearchFailure(
              message: apiOutbounddateser.getErrorMessage(),
              errorCode: apiOutbounddateser.errorCode));
          return;
        }
        if (apiOrdStatus.isFailure) {
          emit(OutboundOrderStatusSearchFailure(
              message: apiOrdStatus.getErrorMessage(),
              errorCode: apiOrdStatus.errorCode));
          return;
        }
        stdOUTBOUNDDATESER = apiOutbounddateser.data;
        event.customerBloc.stdOUTBOUNDDATESER = apiOutbounddateser.data;
        log('GetStdCodeRes outbound 2');
        stdOrdStatus = apiOrdStatus.data;
        event.customerBloc.stdOrdStatus = apiOrdStatus.data;
        log('GetStdCodeRes stdOrdStatus 2');
      }

      emit(OutboundOrderStatusSearchSuccess(
          lstOutboundDateser: stdOUTBOUNDDATESER,
          lstOrdStatus: stdOrdStatus,
          lstDC: lstDC));
    } catch (e) {
      emit(OutboundOrderStatusSearchFailure(message: e.toString()));
    }
  }
}
