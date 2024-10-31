import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/freight_fowarding.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_item_response.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_type_response.dart';
import 'package:igls_new/data/models/ware_house/put_away/put_away_item_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/ware_house/put_away/save_put_item_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractPutAwayRepository implements AbstractRepository {
  Future<ApiResult> getOrderType(
      {required String subsidiaryId,
      required String contactCode,
      required String orderType});
  Future<ApiResult> getOrders({required PutAwayItemRequest content});
  Future<ApiResult> savePutAway({
    required SavePutAwayRequest content,
    required String subsidiaryId,
  });
}

@injectable
class PutAwayRepository implements AbstractPutAwayRepository {
  AbstractDioHttpClient client;
  PutAwayRepository({required this.client});

  @override
  Future<ApiResult> getOrderType(
      {required String subsidiaryId,
      required String contactCode,
      required String orderType}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getOrderType, [orderType, contactCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<OrderTypeRes>.from(
                api.map((e) => OrderTypeRes.fromJson(e))));
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
  Future<ApiResult> getOrders({required PutAwayItemRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getOrderForPW, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: OrderForPwResponse.fromJson(api));
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
  Future<ApiResult> savePutAway({
    required SavePutAwayRequest content,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(sprintf(endpoints.savePW, [subsidiaryId]),
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
