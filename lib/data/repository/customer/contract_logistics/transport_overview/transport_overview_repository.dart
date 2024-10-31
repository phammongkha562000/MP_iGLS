import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_request.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

import '../../../../services/services.dart';

abstract class AbstractTransportOverviewRepository
    implements AbstractRepository {
  Future<ApiResult> getTransportOverview(
      {required CustomerTransportOverviewReq content});
}

@injectable
class TransportOverviewRepository
    implements AbstractTransportOverviewRepository {
  AbstractDioHttpClient client;
  TransportOverviewRepository({required this.client});

  @override
  Future<ApiResult> getTransportOverview(
      {required CustomerTransportOverviewReq content}) async {
    try {
      final request = ModelRequest(endpoints.customerGetTransportOverview,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: CustomerTransportOverviewRes.fromJson(api));
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
