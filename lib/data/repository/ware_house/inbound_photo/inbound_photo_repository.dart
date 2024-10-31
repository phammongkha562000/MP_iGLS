import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/ware_house/inbound_photo/order_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractInboundPhotoRepository implements AbstractRepository {
  Future<ApiResult> getOrder({required OrderInboundPhotoRequest content});
}

@injectable
class InboundPhotoRepository implements AbstractInboundPhotoRepository {
  AbstractDioHttpClient client;
  InboundPhotoRepository({required this.client});

  @override
  Future<ApiResult> getOrder(
      {required OrderInboundPhotoRequest content}) async {
    try {
      final request = ModelRequest(endpoints.getOrdersForInboundImage,
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: endpoints.getOrdersForInboundImage));
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
