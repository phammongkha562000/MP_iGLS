import 'package:dio/dio.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../base/base.dart';
import '../../../services/services.dart';

abstract class AbstractLoadingStatusRepository implements AbstractRepository {
  Future<ApiResult> getLoadingStatus(
      {required LoadingStatusRequest content, required String subsidiaryId});
  Future<ApiResult> saveLoadingStatus(
      {required LoadingStatusSaveRequest content,
      required String subsidiaryId});
}

@injectable
class LoadingStatusRepository implements AbstractLoadingStatusRepository {
  AbstractDioHttpClient client;
  LoadingStatusRepository({required this.client});

  @override
  Future<ApiResult> saveLoadingStatus(
      {required LoadingStatusSaveRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.saveLoadingStatus, [subsidiaryId]),
          body: content.toJson());
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

  @override
  Future<ApiResult> getLoadingStatus(
      {required LoadingStatusRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getLoadingStatus, [subsidiaryId]),
          body: content.toJson());

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<LoadingStatusResponse>.from(
                api.map((x) => LoadingStatusResponse.fromJson(x))));
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
