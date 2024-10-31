import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../base/abstract_repository.dart';
import '../../../../models/customer/global_visibility/cntr_ageing/get_cntr_ageing_req.dart';
import '../../../../models/customer/global_visibility/cntr_ageing/get_cntr_ageing_res.dart';
import '../../../../models/login/data_login_request.dart';
import '../../../../services/network/client.dart';
import '../../../../services/result/api_result.dart';

abstract class AbstractCntrAgeingRepository implements AbstractRepository {
  Future<ApiResult> getWoCntrAgeing(
      {required String subsidiaryId, required GetCntrAgeingReq model});
}

@injectable
class CntrAgeingRepository implements AbstractCntrAgeingRepository {
  AbstractDioHttpClient client;
  CntrAgeingRepository({required this.client});
  @override
  Future<ApiResult> getWoCntrAgeing(
      {required String subsidiaryId, required GetCntrAgeingReq model}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerGetWoCntrAgeing, [subsidiaryId]),
          body: model.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<GetCntrAgeingRes>.from(
                api.map((x) => GetCntrAgeingRes.fromJson(x))));
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
