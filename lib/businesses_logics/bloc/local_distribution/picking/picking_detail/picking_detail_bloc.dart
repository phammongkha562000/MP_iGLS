import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_item_response.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_search_request.dart';
import 'package:igls_new/data/models/ware_house/picking/save_picking_item_request.dart';
import 'package:igls_new/data/repository/ware_house/picking/picking_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';

part 'picking_detail_event.dart';
part 'picking_detail_state.dart';

class PickingDetailBloc extends Bloc<PickingDetailEvent, PickingDetailState> {
  final _pickingRepo = getIt<PickingRepository>();

  PickingDetailBloc() : super(PickingDetailInitial()) {
    on<PickingDetailCheckGrNo>(_mapCheckGRNoToState);
    on<PickingDetailSave>(_mapSaveToState);
    on<PickingSearch>(_mapSearchWaveNoToState);
  }
  Future<void> _mapCheckGRNoToState(PickingDetailCheckGrNo event, emit) async {
    emit(PickingDetailLoading());
    try {
      final apiCheckGR = await _pickingRepo.getFinalGRNo(
          grNo: event.grNo, subsidiaryId: event.subsidiaryId);
      if (apiCheckGR.isFailure) {
        emit(PickingDetailFailure(message: apiCheckGR.getErrorMessage()));
      }
      emit(PickingDetailCheckGRSuccess(grNoResult: apiCheckGR.data));
    } catch (e) {
      emit(PickingDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(PickingDetailSave event, emit) async {
    emit(PickingDetailLoading());

    try {
      final content = PickingItemRequest(
          sBNo: event.sbNo,
          sRItemNo: event.srItemNo,
          qty: event.qty,
          oOrdNo: event.oOrderNo,
          waveItemNo: event.waveItemNo,
          pickDate: FileUtils.formatToStringFromDatetime(DateTime.now()),
          createUser: event.generalBloc.generalUserInfo?.userId ?? '',
          doneByStaff: event.generalBloc.generalUserInfo?.userId ?? '',
          waveNo: event.waveNo,
          companyId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');
      final apiSave = await _pickingRepo.savePicking(content: content);
      if (apiSave.isFailure) {
        emit(PickingDetailFailure(message: apiSave.getErrorMessage()));
        return;
      }
      emit(PickingDetailSaveSuccess(remaining: event.qty));
    } catch (e) {
      emit(PickingDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchWaveNoToState(PickingSearch event, emit) async {
    emit(PickingDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final content = PickingSearchRequest(
          contactCode: userInfo.defaultClient ?? '',
          dcCode: userInfo.defaultCenter ?? '',
          companyId: userInfo.subsidiaryId ?? '',
          searchType: 'WAVE',
          searchValue: event.waveNo);
      final apiSearch = await _pickingRepo.getPickingItem(content: content);
      if (apiSearch.isFailure) {
        emit(PickingDetailFailure(message: apiSearch.getErrorMessage()));
        return;
      }
      List<PickingItemResponse> lstPickingItem = apiSearch.data;
      PickingItemResponse pickingItem =
          lstPickingItem.where((element) => element.waveNo == event.waveNo && element.waveItemNo == event.waveItemNo).single;
      emit(PickingDetailSuccess(pickingItem: pickingItem));
    } catch (e) {
      emit(PickingDetailFailure(message: e.toString()));
    }
  }
}
