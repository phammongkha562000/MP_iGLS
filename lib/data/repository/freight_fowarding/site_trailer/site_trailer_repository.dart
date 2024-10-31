import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/trailer_search_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/delete_site_trailer.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/site_trailer_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../models/freight_fowarding/site_trailer/site_trailer_sumnary_res.dart';
import '../../../models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';

abstract class AbstractSiteTrailerRepository implements AbstractRepository {
  Future<ApiResult> getSiteTrailer(
      {required TrailerSearchRequest content, required String subsidiaryId});
  Future<ApiResult> getSaveSiteTrailer(
      {required SiteStockCheckRequest content, required String subsidiaryId});
  Future<ApiResult> deleteSiteTrailer(
      {required DeleteSiteTrailerReq content, required String subsidiaryId});
  Future<ApiResult> getSiteTrailerHistory(
      {required String trailer, required String subsidiaryId});
  Future<ApiResult> getTrailerPending(
      {required int isPending,
      required String branchCode,
      required String companyId});
  Future<ApiResult> getTrailerSumary(
      {required TrailerSearchRequest content, required String subsidiaryId});
}

@injectable
class SiteTrailerRepository implements AbstractSiteTrailerRepository {
  AbstractDioHttpClient client;
  SiteTrailerRepository({required this.client});

  @override
  Future<ApiResult> getSiteTrailer(
      {required content, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getTrailer,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<SiteTrailerResponse>.from(
                api.map((x) => SiteTrailerResponse.fromMap(x))));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getSaveSiteTrailer(
      {required SiteStockCheckRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getSaveSiteTrailer,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: StatusResponse.fromJson(api));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> deleteSiteTrailer(
      {required DeleteSiteTrailerReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.deleteSiteTrailer,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: StatusResponse.fromJson(api));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getSiteTrailerHistory(
      {required String trailer, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(
          endpoints.siteTrailerHistory,
          [trailer, subsidiaryId],
        ),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<SiteTrailerResponse>.from(
                api.map((e) => SiteTrailerResponse.fromMap(e))));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getTrailerPending(
      {required int isPending,
      required String branchCode,
      required String companyId}) async {
    try {
      final request = ModelRequest(
        sprintf(
          endpoints.getTrailerPending,
          [isPending, branchCode, companyId],
        ),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: api != ''
                ? List<TrailerPendingRes>.from(
                    api.map((x) => TrailerPendingRes.fromJson(x)))
                : '');
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getTrailerSumary(
      {required TrailerSearchRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getTrailerSumary,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<SiteTrailerSumaryRes>.from(
                api.map((x) => SiteTrailerSumaryRes.fromJson(x))));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
}
