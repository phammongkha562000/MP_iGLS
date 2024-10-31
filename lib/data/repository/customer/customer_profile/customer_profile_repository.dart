import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:sprintf/sprintf.dart';
import '../../../base/abstract_repository.dart';
import '../../../models/customer/customer_profile/change_pass_res.dart';
import '../../../models/customer/customer_profile/get_timeline_res.dart';
import '../../../models/customer/customer_profile/update_cus_profile_req.dart';
import '../../../models/customer/customer_profile/update_cus_profile_res.dart';
import '../../../models/login/data_login_request.dart';
import '../../../services/network/client.dart';
import '../../../services/result/api_result.dart';

abstract class AbstractCustomerProfileRepository implements AbstractRepository {
  Future<ApiResult<UpdateCusProfileRes>> updateCusProfile(
      {required UpdateCusProfileReq model});
  Future<ApiResult<ChangePassRes>> changePassword(
      {required String userId,
      required String password,
      required String systemId});
  Future<ApiResult<GetTimeLineRes>> getTimeLine({required String userId});
}

@injectable
class CustomerProfileRepository implements AbstractCustomerProfileRepository {
  AbstractDioHttpClient client;
  CustomerProfileRepository({required this.client});

  @override
  Future<ApiResult<UpdateCusProfileRes>> updateCusProfile(
      {required UpdateCusProfileReq model}) async {
    try {
      final request = ModelRequest(
        endpoints.customerUpdateProfile,
        body: model.toJson(),
      );
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: UpdateCusProfileRes.fromJson(api));
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
  Future<ApiResult<ChangePassRes>> changePassword(
      {required String userId,
      required String password,
      required String systemId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerChangePass, [userId, password, systemId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: ChangePassRes.fromJson(api));
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
  Future<ApiResult<GetTimeLineRes>> getTimeLine({
    required String userId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerTimeLine, [userId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: GetTimeLineRes.fromJson(api));
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
