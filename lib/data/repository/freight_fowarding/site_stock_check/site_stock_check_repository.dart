import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_delete_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_pending_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_summary_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_summary_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/trailer_search_request.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractSiteStockCheckRepository implements AbstractRepository {
  Future<ApiResult> getCYSite({required String subsidiaryId});
  Future<ApiResult> getSiteStockCheck(
      {required TrailerSearchRequest content, required String subsidiaryId});
  Future<dynamic> getSaveSiteStockCheck(
      {required SiteStockCheckRequest content, required String subsidiaryId});

  Future<ApiResult> getSiteStockCheckSummary(
      {required SiteStockSummaryRequest content, required String subsidiaryId});

  Future<ApiResult> deleteSiteStockCheck(
      {required SiteStockCheckDeleteRequest content,
      required String subsidiaryId});
  Future<ApiResult> getTrailerPending(
      {required SiteStockCheckPendingRequest content,
      required String companyId});
}

@injectable
class SiteStockCheckRepository implements AbstractSiteStockCheckRepository {
  AbstractDioHttpClient client;
  SiteStockCheckRepository({required this.client});

  @override
  Future<ApiResult> getCYSite({required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(endpoints.getCYSite, [subsidiaryId]),
    );
    try {
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<CySiteResponse>.from(
                api.map((x) => CySiteResponse.fromJson(x))));
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
  Future<ApiResult> getSiteStockCheck(
      {required TrailerSearchRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getTrailerStock,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<SiteStockCheckResponse>.from(
                api.map((x) => SiteStockCheckResponse.fromJson(x))));
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
  Future<StatusResponse> getSaveSiteStockCheck(
      {required SiteStockCheckRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(
          endpoints.getSaveSiteStockCheck,
          [subsidiaryId],
        ),
        body: content.toMap());
    return await client.post<StatusResponse>(
        request, (data) => StatusResponse.fromJson(data));
  }

  @override
  Future<ApiResult> getSiteStockCheckSummary(
      {required SiteStockSummaryRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getSiteStockCheckSummary,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<SiteStockSummaryResponse>.from(
                api.map((x) => SiteStockSummaryResponse.fromJson(x))));
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
  Future<ApiResult> deleteSiteStockCheck(
      {required SiteStockCheckDeleteRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.deleteSiteStockCheck,
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
  Future<ApiResult> getTrailerPending(
      {required SiteStockCheckPendingRequest content,
      required String companyId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getSiteStockCheckPending,
            [companyId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<TrailerPendingRes>.from(
                api.map((x) => TrailerPendingRes.fromJson(x))));
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
