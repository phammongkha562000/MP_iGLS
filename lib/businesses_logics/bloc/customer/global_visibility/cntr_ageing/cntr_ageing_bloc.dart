import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_ageing/get_cntr_ageing_res.dart';
import '../../../../../data/models/customer/global_visibility/cntr_ageing/get_cntr_ageing_req.dart';
import '../../../../../data/repository/customer/global_visibility/cntr_ageing/cntr_ageing_repository.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

part 'cntr_ageing_event.dart';
part 'cntr_ageing_state.dart';

class CntrAgeingBloc extends Bloc<CntrAgeingEvent, CntrAgeingState> {
  List<BarChartGroupData> lstBarChartData = [];

  CntrAgeingBloc() : super(CntrAgeingInitial()) {
    on<GetWoCntrAgeingEvent>(_getWoCntrAgeingEvent);
  }
  final _cntrAgeingRepo = getIt<CntrAgeingRepository>();

  Future<void> _getWoCntrAgeingEvent(GetWoCntrAgeingEvent event, emit) async {
    try {
      emit(AgeingShowLoadingState());
      var result = await _cntrAgeingRepo.getWoCntrAgeing(
          subsidiaryId: event.subsidiaryId, model: event.model);
      if (result.isFailure) {
        emit(GetWoCntrAgeingFail(message: result.getErrorMessage()));
        return;
      }
      List<GetCntrAgeingRes> lstCntrAgeing = result.data;
      lstBarChartData.clear();
      var toRemove = [];

      for (int i = -16; i <= 16; i++) {
        int totalRemaind = 0;
        int totalOver = 0;
        int totalToday = 0;
        for (var e in lstCntrAgeing) {
          if (e.remained == i && e.remained != 0) {
            totalRemaind++;
            toRemove.add(e);
          }
          if (-e.overs! == i && e.overs != 0) {
            totalOver++;
            toRemove.add(e);
          }
          if (e.remained == 0 && e.overs == 0) {
            totalToday++;
            toRemove.add(e);
          }
        }
        toRemove.clear();
        lstBarChartData.add(BarChartGroupData(x: i, barRods: [
          BarChartRodData(
              color: colors.defaultColor,
              width: 8,
              borderRadius: BorderRadius.circular(1),
              toY: double.parse(i == 0
                  ? totalToday.toString()
                  : i > 0
                      ? totalRemaind.toString()
                      : totalOver.toString()))
        ]));
      }
      emit(GetWoCntrAgeingSuccess(
          lstWoCntrAgeing: result.data, lstBarChartData: lstBarChartData));
    } catch (e) {
      emit(GetWoCntrAgeingFail(message: e.toString()));
    }
  }
}
