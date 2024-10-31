import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/ware_house/relocation/relocation_request.dart';
import 'package:igls_new/data/models/ware_house/relocation/update_relocation_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:sprintf/sprintf.dart';

abstract class AbstractRelocationRepository implements AbstractRepository {
  Future<ApiResult> getRelocation(
      {required RelocationRequest content, required String subsidiaryId});
  Future<StatusResponse> getUpdateRelocation(
      {required UpdateRelocationRequest content, required String subsidiaryId});
}

@injectable
class RelocationRepository implements AbstractRelocationRepository {
  AbstractDioHttpClient client;
  RelocationRepository({required this.client});

  @override
  Future<ApiResult> getRelocation(
      {required RelocationRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getRelocation, [subsidiaryId]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: endpoints.getRelocation));
        // data: List<RelocationResponse>.from(
        //     api.map((x) => RelocationResponse.fromMap(x))));
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
  Future<StatusResponse> getUpdateRelocation(
      {required UpdateRelocationRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(endpoints.getSaveRelocation, [subsidiaryId]),
        body: content.toMap());
    return await client.post<StatusResponse>(
        request, (data) => StatusResponse.fromJson(data));
  }
}
