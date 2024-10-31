import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';

import '../../../../../data/repository/freight_fowarding/site_trailer/site_trailer_repository.dart';
import '../../../../../data/services/injection/injection_igls.dart';

part 'site_trailer_pending_event.dart';
part 'site_trailer_pending_state.dart';

class SiteTrailerPendingBloc
    extends Bloc<SiteTrailerPendingEvent, SiteTrailerPendingState> {
  final _siteTrailerRepo = getIt<SiteTrailerRepository>();

  SiteTrailerPendingBloc() : super(SiteTrailerPendingInitial()) {
    on<SiteTrailerPendingLoad>(_mapViewLoadedToState);
    on<SiteTrailerIsPendingChanged>(_mapIsPendingChangedToState);
  }
  Future<void> _mapViewLoadedToState(SiteTrailerPendingLoad event, emit) async {
    try {
      emit(SiteTrailerPendingLoading());
      final apiResult = await _siteTrailerRepo.getTrailerPending(
          isPending: 0,
          branchCode: event.generalBloc.generalUserInfo?.defaultBranch ?? '',
          companyId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(SiteTrailerPendingFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<TrailerPendingRes> pendingList = apiResult.data ?? [];
      List<TrailerPendingRes> filterList = (event.cyPending == null ||
              event.cyPending?.cyCode == '')
          ? pendingList
          : pendingList
              .where(
                  (element) => element.lastCYName == event.cyPending!.cyName!)
              .toList();
      emit(SiteTrailerPendingSuccess(lstTrailerPendingFilter: filterList));
    } catch (e) {
      emit(SiteTrailerPendingFailure(message: e.toString()));
    }
  }

  Future<void> _mapIsPendingChangedToState(
      SiteTrailerIsPendingChanged event, emit) async {
    try {
      emit(SiteTrailerPendingLoading());
      final apiResult = await _siteTrailerRepo.getTrailerPending(
          isPending: event.isPending ? 1 : 0,
          branchCode: event.generalBloc.generalUserInfo?.defaultBranch ?? '',
          companyId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(SiteTrailerPendingFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<TrailerPendingRes> pendingList =
          apiResult.data == '' ? [] : apiResult.data;

      List<TrailerPendingRes> filterList = (event.cyPending == null ||
              event.cyPending?.cyCode == '')
          ? pendingList
          : pendingList
              .where(
                  (element) => element.lastCYName == event.cyPending!.cyName!)
              .toList();
      emit(SiteTrailerPendingSuccess(lstTrailerPendingFilter: filterList));
    } catch (e) {
      emit(SiteTrailerPendingFailure(message: e.toString()));
    }
  }
}
