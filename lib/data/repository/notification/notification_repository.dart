import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:igls_new/data/models/inbox/notification_delete_request.dart';
import 'package:igls_new/data/models/inbox/notification_update_request.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';
import 'package:injectable/injectable.dart';

import '../../base/abstract_repository.dart';
import '../../models/inbox/notification_response.dart';
import '../../services/services.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractNotificationRepository implements AbstractRepository {
  Future<ApiResult> getNotification({
    required String userId,
    required String sourceType,
    required String messageType,
    required String numberOfPage,
    required String numberOfRow,
    required String baseUrl,
    required String serverHub,
  });
  Future<ApiResult> updateNotification({
    required NotificationUpdateRequest content,
    required String baseUrl,
    required String serverHub,
  });

  Future<ApiResult> getTotalNotifications({
    required String userId,
    required String sourceType,
    required String baseUrl,
    required String serverHub,
  });
  Future<ApiResult> deleteNotification({
    required NotificationDeleteRequest content,
    required String baseUrl,
    required String serverHub,
  });
}

@injectable
class NotificationRepository implements AbstractNotificationRepository {
  AbstractDioHttpClient client;
  NotificationRepository({required this.client});

  @override
  Future<ApiResult> getNotification({
    required String userId,
    required String sourceType,
    required String messageType,
    required String numberOfPage,
    required String numberOfRow,
    required String baseUrl,
    required String serverHub,
  }) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(sprintf(endpoints.getNotification,
          [userId, sourceType, messageType, numberOfPage, numberOfRow]));
      final api1 = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      final api = jsonDecode(api1);
      if (api is! DioException) {
        return ApiResult.success(data: NotificationResponse.fromJson(api));
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
  Future<ApiResult> updateNotification({
    required NotificationUpdateRequest content,
    required String baseUrl,
    required String serverHub,
  }) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(endpoints.updateStatusNotification,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
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
  Future<ApiResult> getTotalNotifications(
      {required String userId,
      required String sourceType,
      required String baseUrl,
      required String serverHub}) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(sprintf(
        endpoints.getTotalNotifications,
        [userId, sourceType],
      ));
      final api = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
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
  Future<ApiResult> deleteNotification(
      {required NotificationDeleteRequest content,
      required String baseUrl,
      required String serverHub}) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request =
          ModelRequest(endpoints.deleteNotifications, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
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
