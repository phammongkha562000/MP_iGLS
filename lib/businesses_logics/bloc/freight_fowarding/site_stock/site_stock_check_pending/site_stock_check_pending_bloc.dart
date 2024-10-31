import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_pending_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/repository/freight_fowarding/site_stock_check/site_stock_check_repository.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/enum/range_date_search.dart';

part 'site_stock_check_pending_event.dart';
part 'site_stock_check_pending_state.dart';

class SiteStockCheckPendingBloc
    extends Bloc<SiteStockCheckPendingEvent, SiteStockCheckPendingState> {
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();
  final _userprofileRepo = getIt<UserProfileRepository>();

  SiteStockCheckPendingBloc() : super(SiteStockCheckPendingInitial()) {
    on<SiteStockCheckPendingViewLoaded>(_mapViewLoadedToState);
    on<SiteStockCheckPendingSearch>(_mapSearchToState);
  }
  Future<void> _mapViewLoadedToState(
      SiteStockCheckPendingViewLoaded event, emit) async {
    emit(SiteStockCheckPendingLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      List<DcLocal> dcLocalList = [];
      dcLocalList.add(DcLocal(dcCode: '', dcDesc: '5059'.tr()));

      List<DcLocal> listDC = event.generalBloc.listDC;

      if (listDC == [] || listDC.isEmpty) {
        final apiResult = await _userprofileRepo.getLocal(
            userId: userInfo.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteStockCheckPendingFailure(
              message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        listDC = response.dcLocal ?? [];
        event.generalBloc.listDC = listDC;
      }
      dcLocalList.addAll(listDC);

      List<CySiteResponse> cySiteList = [];
      cySiteList.add(CySiteResponse(cyCode: '', cyName: '5059'.tr()));

      List<CySiteResponse> listCY = [];
      listCY = event.generalBloc.listCY;
      if (listCY == []) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteStockCheckPendingFailure(
              message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }

      cySiteList.addAll(listCY);
      final dateF = DateFormat(constants.formatyyyyMMdd).format(DateTime.now());
      final dateT = dateF;
      final contentPending = SiteStockCheckPendingRequest(
          dateF: dateF,
          dateT: dateT,
          dcCode: event.generalBloc.generalUserInfo?.defaultCenter ?? '');
      final apiResult = await _siteStockCheckRepo.getTrailerPending(
          content: contentPending,
          companyId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(SiteStockCheckPendingFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<TrailerPendingRes> pendingList = apiResult.data;
      emit(SiteStockCheckPendingSuccess(
          pendingList: pendingList,
          dcList: dcLocalList,
          cySiteList: cySiteList));
    } catch (e) {
      emit(SiteStockCheckPendingFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchToState(
      SiteStockCheckPendingSearch event, emit) async {
    try {
      emit(SiteStockCheckPendingLoading());
      int getRangeDate = RangeDateSearch.rangeDate(rangeDate: event.rangeDate);
      final dateF = DateFormat(constants.formatyyyyMMdd)
          .format(DateTime.now().subtract(Duration(days: getRangeDate)));
      final dateT = DateFormat(constants.formatyyyyMMdd).format(DateTime.now());

      final contentPending = SiteStockCheckPendingRequest(
          dateF: dateF,
          dateT: dateT,
          dcCode: event.generalBloc.generalUserInfo?.defaultCenter ?? '');
      final apiResult = await _siteStockCheckRepo.getTrailerPending(
          content: contentPending,
          companyId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');
      if (apiResult.isFailure) {
        emit(SiteStockCheckPendingFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }

      emit(GetSiteStockCheckPendingSuccess(
        pendingList: apiResult.data,
      ));
    } catch (e) {
      emit(SiteStockCheckPendingFailure(message: e.toString()));
    }
  }
}
