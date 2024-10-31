import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

import '../../../models/models.dart';
import '../../../models/mpi/leave/leaves/leaves.dart';

abstract class AbstractLeaveRepository implements AbstractRepository {
  Future<ApiResult> getLeave(
      {required LeaveRequest content,
      required String baseUrl,
      required String mpiUrl});
  Future<ApiResult> getLeaveDetail(
      {required String lvNo,
      required String empCode,
      required String baseUrl,
      required String mpiUrl});

  Future<ApiResult> checkLeaveWithType(
      {required CheckLeaveRequest content,
      required String baseUrl,
      required String mpiUrl});

  Future<ApiResult> createNewLeave(
      {required NewLeaveRequest content,
      required String baseUrl,
      required String mpiUrl});
}

class LeaveRepository implements AbstractLeaveRepository {
  AbstractDioHttpClient client;
  LeaveRepository({required this.client});

  @override
  Future<ApiResult> getLeave(
      {required LeaveRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));

      final request = ModelRequest(endpoints.getLeave, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api, endpoint: endpoints.getLeave));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getLeaveDetail({
    required String lvNo,
    required String empCode,
    required String baseUrl,
    required String mpiUrl,
  }) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));

      final request =
          ModelRequest(sprintf(endpoints.getLeaveDetail, [lvNo, empCode]));
      final api = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.getLeaveDetail));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> checkLeaveWithType(
      {required CheckLeaveRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));

      final request =
          ModelRequest(endpoints.checkLeaveWithType, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.checkLeaveWithType));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> createNewLeave(
      {required NewLeaveRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));

      final request =
          ModelRequest(endpoints.createNewLeave, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.createNewLeave));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
}
