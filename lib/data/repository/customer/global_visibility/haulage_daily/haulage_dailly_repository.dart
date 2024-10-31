import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_res.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../services/services.dart';

abstract class AbstractCustomerHaulageDailyRepository
    implements AbstractRepository {
  Future<ApiResult> getHaulageDaily(
      {required CustomerHaulageDailyReq content, required String subsidiaryId});
}

@injectable
class CustomerHaulageDailyRepository
    implements AbstractCustomerHaulageDailyRepository {
  AbstractDioHttpClient client;
  CustomerHaulageDailyRepository({required this.client});

  @override
  Future<ApiResult> getHaulageDaily(
      {required CustomerHaulageDailyReq content,
      required String subsidiaryId}) async {
    try {
      final request =
          ModelRequest(endpoints.customerHaulageDaily, body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: CustomerHaulageDailyRes.fromJson(api));
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
