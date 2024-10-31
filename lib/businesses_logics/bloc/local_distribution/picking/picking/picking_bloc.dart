import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_item_response.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_search_request.dart';
import 'package:igls_new/data/repository/ware_house/picking/picking_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'picking_event.dart';
part 'picking_state.dart';

class PickingBloc extends Bloc<PickingEvent, PickingState> {
  final _pickingRepo = getIt<PickingRepository>();
  PickingBloc() : super(PickingInitial()) {
    on<PickingSearch>(_mapSearchWaveNoToState);
  }
  Future<void> _mapSearchWaveNoToState(PickingSearch event, emit) async {
    emit(PickingLoading());
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
        emit(PickingFailure(message: apiSearch.getErrorMessage()));
        return;
      }
      emit(PickingSuccess(lstItem: apiSearch.data));
    } catch (e) {
      emit(PickingFailure(message: e.toString()));
    }
  }
}
