import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';


import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';
part 'pallet_relocation_event.dart';
part 'pallet_relocation_state.dart';

class PalletRelocationBloc
    extends Bloc<PalletRelocationEvent, PalletRelocationState> {
  final _palletRelocationRepo = getIt<PalletRelocationRepository>();
  PalletRelocationBloc() : super(PalletRelocationInitial()) {
    on<PalletRelocationSearch>(_mapSearchToState);
    on<PalletRelocationSave>(_mapSaveToState);
  }

  Future<void> _mapSearchToState(PalletRelocationSearch event, emit) async {
    emit(PalletRelocationLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResponse = await _palletRelocationRepo.getGRForRelocation(
          grNo: event.grNo,
          dcNo: userInfo.defaultCenter ?? '',
          contactCode: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');

      if (apiResponse.isFailure) {
        emit(PalletRelocationFailure(message: apiResponse.getErrorMessage()));
        return;
      }
      PalletRelocationResponse res = apiResponse.data;
      if (res.gRNo == null) {
        emit(PalletRelocationFailure(message: '5544'.tr()));
        return;
      }
      emit(PalletRelocationSuccess(pallet: res));
    } catch (e) {
      emit(PalletRelocationFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(PalletRelocationSave event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final currentState = state;
      if (currentState is PalletRelocationSuccess) {
        emit(PalletRelocationLoading());
        final content = PalletRelocationSaveRequest(
            orgGRNo: currentState.pallet.gRNo!,
            orgLocCode: currentState.pallet.locCode!,
            orgQty: currentState.pallet.balanceQty!,
            locCode: event.locCode,
            qty: currentState.pallet.balanceQty!,
            balanceQty: 0,
            createUser: event.generalBloc.generalUserInfo?.userId ?? '',
            companyId: userInfo.subsidiaryId ?? '');
        final apiResponse =
            await _palletRelocationRepo.saveGRForRelocation(content: content);
        if (apiResponse.isSuccess != true) {
          emit(PalletRelocationFailure(message: apiResponse.getErrorMessage()));
          return;
        }
        emit(PalletRelocationSaveSuccess(pallet: PalletRelocationResponse()));
      }
    } catch (e) {
      emit(PalletRelocationFailure(message: e.toString()));
    }
  }
}
