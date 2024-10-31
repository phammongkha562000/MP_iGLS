import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/delete_site_trailer.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/site_trailer_sumnary_res.dart';
import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../general/general_bloc.dart';

part 'site_trailer_check_detail_event.dart';
part 'site_trailer_check_detail_state.dart';

class SiteTrailerCheckDetailBloc
    extends Bloc<SiteTrailerCheckDetailEvent, SiteTrailerCheckDetailState> {
  final _siteTrailerRepo = getIt<SiteTrailerRepository>();
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();

  SiteTrailerCheckDetailBloc() : super(SiteTrailerCheckDetailInitial()) {
    on<SiteTrailerCheckDetailViewLoaded>(_mapViewLoadedToState);
    on<SiteTrailerCheckDetailPickCysite>(_mapPickCysiteToState);
    on<SiteTrailerDelete>(_mapDeleteToState);
  }
  Future<void> _mapViewLoadedToState(
      SiteTrailerCheckDetailViewLoaded event, emit) async {
    emit(SiteTrailerCheckDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      List<CySiteResponse> cySiteList = [];
      cySiteList.add(CySiteResponse(cyCode: '', cyName: '5059'.tr()));

      List<CySiteResponse> listCY = [];
      listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(SiteTrailerCheckDetailFailure(
              message: apiResult.getErrorMessage()));
          return;
        } else {
          listCY = apiResult.data;
        }
        event.generalBloc.listCY = listCY;
      }
      cySiteList.addAll(listCY);
      CySiteResponse? cySite;
      if (event.cyName != '') {
        cySite = cySiteList
            .where((element) => element.cyName == event.cyName)
            .single;
      }

      final dateF = DateFormat(constants.formatMMddyyyy).format(DateTime.now());
      final dateT = dateF;
      String trailerNumber = '';
      String cntrNo = '';

      final contentTrailerSearch = TrailerSearchRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: cySite != null ? cySite.cyCode! : '',
          cntrNo: cntrNo, );
      final apiResultSearch = await _siteTrailerRepo.getSiteTrailer(
          content: contentTrailerSearch,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultSearch.isFailure) {
        emit(SiteTrailerCheckDetailFailure(
            message: apiResultSearch.getErrorMessage(),
            errorCode: apiResultSearch.errorCode));
        return;
      }
      List<SiteTrailerResponse> apiTrailerSearch = apiResultSearch.data;
      final contentTrailerSumary = TrailerSearchRequest(
          dateF: dateF,
          dateT: dateT,
          trailerNumber: trailerNumber,
          placeSite: cySite != null ? cySite.cyCode! : '',
          cntrNo: cntrNo);
      final apiTrailerSumary = await _siteTrailerRepo.getTrailerSumary(
          content: contentTrailerSumary,
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiTrailerSumary.isFailure) {
        emit(SiteTrailerCheckDetailFailure(
            message: apiTrailerSumary.getErrorMessage(),
            errorCode: apiTrailerSumary.errorCode));
        return;
      }
      List<SiteTrailerSumaryRes> lstTrailerSumary = apiTrailerSumary.data;
      emit(SiteTrailerCheckDetailSuccess(
          cySiteList: cySiteList,
          siteTrailerList: apiTrailerSearch,
          cySite: cySite,
          lstTrailerSumary: lstTrailerSumary));
    } catch (e) {
       emit(SiteTrailerCheckDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapPickCysiteToState(
      SiteTrailerCheckDetailPickCysite event, emit) async {
    try {
      final currentState = state;
      if (currentState is SiteTrailerCheckDetailSuccess) {
        emit(SiteTrailerCheckDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final dateF =
            DateFormat(constants.formatMMddyyyy).format(DateTime.now());
        final dateT = dateF;
        String trailerNumber = '';
        String cntrNo = '';
        CySiteResponse? cySite;
        if (event.cySiteCode != '') {
          cySite = currentState.cySiteList
              .where((element) => element.cyCode == event.cySiteCode)
              .first;
        }

        final contentTrailerSearch = TrailerSearchRequest(
            dateF: dateF,
            dateT: dateT,
            trailerNumber: trailerNumber,
            placeSite: event.cySiteCode == '' ? '' : cySite!.cyCode!,
            cntrNo: cntrNo);
        final apiResultSearch = await _siteTrailerRepo.getSiteTrailer(
            content: contentTrailerSearch,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultSearch.isFailure) {
          emit(SiteTrailerCheckDetailFailure(
              message: apiResultSearch.getErrorMessage(),
              errorCode: apiResultSearch.errorCode));
          return;
        }
        List<SiteTrailerResponse> apiTrailerSearch = apiResultSearch.data;
        final contentTrailerSumary = TrailerSearchRequest(
            dateF: dateF,
            dateT: dateT,
            trailerNumber: trailerNumber,
            placeSite: cySite != null ? cySite.cyCode! : '',
            cntrNo: cntrNo);
        final apiTrailerSumary = await _siteTrailerRepo.getTrailerSumary(
            content: contentTrailerSumary,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiTrailerSumary.isFailure) {
          emit(SiteTrailerCheckDetailFailure(
              message: apiResultSearch.getErrorMessage(),
              errorCode: apiResultSearch.errorCode));
          return;
        }
        List<SiteTrailerSumaryRes> lstTrailerSumary = apiTrailerSumary.data;
        emit(currentState.copyWith(
            cySite: cySite,
            siteTrailerList: apiTrailerSearch,
            lstTrailerSumary: lstTrailerSumary));
      }
    } catch (e) {
       emit(SiteTrailerCheckDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteToState(SiteTrailerDelete event, emit) async {
    try {
      final content = DeleteSiteTrailerReq(
          trlId: event.tRLId, updateUser: event.updateUser);
      final api = await _siteTrailerRepo.deleteSiteTrailer(
          content: content, subsidiaryId: event.subsidiaryId);
      if (api.isFailure) {
        emit(SiteTrailerCheckDetailFailure(
            message: api.getErrorMessage(), errorCode: api.errorCode));
        return;
      }
      StatusResponse status = api.data;
      if (status.isSuccess != true) {
        emit(SiteTrailerCheckDetailFailure(message: status.message ?? ''));
        return;
      }

      emit(SiteTrailerCheckDeleteSuccess());
    } catch (e) {
       emit(SiteTrailerCheckDetailFailure(message: e.toString()));
    }
  }
}
