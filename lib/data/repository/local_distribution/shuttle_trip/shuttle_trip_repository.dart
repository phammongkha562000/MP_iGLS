import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_by_type_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_freq_request.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_freq_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/companys_by_type_request.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/delete_shuttle_trip_request.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/shuttle_trip_request.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/shuttle_trips_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/update_shuttle_trip_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractShuttleTripRepository implements AbstractRepository {
  Future<ApiResult> getListShuttleTrip({
    required ShuttleTripRequest content,
    required String subsidiaryId,
  });
  Future<ApiResult> saveShuttleTrip({
    required SaveShuttleTripRequest content,
    required String subsidiaryId,
  });
  Future<ApiResult> updateShuttleTrip({
    required SaveShuttleTripRequest content,
    required String subsidiaryId,
  });
  Future<ApiResult> deleteShuttleTrip({
    required DeleteShuttleTripRequest content,
    required String subsidiaryId,
  });
  Future<ApiResult> getCompanysbyType(
      {required GetCompanysbyTypeRequest content,
      required String subsidiaryId});
  Future<ApiResult> getCompanysFreq(
      {required CompanyFreqRequest content, required String subsidiaryId});
}

@injectable
class ShuttleTripRepository implements AbstractShuttleTripRepository {
  AbstractDioHttpClient client;
  ShuttleTripRepository({required this.client});

  @override
  Future<ApiResult> getListShuttleTrip(
      {required ShuttleTripRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getShuttleTrips, [subsidiaryId]),
          body: content.toMap());

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<ShuttleTripsResponse>.from(
                api.map((x) => ShuttleTripsResponse.fromJson(x))));
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
  Future<ApiResult> saveShuttleTrip(
      {required content, required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(endpoints.saveAddShuttleTrip, [subsidiaryId]),
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
  }

  @override
  Future<ApiResult> updateShuttleTrip(
      {required SaveShuttleTripRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateShuttleTrip, [subsidiaryId]),
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

  @override
  Future<ApiResult> deleteShuttleTrip(
      {required DeleteShuttleTripRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.deleleShuttleTrip, [subsidiaryId]),
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
  Future<ApiResult> getCompanysbyType(
      {required GetCompanysbyTypeRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getCompanysbyType, [subsidiaryId]),
          body: content.toJson());

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<CompanyResponse>.from(
                api.map((x) => CompanyResponse.fromJson(x))));
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
  Future<ApiResult> getCompanysFreq(
      {required CompanyFreqRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getCompanysFreq, [subsidiaryId]),
          body: content.toJson());

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<CompanyFreqResponse>.from(
                api.map((x) => CompanyFreqResponse.fromJson(x))));
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
