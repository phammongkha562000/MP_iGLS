import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_total_res.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../services/services.dart';

abstract class AbstractCustomerInventoryRepository
    implements AbstractRepository {
  Future<ApiResult> getInventory(
      {required CustomerInventoryReq content, required String subsidiaryId});
  Future<ApiResult> getInventoryTotal(
      {required CustomerInventoryReq content, required String subsidiaryId});
  Future<ApiResult> getContactStd(
      {required String contactCode,
      required String stdType,
      required String subsidiaryId});
}

@injectable
class CustomerInventoryRepository
    implements AbstractCustomerInventoryRepository {
  AbstractDioHttpClient client;
  CustomerInventoryRepository({required this.client});

  @override
  Future<ApiResult> getInventory(
      {required CustomerInventoryReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.customerGetInventory,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerInventoryRes>.from(
                api.map((x) => CustomerInventoryRes.fromJson(x))));
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
  Future<ApiResult> getInventoryTotal(
      {required CustomerInventoryReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.customerGetInventoryTotal,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerInventoryTotalRes>.from(
                api.map((x) => CustomerInventoryTotalRes.fromJson(x))));
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
  Future<ApiResult> getContactStd(
      {required String contactCode,
      required String stdType,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(
            endpoints.customerContactStd, [stdType, contactCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<GetStdCodeRes>.from(
                api.map((x) => GetStdCodeRes.fromJson(x))));
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
