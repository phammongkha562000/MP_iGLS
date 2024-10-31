import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/simple_trip_request.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/todo_request.dart';
import 'package:igls_new/data/models/std_code/std_code_response.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/to_do_normal_trip_detail_response.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/to_do_trip_detail_response.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/update_normal_trip_status_org_request.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/update_normal_trip_status_request.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/update_trip_status_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractToDoLocalDistributionRepository
    implements AbstractRepository {
  Future<ApiResult> getListToDoTrips({required TodoRequest content});
  Future<ApiResult> getToDoTripDetail(
      {required String tripNo, required String subsidiaryId});
  Future<ApiResult> getUpdateTripStatusDetail(
      {required UpdateTripStatusRequest content,
      required String contactCode,
      required String subsidiaryId});
  Future<ApiResult> getStdCode(
      {required String stdCode, required String subsidiaryId});
  // Future<dynamic> getDirectionsInformation(
  //     {required LatLng origin,
  //     required LatLng destination,
  //     required bool sensor,
  //     required String output});
  Future<String> getUrlCheckList(
      {required String userId,
      required String equipmentNo,
      required String tripNo,
      required String createUser});
  Future<ApiResult> getNormalTripDetail(
      {required String tripNo,
      required String dcCode,
      required String companyId});
  Future<ApiResult> updateNormalTripStatusDetail(
      {required UpdateNormalTripStatusRequest content,
      required String subsidiaryId});
  Future<ApiResult> updateNormalTripOrgItemStatusDetail(
      {required UpdateNormalTripStatusOrgItemRequest content});
  Future<ApiResult> getDriverContactUsedFreq(
      {required String equipmentCode,
      required String dcCode,
      required String companyId});
  Future<ApiResult> getUpdateSimpleTripMyWork(
      {required SimpleTripRequest content, required String subsidiaryId});
  Future<ApiResult> getAddSimpleTripMyWork(
      {required SimpleTripRequest content,
      required String contact,
      required String subsidiaryId});
}

@injectable
class ToDoTripRepository implements AbstractToDoLocalDistributionRepository {
  AbstractDioHttpClient client;
  ToDoTripRepository({required this.client});

  @override
  Future<ApiResult> getListToDoTrips({required TodoRequest content}) async {
    final request = ModelRequest(endpoints.getTripTodo, body: content.toJson());
    try {
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: endpoints.getTripTodo));
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
  Future<ApiResult> getToDoTripDetail(
      {required String tripNo, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getSimpleTripDetail, [tripNo, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: ToDoTripDetailResponse.fromMap(api));
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
  Future<ApiResult> getUpdateTripStatusDetail(
      {required UpdateTripStatusRequest content,
      required String contactCode,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
              endpoints.updateSimpleTripStatus, [contactCode, subsidiaryId]),
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
  Future<ApiResult> getStdCode(
      {required String stdCode, required String subsidiaryId}) async {
    try {
      final request =
          ModelRequest(sprintf(endpoints.getStdCodes, [stdCode, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<StdCode>.from(api.map((x) => StdCode.fromJson(x))));
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

// //xem lại - do đang dùng free
//   @override
//   Future<dynamic> getDirectionsInformation(
//       {required LatLng origin,
//       required LatLng destination,
//       required bool sensor,
//       required String output}) async {
//     final strOrigin = "origin=${origin.latitude},${origin.longitude}";
//     final strDestination =
//         "destination=${destination.latitude},${destination.longitude}";
//     final strSensor = "sensor=$sensor";
//     final parameters = "$strOrigin&$strDestination&$strSensor";

//     return await Dio().get(sprintf(
//         endpoints.urlGoogleMap, [output, parameters, constants.googleApiKey]));
//   }

  @override
  Future<String> getUrlCheckList(
      {required String userId,
      required String equipmentNo,
      required String tripNo,
      required String createUser}) async {
    getIt<AbstractDioHttpClient>()
        .addOptions(BaseOptions(baseUrl: 'https://qa.igls.vn:8086/'));

    final request = ModelRequest(
      sprintf(endpoints.urlCheckListToDoTrip,
          [userId, equipmentNo, tripNo, createUser]),
    );
    return await client.get(request, (data) => data);
  }

  @override
  Future<ApiResult> getNormalTripDetail(
      {required String tripNo,
      required String dcCode,
      required String companyId}) async {
    final request = ModelRequest(
      sprintf(endpoints.getNormalTripForMobile, [tripNo, dcCode, companyId]),
    );
    final api = await client.getNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(
          data: ToDoNormalTripDetailResponse.fromJson(api));
    } else {
      return ApiResult.fail(
          error: api,
          errorCode: api.response == null
              ? constants.errorNoConnect
              : api.response!.statusCode!);
    }
  }

  @override
  Future<ApiResult> updateNormalTripStatusDetail(
      {required UpdateNormalTripStatusRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateNormalTripStatus, [subsidiaryId]),
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
  Future<ApiResult> updateNormalTripOrgItemStatusDetail(
      {required UpdateNormalTripStatusOrgItemRequest content}) async {
    try {
      final request = ModelRequest(endpoints.updateNormalTripOrgItemStatus,
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
  Future<ApiResult> getDriverContactUsedFreq(
      {required String equipmentCode,
      required String dcCode,
      required String companyId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getDriverContactUsedFreq,
            [equipmentCode, dcCode, companyId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<ContactLocal>.from(
                api.map((x) => ContactLocal.fromJson(x))));
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
  Future<ApiResult> getUpdateSimpleTripMyWork(
      {required SimpleTripRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateSimpleTripMyWork, [subsidiaryId]),
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
  Future<ApiResult> getAddSimpleTripMyWork(
      {required SimpleTripRequest content,
      required String contact,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.saveSimpleTripForMobile2, [contact, subsidiaryId]),
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
