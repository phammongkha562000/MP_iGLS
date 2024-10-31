import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/driver_salary/driver_salary_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../services/injection/injection_igls.dart';
import '../../../services/network/client.dart';

abstract class AbstractDriverSalaryRepository implements AbstractRepository {
  Future<ApiResult> getFileSalary(
      {required String empCode, required String baseUrl});
}

@injectable
class DriverSalaryRepository implements AbstractDriverSalaryRepository {
  AbstractDioHttpClient client;
  DriverSalaryRepository({required this.client});

  @override
  Future<ApiResult> getFileSalary(
      {required String empCode, required String baseUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      final request = ModelRequest(
        sprintf(endpoints.getFileForDriverSalary, [empCode]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: DriverSalaryResponse.fromMap(api));
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
