import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_detail_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_res.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../models/models.dart';

abstract class AbstractCustomerOOSRepository implements AbstractRepository {
  Future<ApiResult> getOOS(
      {required CustomerOOSReq content, required String subsidiaryId});
  Future<ApiResult> getOOSDetail(
      {required int orderid, required String subsidiaryId});
}

@injectable
class CustomerOOSRepository implements AbstractCustomerOOSRepository {
  AbstractDioHttpClient client;
  CustomerOOSRepository({required this.client});

  @override
  Future<ApiResult> getOOS(
      {required CustomerOOSReq content, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.customerGetOOS,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerOOSRes>.from(
                api.map((x) => CustomerOOSRes.fromJson(x))));
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
  Future<ApiResult> getOOSDetail(
      {required int orderid, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(sprintf(
        endpoints.customerOOSDetail,
        [orderid, subsidiaryId],
      ));
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: CustomerOOSDetailRes.fromJson(api));
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
