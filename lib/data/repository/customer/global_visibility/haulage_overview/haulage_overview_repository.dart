import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_res.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../services/services.dart';

abstract class AbstractCustomerHaulageOverviewRepository
    implements AbstractRepository {
  Future<ApiResult> getHaulageOverview(
      {required CustomerHaulageOverviewReq content});
}

@injectable
class CustomerHaulageOverviewRepository
    implements AbstractCustomerHaulageOverviewRepository {
  AbstractDioHttpClient client;
  CustomerHaulageOverviewRepository({required this.client});

  @override
  Future<ApiResult> getHaulageOverview(
      {required CustomerHaulageOverviewReq content}) async {
    try {
      final request = ModelRequest(endpoints.customerHaulageOverview,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: CustomerHaulageOverviewRes.fromJson(api));
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
