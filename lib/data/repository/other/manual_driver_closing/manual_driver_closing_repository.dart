import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_request.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_response.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_update_request.dart';
import 'package:igls_new/data/models/other/manual_driver_closing/driver_daily_closing_detail_response.dart';
import 'package:igls_new/data/models/other/manual_driver_closing/driver_daily_closing_with_tripno_request.dart';
import 'package:igls_new/data/models/other/manual_driver_closing/driver_daily_closing_without_tripno_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractManualDriverClosingRepository
    implements AbstractRepository {
  Future<ApiResult> getSaveWithoutTripNo(
      {required DriverDailyClosingWithoutTripNoRequest content,
      required String subsidiary});

  Future<ApiResult> getDriverClosingHistory(
      {required DriverClosingHistoryRequest content});
  Future<ApiResult> getDriverClosingHistoryDetail(
      {required int ddcId, required String subsidiaryId});
  Future<ApiResult> getSaveWithTripNo(
      {required DriverDailyClosingWithTripNoRequest content,
      required String subsidiary});
  Future<ApiResult> updateDriverClosing(
      {required UpdateDriverDailyClosingReq content,
      required String subsidiary});
}

@injectable
class ManualDriverClosingRepository
    implements AbstractManualDriverClosingRepository {
  AbstractDioHttpClient client;
  ManualDriverClosingRepository({required this.client});

  @override
  Future<ApiResult> getSaveWithoutTripNo(
      {required DriverDailyClosingWithoutTripNoRequest content,
      required String subsidiary}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getSaveDriverDailyClosingWithoutTripNo,
              [subsidiary, '']),
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
  Future<ApiResult> getDriverClosingHistory(
      {required DriverClosingHistoryRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getDriverDailyClosings, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<DriverClosingHistoryResponse>.from(
                api.map((x) => DriverClosingHistoryResponse.fromMap(x))));
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
  Future<ApiResult> getDriverClosingHistoryDetail(
      {required int ddcId, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getDriverDailyClosing, [ddcId, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: DriverDailyClosingDetailResponse.fromMap(api));
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
  Future<ApiResult> getSaveWithTripNo(
      {required DriverDailyClosingWithTripNoRequest content,
      required String subsidiary}) async {
    try {
      final request = ModelRequest(
          sprintf(
              endpoints.getSaveDriverDailyClosingWithTripNo, [subsidiary, '']),
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
  Future<ApiResult> updateDriverClosing(
      {required UpdateDriverDailyClosingReq content,
      required String subsidiary}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateDriverDailyClosing, [subsidiary]),
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
}
