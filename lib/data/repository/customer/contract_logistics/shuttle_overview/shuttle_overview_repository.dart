import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/contract_logistics/shuttle_overview/shuttle_overview_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';

import '../../../../services/services.dart';

abstract class AbstractShuttleOverviewRepository implements AbstractRepository {
  Future<ApiResult> getShuttleOverview(
      {required String date,
      required String contactCode,
      required String dcCode,
      required String subsidiaryId});
}

@injectable
class ShuttleOverviewRepository implements AbstractShuttleOverviewRepository {
  AbstractDioHttpClient client;
  ShuttleOverviewRepository({required this.client});

  @override
  Future<ApiResult> getShuttleOverview(
      {required String date,
      required String contactCode,
      required String dcCode,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerGetShuttleOverview,
            [date, contactCode, dcCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: CustomerShuttleOverviewRes.fromJson(api));
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
