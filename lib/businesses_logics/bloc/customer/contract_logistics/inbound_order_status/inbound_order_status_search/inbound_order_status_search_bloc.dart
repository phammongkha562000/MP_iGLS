import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'inbound_order_status_search_event.dart';
part 'inbound_order_status_search_state.dart';

class InboundOrderStatusSearchBloc
    extends Bloc<InboundOrderStatusSearchEvent, InboundOrderStatusSearchState> {
  final _iosRepo = getIt<CustomerIOSRepository>();

  InboundOrderStatusSearchBloc() : super(InboundOrderStatusSearchInitial()) {
    on<InboundOrderStatusSearchViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      InboundOrderStatusSearchViewLoaded event, emit) async {
    try {
      emit(InboundOrderStatusSearchLoading());
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();

      List<GetStdCodeRes> stdIOS = event.customerBloc.stdInboundDateSer ?? [];
      List<GetStdCodeRes> stdStatus = event.customerBloc.stdOrdStatus ?? [];

      if (stdIOS == [] || stdStatus == []) {
        final resultCodeInbound = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDIOS,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        final resultOrdStatus = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDOOSStatus,
            subsidiaryId: userInfo.subsidiaryId ?? '');

        if (resultCodeInbound.isFailure) {
          emit(InboundOrderStatusSearchFailure(
            message: resultCodeInbound.getErrorMessage(),
          ));
          return;
        }
        stdIOS = resultCodeInbound.data;
        event.customerBloc.stdInboundDateSer = stdIOS;
        if (resultOrdStatus.isFailure) {
          emit(InboundOrderStatusSearchFailure(
            message: resultOrdStatus.getErrorMessage(),
          ));
          return;
        }
        stdStatus = resultOrdStatus.data;
        event.customerBloc.stdOrdStatus = stdStatus;
      }
      List<UserDCResult> lstDC =
          event.customerBloc.cusPermission?.userDCResult ?? [];
      emit(InboundOrderStatusSearchSuccess(
          lstInboundDateser: stdIOS,
          lstOrdStatus: [GetStdCodeRes(), ...stdStatus],
          lstDC: lstDC));
    } catch (e) {
      emit(InboundOrderStatusSearchFailure(message: e.toString()));
    }
  }
}
