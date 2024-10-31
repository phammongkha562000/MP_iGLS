import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/customer/global_visibility/cntr_haulage/cntr_haulage_repository.dart';

import '../../../../../../data/models/customer/global_visibility/cntr_haulage/get_cntr_haulage_req.dart';
import '../../../../../../data/models/customer/global_visibility/cntr_haulage/get_cntr_haulage_res.dart';
import '../../../../../../data/services/injection/injection_igls.dart';

part 'cntr_haulage_event.dart';
part 'cntr_haulage_state.dart';

class CntrHaulageBloc extends Bloc<CntrHaulageEvent, CntrHaulageState> {
  CntrHaulageBloc() : super(CntrHaulageInitial()) {
    on<CntrHaulageLoad>(_cntrHaulageLoad);
  }
  final _cntrHaulageRepo = getIt<CntrHaulageRepository>();

  Future<void> _cntrHaulageLoad(CntrHaulageLoad event, emit) async {
    try {
      emit(CntrHaulageLoading());

      var result = await _cntrHaulageRepo.getCntrHaulage(
          model: event.model, strCompany: event.strCompany);

      if (result.isFailure) {
        emit(GetCntrHaulageFail(message: result.getErrorMessage()));
        return;
      }
      emit(GetCntrHaulageSuccess(lstCntrHaulage: result.data));
    } catch (e) {
      emit(CntrHaulageLoadFail(message: e.toString()));
    }
  }
}
