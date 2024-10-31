import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/models/ware_house/put_away/put_away_item_request.dart';
import 'package:igls_new/data/models/ware_house/put_away/save_put_item_request.dart';
import 'package:igls_new/data/repository/ware_house/put_away/put_away_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_item_response.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';

part 'add_put_away_event.dart';
part 'add_put_away_state.dart';

class AddPutAwayBloc extends Bloc<AddPutAwayEvent, AddPutAwayState> {
  final _putAwayRepo = getIt<PutAwayRepository>();

  AddPutAwayBloc() : super(AddPutAwayInitial()) {
    on<SeachPutAwayItem>(_mapSearchItemToState);
    on<SavePutAway>(_mapSaveToState);
  }
  Future<void> _mapSearchItemToState(SeachPutAwayItem event, emit) async {
    emit(AddPutAwayLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final content = PutAwayItemRequest(
          orderNo: '',
          grdf: FileUtils.formatToStringFromDatetime(DateTime.now()),
          grdt: FileUtils.formatToStringFromDatetime(DateTime.now()),
          grNo: event.grNo,
          orderType: '',
          assignedStaff: '',
          contactCode: userInfo.defaultClient ?? '',
          dcCode: userInfo.defaultCenter ?? '',
          companyId: userInfo.subsidiaryId ?? '',
          pageNumber: 0,
          pageSize: 1);
      final apiSearch = await _putAwayRepo.getOrders(content: content);
      if (apiSearch.isFailure) {
        emit(AddPutAwayFailure(message: apiSearch.getErrorMessage()));
        return;
      }
      OrderForPwResponse res = apiSearch.data;
      if (res.returnModel == [] ||
          res.returnModel == null ||
          res.returnModel!.isEmpty) {
        emit(AddPutAwayFailure(message: '5544'.tr()));
        return;
      }

      emit(AddPutAwaySuccess(orderItem: res.returnModel![0]));
    } catch (e) {
      emit(AddPutAwayFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(SavePutAway event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddPutAwaySuccess) {
        emit(AddPutAwayLoading());

        final content = SavePutAwayRequest(
            orderNo: currentState.orderItem.iOrdNo!,
            pwDate: FileUtils.formatToStringFromDatetime(DateTime.now()),
            grade: currentState.orderItem.grade ?? '',
            itemStatus: currentState.orderItem.itemStatus ?? '',
            pwQty: event.pwQty,
            grQty: currentState.orderItem.qty!,
            locCode: event.locCode,
            lotCode: currentState.orderItem.lotCode ?? "",
            grNo: event.grNo,
            userId: event.userId);
        final apiSave = await _putAwayRepo.savePutAway(
            content: content, subsidiaryId: event.subsidiaryId);
        if (apiSave.isFailure) {
          emit(AddPutAwayFailure(message: apiSave.getErrorMessage()));
          return;
        }
        emit(AddPutAwaySaveSuccess(orderItem: OrderItem()));
      }
    } catch (e) {
      emit(AddPutAwayFailure(message: e.toString()));
    }
  }
}
