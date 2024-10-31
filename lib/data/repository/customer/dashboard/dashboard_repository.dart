import 'package:dio/dio.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

import '../../../base/abstract_repository.dart';
import '../../../models/customer/home/customer_permission_res.dart';
import '../../../models/customer/home/os_get_today_respone.dart';
import '../../../models/login/data_login_request.dart';
import '../../../services/network/client.dart';
import '../../../services/result/api_result.dart';

abstract class AbstractCustomerDashBoardRepository
    implements AbstractRepository {
  Future<ApiResult<CustomerPermissionRes>> getCustomerPermission(
      {required String userId, required String lan, required String sysid});
  Future<ApiResult<OsTodayRes>> getCustomerOsToday(
      {required String subsidiary,
      required String contactCode,
      required String dcCode});
}

@injectable
class CustomerDashBoardRepository
    implements AbstractCustomerDashBoardRepository {
  AbstractDioHttpClient client;
  CustomerDashBoardRepository({required this.client});

  @override
  Future<ApiResult<CustomerPermissionRes>> getCustomerPermission(
      {required String userId,
      required String lan,
      required String sysid}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerPermission, [userId, lan, sysid]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: CustomerPermissionRes.fromJson(api));
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
  Future<ApiResult<OsTodayRes>> getCustomerOsToday(
      {required String subsidiary,
      required String contactCode,
      required String dcCode}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getOsToday, [subsidiary, contactCode, dcCode]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: OsTodayRes.fromJson(api));
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
