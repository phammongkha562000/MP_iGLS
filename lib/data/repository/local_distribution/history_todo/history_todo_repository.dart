import 'package:dio/dio.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../base/abstract_repository.dart';
import '../../../models/local_distribution/history_todo/history_todo.dart';
import '../../../models/login/data_login_request.dart';
import '../../../services/network/client.dart';
import '../../../services/result/result.dart';

abstract class AbstractHistoryTodoRepository implements AbstractRepository {
  Future<ApiResult> getListHistoryTodo({
    required HistoryTodoRequest content,
    required String subsidiaryId,
  });
  Future<ApiResult> getNormaHistoryDetail({
    required String tripNoNormal,
    required String dcCode,
    required String subsidiaryId,
  });
}

@injectable
class HistoryTodoRepository implements AbstractHistoryTodoRepository {
  AbstractDioHttpClient client;
  HistoryTodoRepository({required this.client});

  @override
  Future<ApiResult> getListHistoryTodo({
    required HistoryTodoRequest content,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getHistoryTodo, [subsidiaryId]),
          body: content.toJson());

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: endpoints.getHistoryTodo));
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
  Future<ApiResult> getNormaHistoryDetail({
    required String tripNoNormal,
    required String dcCode,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(sprintf(
          endpoints.getNormalTripDetail, [tripNoNormal, dcCode, subsidiaryId]));

      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: NormalTripDetailResponse.fromMap(api));
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
