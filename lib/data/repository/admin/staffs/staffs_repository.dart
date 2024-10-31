import 'package:dio/dio.dart';
import 'package:igls_new/data/models/staffs/staff_update_request.dart';
import 'package:igls_new/data/models/staffs/vendor_request.dart';
import 'package:igls_new/data/models/staffs/vendor_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

import '../../../base/base.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import '../../../services/services.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractStaffsRepository implements AbstractRepository {
  Future<ApiResult> getStaff(
      {required StaffsRequest content, required String subsidiary});
  Future<ApiResult> getStaffDetailByUserId(
      {required String userId, required String subsidiary});
  Future<ApiResult> getVendors(
      {required VendorRequest content, required String subsidiary});
  Future<ApiResult> updateStaff(
      {required StaffUpdateRequest content, required String subsidiary});
}

@injectable
class StaffsRepository implements AbstractStaffsRepository {
  AbstractDioHttpClient client;
  StaffsRepository({required this.client});

  @override
  Future<ApiResult> getStaff(
      {required StaffsRequest content, required String subsidiary}) async {
    try {
      final request = ModelRequest(sprintf(endpoints.getStaffs, [subsidiary]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<StaffsResponse>.from(
                api.map((x) => StaffsResponse.fromJson(x))));
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
  Future<ApiResult> getStaffDetailByUserId(
      {required String userId, required String subsidiary}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getStaffDetailByUserId, [userId, subsidiary]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: StaffDetailResponse.fromJson(api));
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
  Future<ApiResult> getVendors(
      {required VendorRequest content, required String subsidiary}) async {
    try {
      final request = ModelRequest(sprintf(endpoints.getVendors, [subsidiary]),
          body: content.toJson());
      final api = await client.postNew(
        request,
        (data) => data,
      );
      if (api is! DioException) {
        return ApiResult.success(
            data: List<VendorResponse>.from(
                api.map((x) => VendorResponse.fromJson(x))));
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
  Future<ApiResult> updateStaff(
      {required StaffUpdateRequest content, required String subsidiary}) async {
    try {
      final request = ModelRequest(sprintf(endpoints.updateStaff, [subsidiary]),
          body: content.toJson());
      final api = await client.postNew(
        request,
        (data) => data,
      );
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
