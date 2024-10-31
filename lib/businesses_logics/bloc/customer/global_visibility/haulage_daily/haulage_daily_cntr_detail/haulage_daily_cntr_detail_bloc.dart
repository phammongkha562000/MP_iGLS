import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_detail_cntr_haulage_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_notify_cntr_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/save_notify_setting_req.dart';
import 'package:igls_new/data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';

import '../../../../../../data/repository/customer/global_visibility/cntr_haulage/cntr_haulage_repository.dart';
import '../../../../../../data/services/services.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'haulage_daily_cntr_detail_event.dart';
part 'haulage_daily_cntr_detail_state.dart';

class HaulageDailyCntrDetailBloc
    extends Bloc<HaulageDailyCntrDetailEvent, HaulageDailyCntrDetailState> {
  final _cntrHaulageRepo = getIt<CntrHaulageRepository>();
  final _iosRepo = getIt<CustomerIOSRepository>();

  HaulageDailyCntrDetailBloc() : super(HaulageDailyCntrDetailInitial()) {
    on<HaulageDailyCntrDetailViewLoaded>(_mapViewLoadedToState);
    on<HaulageDailyCntrDetailSaveNotify>(_mapSaveNotifyToState);
    on<HaulageDailyCntrDetailDeleteNotify>(_mapDeleteNotifyToState);
  }
  Future<void> _mapViewLoadedToState(
      HaulageDailyCntrDetailViewLoaded event, emit) async {
    emit(HaulageDailyCntrDetailLoading());
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();

      List<GetStdCodeRes> stdNotify = event.customerBloc.stdNotify ?? [];
      if (stdNotify.isEmpty) {
        final apiStdNotify = await _iosRepo.getStdCode(
            stdCodeType: constants.customerSTDNotify,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdNotify.isFailure) {
          emit(HaulageDailyCntrDetailFailure(
              message: apiStdNotify.getErrorMessage(),
              errorCode: apiStdNotify.errorCode));
          return;
        }
        stdNotify = apiStdNotify.data ?? [];
        event.customerBloc.stdNotify = apiStdNotify.data ?? [];
      }

      final apiDetailCNTR = await _cntrHaulageRepo.getDetailCntrHaulage(
          woNo: event.woNo,
          woItemNo: event.woItemNo,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      final apiNotifyCNTR = await _cntrHaulageRepo.getNotifyCntr(
          woNo: event.woNo,
          woItemNo: event.woItemNo,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiDetailCNTR.isFailure) {
        emit(HaulageDailyCntrDetailFailure(
            message: apiDetailCNTR.getErrorMessage(),
            errorCode: apiDetailCNTR.errorCode));
        return;
      }
      GetDetailCntrHaulageRes detailCNTR =
          apiDetailCNTR.data ?? GetDetailCntrHaulageRes();

      if (apiNotifyCNTR.isFailure) {
        emit(HaulageDailyCntrDetailFailure(
            message: apiNotifyCNTR.getErrorMessage(),
            errorCode: apiNotifyCNTR.errorCode));
        return;
      }
      GetNotifyCntrRes notifyRes = apiNotifyCNTR.data ?? GetNotifyCntrRes();

      emit(HaulageDailyCntrDetailSuccess(
          detailCNTR: detailCNTR,
          notifyRes: notifyRes,
          lstStdNotify: stdNotify));
    } catch (e) {
      emit(HaulageDailyCntrDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveNotifyToState(
      HaulageDailyCntrDetailSaveNotify event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      final content = SaveNotifySettingReq(
          messageType: event.messageType,
          notes: event.notes,
          itemNo: event.itemNo,
          receiver: event.receiver,
          wONo: event.woNo,
          userId: userInfo.userId ?? '');
      final api = await _cntrHaulageRepo.saveNotifySetting(
          model: content, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (api.isFailure) {
        emit(HaulageDailyCntrDetailFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      StatusResponse statusResponse = api.data;
      if (statusResponse.isSuccess != true) {
        emit(HaulageDailyCntrDetailFailure(message: statusResponse.message));
        return;
      }
      emit(HaulageDailyCntrDetailSaveNotifySuccess());
    } catch (e) {
      emit(HaulageDailyCntrDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteNotifyToState(
      HaulageDailyCntrDetailDeleteNotify event, emit) async {
    try {
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      final apiDelete = await _cntrHaulageRepo.delNotifySetting(
          woNo: event.woNo,
          itemNo: event.itemNo,
          userId: userInfo.userId ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiDelete.isFailure) {
        emit(HaulageDailyCntrDetailFailure(
            message: apiDelete.getErrorMessage(),
            errorCode: apiDelete.errorCode));
        return;
      }
      StatusResponse statusResponse = apiDelete.data;
      if (statusResponse.isSuccess == false) {
        emit(HaulageDailyCntrDetailFailure(message: statusResponse.message));
        return;
      }
      emit(HaulageDailyCntrDetailSaveNotifySuccess());
    } catch (e) {
      emit(HaulageDailyCntrDetailFailure(message: e.toString()));
    }
  }
}
