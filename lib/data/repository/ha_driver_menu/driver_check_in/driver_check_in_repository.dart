import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/ha_driver_menu/driver_check_in/driver_check_in_request.dart';
import 'package:igls_new/data/models/ha_driver_menu/driver_check_in/driver_today_info_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../services/result/api_result.dart';

abstract class AbstractDriverCheckInRepository implements AbstractRepository {
  Future<ApiResult> getDriverTodayInfo(
      {required equipmentCode, required driverId, required subsidiaryId});
  Future<ApiResult> saveDriverCheckIn(
      {required DriverCheckInRequest content, required String subsidiaryId});
}

@injectable
class DriverCheckInRepository implements AbstractDriverCheckInRepository {
  AbstractDioHttpClient client;
  DriverCheckInRepository({required this.client});

  @override
  Future<ApiResult> getDriverTodayInfo(
      {required equipmentCode,
      required driverId,
      required subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(
            endpoints.getDriverToday, [equipmentCode, driverId, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: DriverTodayInfo.fromJson(api));
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
  Future<ApiResult> saveDriverCheckIn(
      {required DriverCheckInRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.saveAvailableEquipmnentCheckIn, [subsidiaryId]),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: StatusResponse.fromJson(api));
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
