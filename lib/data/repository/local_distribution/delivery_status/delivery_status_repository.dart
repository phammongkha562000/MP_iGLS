import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/local_distribution/delivery_status/delivery_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractDeliveryStatusRepository implements AbstractRepository {
  Future<ApiResult> getDeliveryStatus(
      {required String subsidiaryId,
      required String contactCode,
      required String dcCode});
}

@injectable
class DeliveryStatusRepository implements AbstractDeliveryStatusRepository {
  AbstractDioHttpClient client;
  DeliveryStatusRepository({required this.client});

  @override
  Future<ApiResult> getDeliveryStatus(
      {required String subsidiaryId,
      required String contactCode,
      required String dcCode}) async {
    try {
      final request = ModelRequest(
        sprintf(
            endpoints.getDeliveryStatus, [contactCode, dcCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: DeliveryStatusResponse.fromJson(api));
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
