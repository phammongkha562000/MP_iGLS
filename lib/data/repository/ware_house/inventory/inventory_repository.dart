import 'package:dio/dio.dart';
import 'package:igls_new/data/models/ware_house/inventory/gr_tracking_response.dart';
import 'package:igls_new/data/models/ware_house/inventory/inventory_detail/inventory_detail_request.dart';
import 'package:igls_new/data/models/ware_house/inventory/inventory_detail/inventory_detail_response.dart';
import 'package:igls_new/data/models/ware_house/inventory/inventory_request.dart';
import 'package:igls_new/data/models/ware_house/inventory/inventory_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:sprintf/sprintf.dart';

import '../../../base/abstract_repository.dart';
import '../../../models/login/data_login_request.dart';
import '../../../services/network/client.dart';

abstract class AbstractInventoryRepository extends AbstractRepository {
  Future<ApiResult> getInventory({required InventoryRequest content});
  Future<ApiResult> getInventoryDetail(
      {required InventoryDetailRequest content});
  Future<ApiResult> getGRTracking(
      {required String grNo, required String subsidiaryId});
}

@injectable
class InventoryRepository implements AbstractInventoryRepository {
  AbstractDioHttpClient client;
  InventoryRepository({required this.client});

  @override
  Future<ApiResult> getInventory({required InventoryRequest content}) async {
    final request =
        ModelRequest(endpoints.getInventory, body: content.toJson());

    final api = await client.postNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(data: InventoryResponse.fromMap(api));
    } else {
      return ApiResult.fail(
          error: api,
          errorCode: api.response == null
              ? constants.errorNoConnect
              : api.response!.statusCode!);
    }
  }

  @override
  Future<ApiResult> getInventoryDetail(
      {required InventoryDetailRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getInventoryDetail, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: InventoryDetailResponse.fromMap(api));
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
  Future<ApiResult> getGRTracking(
      {required String grNo, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getBarcodeGRTracking, [grNo, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<GrTrackingResponse>.from(
                api.map((e) => GrTrackingResponse.fromJson(e))));
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
