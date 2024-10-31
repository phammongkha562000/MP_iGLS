import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';

import '../../../../../../data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import '../../../../../../data/models/customer/global_visibility/cntr_haulage/get_detail_cntr_haulage_res.dart';
import '../../../../../../data/models/customer/global_visibility/cntr_haulage/get_notify_cntr_res.dart';
import '../../../../../../data/models/customer/global_visibility/cntr_haulage/save_notify_setting_req.dart';
import '../../../../../../data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import '../../../../../../data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import '../../../../../../data/repository/customer/global_visibility/cntr_haulage/cntr_haulage_repository.dart';
import '../../../../../../data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'cntr_haulage_detail_event.dart';
part 'cntr_haulage_detail_state.dart';

class CntrHaulageDetailBloc
    extends Bloc<CntrHaulageDetailEvent, CntrHaulageDetailState> {
  CntrHaulageDetailBloc() : super(CntrHaulageDetailInitial()) {
    on<DetailCntrHauLageLoad>(_detailCntrHauLageLoad);
    on<GetStdCodeNotify>(_getStdCodeNotify);
    on<SaveNotifySettingEvent>(_saveNotifySetting);
    on<DelNotifySettingEvent>(_delNotifySetting);
  }
  final _cntrHaulageRepo = getIt<CntrHaulageRepository>();
  final _iosRepo = getIt<CustomerIOSRepository>();

  Future<void> _detailCntrHauLageLoad(DetailCntrHauLageLoad event, emit) async {
    try {
      emit(DetailShowLoadingState());
      final detailHaulageReuslt = await _cntrHaulageRepo.getDetailCntrHaulage(
          woNo: event.woNo,
          woItemNo: event.woItemNo,
          subsidiaryId: event.subsidiaryId);
      final getNotifyReuslt = await _cntrHaulageRepo.getNotifyCntr(
          woNo: event.woNo,
          woItemNo: event.woItemNo,
          subsidiaryId: event.subsidiaryId);

      if (detailHaulageReuslt.isFailure) {
        emit(DetailCntrHaulageLoadFail(
            message: detailHaulageReuslt.getErrorMessage()));
        return;
      }
      if (getNotifyReuslt.isFailure) {
        emit(DetailCntrHaulageLoadFail(
            message: detailHaulageReuslt.getErrorMessage()));
        return;
      }
      emit(DetailCntrHaulageLoadSuccess(
          email: getNotifyReuslt.data?.receiver ?? '',
          lstWOCDetail:
              detailHaulageReuslt.data?.getWOCNTRManifestsResult?.wOCDetail ??
                  [],
          notifyRes: getNotifyReuslt.data ?? GetNotifyCntrRes()));
    } catch (e) {
      emit(DetailCntrHaulageLoadFail(message: e.toString()));
    }
  }

  Future<void> _getStdCodeNotify(GetStdCodeNotify event, emit) async {
    try {
      emit(DetailShowLoadingState());
      var result = await _iosRepo.getStdCode(
          stdCodeType: constants.customerSTDNotify,
          subsidiaryId: event.subsidiaryId);
      if (result.isFailure) {
        emit(GetStdCodeFail(message: result.getErrorMessage()));
        return;
      }
      emit(GetStdCodeSuccess(stdCodeRes: result.data));
    } catch (e) {
      emit(GetStdCodeFail(message: e.toString()));
    }
  }

  Future<void> _saveNotifySetting(SaveNotifySettingEvent event, emit) async {
    try {
      emit(DetailShowLoadingState());
      var result = await _cntrHaulageRepo.saveNotifySetting(
          model: event.model, subsidiaryId: event.subsidiaryId);
      StatusResponse statusResponse = result.data;

      if (result.isFailure) {
        emit(UpdateNotifySettingFail(message: result.getErrorMessage()));
        return;
      }
      if (statusResponse.isSuccess != true) {
        emit(UpdateNotifySettingFail(message: result.getErrorMessage()));
        return;
      }
      emit(UpdateNotifySettingSuccess());
    } catch (e) {
      emit(UpdateNotifySettingFail(message: e.toString()));
    }
  }

  Future<void> _delNotifySetting(DelNotifySettingEvent event, emit) async {
    try {
      emit(DetailShowLoadingState());
      var result = await _cntrHaulageRepo.delNotifySetting(
          woNo: event.woNo,
          itemNo: event.itemNo,
          userId: event.userId,
          subsidiaryId: event.subsidiaryId);
      StatusResponse statusResponse = result.data;

      if (result.isFailure) {
        emit(UpdateNotifySettingFail(message: result.getErrorMessage()));
        return;
      }
      if (statusResponse.isSuccess != true) {
        emit(UpdateNotifySettingFail(message: result.getErrorMessage()));
        return;
      }
      emit(UpdateNotifySettingSuccess());
    } catch (e) {
      emit(UpdateNotifySettingFail(message: e.toString()));
    }
  }
}
