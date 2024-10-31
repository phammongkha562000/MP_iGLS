import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_type_response.dart';
import 'package:igls_new/data/models/login/login.dart';
import 'package:igls_new/data/models/staffs/staffs_request.dart';
import 'package:igls_new/data/models/staffs/staffs_response.dart';
import 'package:igls_new/data/repository/admin/staffs/staffs_repository.dart';
import 'package:igls_new/data/repository/ware_house/put_away/put_away_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

part 'put_away_search_event.dart';
part 'put_away_search_state.dart';

class PutAwaySearchBloc extends Bloc<PutAwaySearchEvent, PutAwaySearchState> {
  final _staffRepo = getIt<StaffsRepository>();

  final _putAwayRepo = getIt<PutAwayRepository>();
  PutAwaySearchBloc() : super(PutAwaySearchInitial()) {
    on<PutAwaySearchViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      PutAwaySearchViewLoaded event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final api = await _putAwayRepo.getOrderType(
          subsidiaryId: userInfo.subsidiaryId ?? '',
          contactCode: userInfo.defaultClient ?? '',
          orderType: 'I');
      if (api.isFailure) {
        emit(PutAwaySearchFailure(message: api.getErrorMessage()));
        return;
      }
      final content = StaffsRequest(
          dcCode: userInfo.defaultCenter ?? '',
          staffName: '',
          staffUserId: '',
          roleType: '',
          mobileNo: '',
          isDeleted: 0,
          statusWorking: 'WORKING');
      final apiStaffWorking = await _staffRepo.getStaff(
          content: content, subsidiary: userInfo.subsidiaryId ?? '');
      if (apiStaffWorking.isFailure) {
        emit(PutAwaySearchFailure(message: apiStaffWorking.getErrorMessage()));
        return;
      }
      emit(PutAwaySearchSuccess(
        lstOrderType: api.data, lstStaffWorking: apiStaffWorking.data));
    } catch (e) {
      emit(PutAwaySearchFailure(message: e.toString()));
    }
  }
}
