import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_item_response.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_search_request.dart';
import 'package:igls_new/data/models/ware_house/picking/save_picking_item_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractPickingRepository implements AbstractRepository {
  Future<ApiResult> getPickingItem({required PickingSearchRequest content});
  Future<ApiResult> getFinalGRNo(
      {required String grNo, required String subsidiaryId});
  Future<ApiResult> savePicking({required PickingItemRequest content});
}

@injectable
class PickingRepository implements AbstractPickingRepository {
  AbstractDioHttpClient client;
  PickingRepository({required this.client});

  @override
  Future<ApiResult> getPickingItem(
      {required PickingSearchRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getOrderForPick, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<PickingItemResponse>.from(
                api.map((e) => PickingItemResponse.fromJson(e))));
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
  Future<ApiResult> getFinalGRNo(
      {required String grNo, required String subsidiaryId}) async {
    try {
      final request =
          ModelRequest(sprintf(endpoints.getFinalGrNo, [grNo, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: api);
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
  Future<ApiResult> savePicking({required PickingItemRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.savePicking, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: api);
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
