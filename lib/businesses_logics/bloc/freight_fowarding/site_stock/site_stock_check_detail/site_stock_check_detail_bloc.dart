import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_delete_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_summary_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_summary_response.dart';
import 'package:igls_new/data/repository/freight_fowarding/site_stock_check/site_stock_check_repository.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/enum/range_date_search.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';
part 'site_stock_check_detail_event.dart';
part 'site_stock_check_detail_state.dart';

class SiteStockCheckDetailBloc
    extends Bloc<SiteStockCheckDetailEvent, SiteStockCheckDetailState> {
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();
  final _userprofileRepo = getIt<UserProfileRepository>();

  SiteStockCheckDetailBloc() : super(SiteStockCheckDetailInitial()) {
    on<SiteStockCheckDetailViewLoaded>(_mapViewLoadedToState);
    on<SiteStockCheckDetailSearch>(_mapSearchToState);
    on<SiteStockCheckDetailDelete>(_mapDeleteToState);
  }
  Future<void> _mapViewLoadedToState(
      SiteStockCheckDetailViewLoaded event, emit) async {
    emit(SiteStockCheckDetailLoading());
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
          emit(SiteStockCheckDetailFailure(
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
          emit(SiteStockCheckDetailFailure(
              message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }

      cySiteList.addAll(listCY);

      final dateF = DateFormat(constants.formatyyyMMdd).format(DateTime.now());
      final dateT = dateF;
      String trailerNumber = '';
      String cntrNo = '';

      final contentTrailerSearch = TrailerSearchRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: event.cyCode,
          cntrNo: cntrNo,
          dcCode: userInfo.defaultCenter ?? '');
      final apiStockCheckSearch = await _siteStockCheckRepo.getSiteStockCheck(
          content: contentTrailerSearch,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiStockCheckSearch.isFailure) {
        emit(SiteStockCheckDetailFailure(
            message: apiStockCheckSearch.getErrorMessage(),
            errorCode: apiStockCheckSearch.errorCode));
        return;
      }

      final contentTrailerSumary = SiteStockSummaryRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: event.cyCode,
          cntrNo: cntrNo);
      final apiTrailerSumary =
          await _siteStockCheckRepo.getSiteStockCheckSummary(
              content: contentTrailerSumary,
              subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiTrailerSumary.isFailure) {
        emit(SiteStockCheckDetailFailure(
            message: apiTrailerSumary.getErrorMessage(),
            errorCode: apiTrailerSumary.errorCode));
        return;
      }
      List<SiteStockSummaryResponse> lstSiteStockSumary = apiTrailerSumary.data;
      emit(SiteStockCheckDetailSuccess(
          cySiteList: cySiteList,
          siteStockCheckList: apiStockCheckSearch.data,
          dcList: dcLocalList,
          summaryList: lstSiteStockSumary));
    } catch (e) {
      emit(SiteStockCheckDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchToState(SiteStockCheckDetailSearch event, emit) async {
    try {
      emit(SiteStockCheckDetailLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      int getRangeDate = RangeDateSearch.rangeDate(rangeDate: event.rangeDate);
      final dateF = DateFormat(constants.formatyyyMMdd)
          .format(DateTime.now().subtract(Duration(days: getRangeDate)));
      final dateT = DateFormat(constants.formatyyyMMdd).format(DateTime.now());
      String trailerNumber = '';
      String cntrNo = '';

      final contentTrailerSearch = TrailerSearchRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: event.cySiteCode,
          cntrNo: cntrNo,
          dcCode: event.dcCode);
      final apiStockCheckSearch = await _siteStockCheckRepo.getSiteStockCheck(
          content: contentTrailerSearch,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiStockCheckSearch.isFailure) {
        emit(SiteStockCheckDetailFailure(
            message: apiStockCheckSearch.getErrorMessage(),
            errorCode: apiStockCheckSearch.errorCode));
        return;
      }
      final contentTrailerSumary = SiteStockSummaryRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: event.cySiteCode,
          cntrNo: cntrNo);
      final apiTrailerSumary =
          await _siteStockCheckRepo.getSiteStockCheckSummary(
              content: contentTrailerSumary,
              subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiTrailerSumary.isFailure) {
        emit(SiteStockCheckDetailFailure(
            message: apiTrailerSumary.getErrorMessage(),
            errorCode: apiTrailerSumary.errorCode));
        return;
      }

      emit(GetSiteStockCheckDetailSuccess(
          siteStockCheckList: apiStockCheckSearch.data,
          summaryList: apiTrailerSumary.data));
    } catch (e) {
      emit(SiteStockCheckDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteToState(SiteStockCheckDetailDelete event, emit) async {
    try {
      final content = SiteStockCheckDeleteRequest(
          trsId: event.trsId, updateUser: event.updateUser);
      final api = await _siteStockCheckRepo.deleteSiteStockCheck(
          content: content, subsidiaryId: event.subsidiaryId);
      if (api.isFailure) {
        emit(SiteStockCheckDetailFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      StatusResponse status = api.data;
      if (status.isSuccess != true) {
        emit(SiteStockCheckDetailFailure(message: status.message ?? ''));
        return;
      }

      emit(SiteStockCheckDeleteSuccess());
    } catch (e) {
      emit(SiteStockCheckDetailFailure(message: e.toString()));
    }
  }
}
