import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/models/ware_house/stock_count/add_stock_count_request.dart';
import 'package:igls_new/data/models/ware_house/stock_count/delete_stock_count_request.dart';
import 'package:igls_new/data/models/ware_house/stock_count/item_code_response.dart';
import 'package:igls_new/data/models/ware_house/stock_count/location_stock_count_response.dart';
import 'package:igls_new/data/models/ware_house/stock_count/stock_count_request.dart';
import 'package:igls_new/data/models/ware_house/stock_count/stock_count_response.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractStockCountRepository implements AbstractRepository {
  Future<ApiResult> addStockCount({required AddStockCountRequest content});
  Future<ApiResult> getStockCount({required StockCountRequest content});
  Future<ApiResult> getLocation(
      {required String dcCode, String? locRole, required String subsidiaryId});
  Future<ApiResult> deleteStockCount(
      {required DeleteStockCountRequest content});
  Future<ApiResult> getItemCode(
      {required String contactCode,
      required String dcCode,
      required String modelCode,
      required String subsidiaryId});
}

@injectable
class StockCountRepository implements AbstractStockCountRepository {
  AbstractDioHttpClient client;
  StockCountRepository({required this.client});

  @override
  Future<ApiResult> addStockCount(
      {required AddStockCountRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.addStockCount, body: content.toMap());
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
  Future<ApiResult> getStockCount({required StockCountRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getStockCount, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<StockCountResponse>.from(
                api.map((x) => StockCountResponse.fromMap(x))));
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
  Future<ApiResult> getLocation(
      {required String dcCode,
      String? locRole,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getLocation, [dcCode, locRole, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<LocationStockCountResponse>.from(
                api.map((x) => LocationStockCountResponse.fromMap(x))));
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
  Future<ApiResult> deleteStockCount(
      {required DeleteStockCountRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.deleteStockCount, body: content.toJson());
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
  Future<ApiResult> getItemCode(
      {required String contactCode,
      required String dcCode,
      required String modelCode,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(sprintf(endpoints.getItemCode,
          [contactCode, dcCode, modelCode, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<ItemCodeResponse>.from(
                api.map((x) => ItemCodeResponse.fromJson(x))));
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
