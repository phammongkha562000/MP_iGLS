import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/ware_house/pallet_relocation/pallet_relocation_response.dart';
import 'package:igls_new/data/models/ware_house/pallet_relocation/pallet_relocation_save_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractPalletRelocationRepository extends AbstractRepository {
  Future<ApiResult> getGRForRelocation(
      {required String grNo,
      required String dcNo,
      required String contactCode,
      required String subsidiaryId});
  Future<ApiResult> saveGRForRelocation(
      {required PalletRelocationSaveRequest content});
}

@injectable
class PalletRelocationRepository implements AbstractPalletRelocationRepository {
  AbstractDioHttpClient client;
  PalletRelocationRepository({required this.client});

  @override
  Future<ApiResult> getGRForRelocation(
      {required String grNo,
      required String dcNo,
      required String contactCode,
      required String subsidiaryId}) async {
    final request = ModelRequest(sprintf(
        endpoints.getGRForRelocation, [grNo, dcNo, contactCode, subsidiaryId]));
    final api = await client.get(request, (data) => data);

    if (api is! DioException) {
      return ApiResult.success(
          data: api == ''
              ? PalletRelocationResponse()
              : PalletRelocationResponse.fromJson(api));
    } else {
      return ApiResult.fail(
          error: api,
          errorCode: api.response == null
              ? constants.errorNoConnect
              : api.response!.statusCode!);
    }
  }

  @override
  Future<ApiResult> saveGRForRelocation(
      {required PalletRelocationSaveRequest content}) async {
    final request =
        ModelRequest(endpoints.saveGrForRelocation, body: content.toMap());
    final api = await client.post(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(data: StatusResponse.fromJson(api));
    } else {
      return ApiResult.fail(
          error: api,
          errorCode: api.response == null
              ? constants.errorNoConnect
              : api.response!.statusCode!);
    }
  }
}
