import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/global/global.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_detail_res.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../../data/models/models.dart';
import '../../../../../../data/repository/customer/contract_logistics/outbound_order_status/outbound_order_status_repository.dart';

part 'outbound_order_status_detail_event.dart';
part 'outbound_order_status_detail_state.dart';

class CustomerOOSDetailBloc
    extends Bloc<CustomerOOSDetailEvent, CustomerOOSDetailState> {
  final _oosRepo = getIt<CustomerOOSRepository>();

  CustomerOOSDetailBloc() : super(CustomerOOSDetailInitial()) {
    on<CustomerOOSDetailViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      CustomerOOSDetailViewLoaded event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      log(globalApp.token ?? '');
      final api = await _oosRepo.getOOSDetail(
          orderid: event.orderId, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (api.isFailure) {
        emit(CustomerOOSDetailFailure(message: api.getErrorMessage()));
        return;
      }
      emit(CustomerOOSDetailSuccess(detail: api.data));
    } catch (e) {
      emit(CustomerOOSDetailFailure(message: e.toString()));
    }
  }
}
