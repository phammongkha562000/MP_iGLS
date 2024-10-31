import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/mpi/common/work_flow_request.dart';
import 'package:igls_new/data/models/mpi/timesheet/clock_in_out/clock_in_out_request.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_request.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_update_wh_request.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/data/services/result/mpi_api_response.dart';
import 'package:sprintf/sprintf.dart';

import '../../../models/models.dart';
import '../../../services/result/api_result.dart';

abstract class AbstractTimesheetRepository implements AbstractRepository {
  Future<ApiResult> getcoworklocs(
      {required String baseUrl, required String mpiUrl});
  // Future<ApiResult<ApiResponse>> validationLocation({
  //   required ValidationLocationRequest content,
  // });
  Future<ApiResult> postCheckInOut(
      {required ClockInOutRequest content,
      required String baseUrl,
      required String mpiUrl});
  Future<ApiResult> getStdCodeWithType(
      {required String typeStdCode,
      required String baseUrl,
      required String mpiUrl});

  Future<ApiResult> getTimesheets(
      {required TimesheetsRequest content,
      required String baseUrl,
      required String mpiUrl});

  Future<ApiResult> updateTimesheets(
      {required TimesheetsUpdateRequest content,
      required String baseUrl,
      required String mpiUrl});
  Future<ApiResult> getWorkFlow(
      {required WorkFlowRequest content,
      required String baseUrl,
      required String mpiUrl});
}

class TimesheetRepository implements AbstractTimesheetRepository {
  AbstractDioHttpClient client;
  TimesheetRepository({required this.client});

  @override
  Future<ApiResult> getcoworklocs(
      {required String baseUrl, required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));
      final request = ModelRequest(endpoints.getcoworklocs);

      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: endpoints.getcoworklocs));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getStdCodeWithType(
      {required String typeStdCode,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));
      final request =
          ModelRequest(sprintf(endpoints.mpiGetStdcode, [typeStdCode]));
      final api = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: endpoints.mpiGetStdcode));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
  // @override
  // Future<ApiResult<ApiResponse>> validationLocation({
  //   required ValidationLocationRequest content,
  // }) async {
  //   try {
  //     final request =
  //         ModelRequest(Endpoint.validationLocation, body: content.toJson());
  //     final api = await client.postNew(request, (data) => data);
  //     if (api is! DioException) {
  //       return ApiResult.success(
  //           data: ApiResponse.fromJson(api,
  //               endpoint: Endpoint.validationLocation));
  //     } else {
  //       return ApiResult.fail(
  //         error: api,
  //       );
  //     }
  //   } catch (e) {
  //     return ApiResult.fail(error: e);
  //   }
  // }

  @override
  Future<ApiResult> postCheckInOut(
      {required ClockInOutRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));
      final request =
          ModelRequest(endpoints.postCheckInOut, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.postCheckInOut));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getTimesheets(
      {required TimesheetsRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));
      final request =
          ModelRequest(endpoints.getTimeSheetService, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.getTimeSheetService));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> updateTimesheets(
      {required TimesheetsUpdateRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));

      final request =
          ModelRequest(endpoints.putTimeSheetService, body: content.toJson());
      final api = await client.putNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data: MPiApiResponse.fromJson(api,
                endpoint: endpoints.putTimeSheetService));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }

  @override
  Future<ApiResult> getWorkFlow(
      {required WorkFlowRequest content,
      required String baseUrl,
      required String mpiUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: mpiUrl));
      final request = ModelRequest(
        endpoints.getWorkFlow,
        body: content.toJson(),
      );
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      if (api is! DioException) {
        return ApiResult.success(
            data:
                MPiApiResponse.fromJson(api, endpoint: endpoints.getWorkFlow));
      } else {
        return ApiResult.fail(error: api, errorCode: 0);
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()), errorCode: 0);
    }
  }
}
