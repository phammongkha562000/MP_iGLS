import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_notify_order_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_notify_order_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_save_notify_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_detail_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_detail_res.dart';
import 'package:igls_new/data/models/freight_fowarding/freight_fowarding.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/transport_order_status/transport_order_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../../data/models/login/user.dart';

part 'transport_order_status_detail_event.dart';
part 'transport_order_status_detail_state.dart';

class CustomerTOSDetailBloc
    extends Bloc<CustomerTOSDetailEvent, CustomerTOSDetailState> {
  final _tosRepo = getIt<CustomerTOSRepository>();
  final _iosRepo = getIt<CustomerIOSRepository>();
  CustomerTOSDetailBloc() : super(CustomerTOSDetailInitial()) {
    on<CustomerTOSDetailViewLoaded>(_mapViewLoadedToState);
    on<CustomerTOSDetailSaveNotify>(_mapSaveNotifyToState);
    on<CustomerTOSDetailDeleteNotify>(_mapDeleteNotifyToState);
  }
  Future<void> _mapViewLoadedToState(
      CustomerTOSDetailViewLoaded event, emit) async {
    emit(CustomerTOSDetailLoading());
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      final content = CustomerTOSDetailReq(
          contactCode: userInfo.defaultClient ?? '',
          deliveryMode: event.deliveryMode,
          orderId: event.orderId,
          tripNo: event.tripNo);
      final contentNotifyOrder =
          CustomerNotifyOrderReq(orderId: event.orderId, tripNo: event.tripNo);
          //hardcode Future.wait
      final results = await Future.wait([
        _tosRepo.getTOSDetail(
            content: content,
            subsidiaryId: userInfo.subsidiaryId ?? '',
            contactCode: userInfo.defaultClient ?? ''),
        _tosRepo.getNotifyOrder(
            content: contentNotifyOrder,
            subsidiaryId: userInfo.subsidiaryId ?? ''),
        _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDNotify,
            subsidiaryId: userInfo.subsidiaryId ?? ''),
      ]);
      ApiResult apiDetail = results[0];
      if (apiDetail.isFailure) {
        emit(CustomerTOSDetailFailure(
            message: apiDetail.getErrorMessage(),
            errorCode: apiDetail.errorCode));
        return;
      }
      ApiResult apiNotifyOrder = results[1];
      if (apiNotifyOrder.isFailure) {
        emit(CustomerTOSDetailFailure(
            message: apiNotifyOrder.getErrorMessage(),
            errorCode: apiNotifyOrder.errorCode));
        return;
      }

      ApiResult apiStdNotify = results[2];
      if (apiStdNotify.isFailure) {
        emit(CustomerTOSDetailFailure(
            message: apiStdNotify.getErrorMessage(),
            errorCode: apiStdNotify.errorCode));
        return;
      }
      emit(CustomerTOSDetailSuccess(
          detail: apiDetail.data,
          notifyOrder: apiNotifyOrder.data,
          lstStdNotify: apiStdNotify.data));
    } catch (e) {
      emit(CustomerTOSDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveNotifyToState(
      CustomerTOSDetailSaveNotify event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      final content = CustomerSaveNotifyReq(
          messageType: event.messageType,
          notes: event.notes,
          orderId: event.orderId,
          receiver: event.receiver,
          tripNo: event.tripNo,
          userId: userInfo.userId ?? '');
      final api = await _tosRepo.saveNotifyOrder(
          content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (api.isFailure) {
        emit(CustomerTOSDetailFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      StatusResponse statusResponse = api.data;
      if (statusResponse.isSuccess != true) {
        emit(CustomerTOSDetailFailure(message: statusResponse.message));
        return;
      }
      emit(CustomerTOSDetailSaveNotifySuccess());
    } catch (e) {
      emit(CustomerTOSDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteNotifyToState(
      CustomerTOSDetailDeleteNotify event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      final apiDelete = await _tosRepo.deleteNotifyOrder(
          tripNo: event.tripNo,
          orderId: event.orderId,
          userId: userInfo.userId ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiDelete.isFailure) {
        emit(CustomerTOSDetailFailure(
            message: apiDelete.getErrorMessage(),
            errorCode: apiDelete.errorCode));
        return;
      }
      StatusResponse statusResponse = apiDelete.data;
      if (statusResponse.isSuccess == false) {
        emit(CustomerTOSDetailFailure(message: statusResponse.message));
        return;
      }
      emit(CustomerTOSDetailSaveNotifySuccess());
    } catch (e) {
      emit(CustomerTOSDetailFailure(message: e.toString()));
    }
  }
}
