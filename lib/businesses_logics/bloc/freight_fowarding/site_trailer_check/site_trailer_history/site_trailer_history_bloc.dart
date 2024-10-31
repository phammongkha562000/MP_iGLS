import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/repository/freight_fowarding/site_stock_check/site_stock_check_repository.dart';
import 'package:igls_new/data/repository/freight_fowarding/site_trailer/site_trailer_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../data/models/models.dart';

part 'site_trailer_history_event.dart';
part 'site_trailer_history_state.dart';

class SiteTrailerHistoryBloc
    extends Bloc<SiteTrailerHistoryEvent, SiteTrailerHistoryState> {
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();
  final _siteTrailerRepo = getIt<SiteTrailerRepository>();

  SiteTrailerHistoryBloc() : super(SiteTrailerHistoryInitial()) {
    on<SiteTrailerHistoryViewLoaded>(_mapViewLoadedToState);
    on<SiteTrailerHistorySearch>(_mapSearchToState);
  }
  Future<void> _mapViewLoadedToState(
      SiteTrailerHistoryViewLoaded event, emit) async {
    emit(SiteTrailerHistoryLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final apiResult = await _siteTrailerRepo.getSiteTrailerHistory(
          trailer: event.trailer, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(SiteTrailerHistoryFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }

      List<CySiteResponse> cySiteList = [];
      cySiteList.add(CySiteResponse(cyCode: '', cyName: '5059'.tr()));

      List<CySiteResponse> listCY = [];
      listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteTrailerHistoryFailure(message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }
      cySiteList.addAll(listCY);
      emit(SiteTrailerHistorySuccess(
          historyList: apiResult.data,
          cySiteList: cySiteList,
          historyFilterList: apiResult.data));
    } catch (e) {
      emit(SiteTrailerHistoryFailure(message: e.toString()));
    }
  }

  void _mapSearchToState(SiteTrailerHistorySearch event, emit) {
    try {
      final currentState = state;
      if (currentState is SiteTrailerHistorySuccess) {
        List<SiteTrailerResponse> historyFilterList = event.cySite == ''
            ? currentState.historyList
            : currentState.historyList
                .where((element) => element.cyName == event.cySite)
                .toList();
        emit(currentState.copyWith(historyFilterList: historyFilterList));
      }
    } catch (e) {
      emit(SiteTrailerHistoryFailure(message: e.toString()));
    }
  }
}
