import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/common/api_response.dart';
import 'package:igls_new/data/models/customer/customer_profile/subsidiary_res.dart';
import 'package:igls_new/data/models/customer/login/customer_login_req.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/home/menu_request.dart';
import 'package:igls_new/data/models/login/announcement_response.dart';
import 'package:igls_new/data/models/login/announcement_update_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/login/get_contact.response.dart';
import 'package:igls_new/data/models/login/menu_response.dart';
import 'package:igls_new/data/models/login/refresh_token_req.dart';
import 'package:igls_new/data/models/register/data_register.dart';
import 'package:igls_new/data/models/user_profile/staff_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:location/location.dart';
import 'package:sprintf/sprintf.dart';

abstract class AbstractLoginRepository implements AbstractRepository {
  Future<ApiResult> login(
      {required DataLoginRequestModel dataLogin, required String baseUrl});
  Future<ApiResult> loginCustomer(
      {required CustomerLoginReq content, required String baseUrl});
  Future<ApiResult> getMenu({required MenuRequest menu});
  Future register(
      {required DataRegister dataRegister, required String baseUrl});

  Future<ApiResult> getContactToFormat({
    required String contactCode,
    required String subsidiaryId,
  });
  Future<ApiResult> getStaffDetail({
    required String empCode,
    required String subsidiaryId,
  });
  Future<ApiResult> getAnnouncements(
      {required String userId,
      required String branchCode,
      required String dcCode,
      required String subsidiaryId,
      required String baseUrl});
  Future<AnnouncementResponse> getDetailAnnouncement(
      {required int annId, required String subsidiaryId});
  Future<StatusResponse> saveUpdateAnnouncement(
      {required AnnouncementUpdateRequest content,
      required String subsidiaryId});

  Future initLocation();

  Future<ApiResult> refreshToken({required RefreshTokenReq content});
  Future<ApiResult<SubsidiaryRes>> getSubsidiary(
      {required String subsidiaryId});
}

@injectable
class LoginRepository implements AbstractLoginRepository {
  AbstractDioHttpClient client;
  LoginRepository({required this.client});

  @override
  Future<bool> initLocation() async {
    var location = Location();
    // * Kiểm tra dịch vụ định vị có bật không -> true Có -> false không
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<ApiResult> login(
      {required DataLoginRequestModel dataLogin,
      required String baseUrl}) async {
    try {
      DataLoginRequestModel loginRequestModel = dataLogin;

      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      final request = ModelRequest(endpoints.authen,
          parameters: null, body: loginRequestModel.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: LoginResponse.fromJson(api));
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
  Future register(
      {required DataRegister dataRegister, required String baseUrl}) async {
    DataRegister registerRequest = dataRegister;
    getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

    final request = RegisterRequest(endpoints.register,
        parameters: null, body: registerRequest.toJson());
    return await client.post<LoginResponse>(
        request, (data) => LoginResponse.fromJson(data));
  }

  @override
  Future<ApiResult> getMenu({required MenuRequest menu}) async {
    try {
      final request = ModelRequest(
          sprintf(
              endpoints.menuHome, [menu.uid, menu.systemId, menu.subsidiaryId]),
          body: menu.toJson());
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<PageMenuPermissions>.from(
                api.map((x) => PageMenuPermissions.fromJson(x))));
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
  Future<ApiResult> getContactToFormat({
    required String contactCode,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getContactFormatNumber, [contactCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<ContactResponse>.from(
                api.map((x) => ContactResponse.fromMap(x))));
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
  Future<ApiResult> getStaffDetail({
    required String empCode,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getStaffDetail, [empCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: StaffResponse.fromMap(api));
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
  Future<ApiResult> getAnnouncements(
      {required String userId,
      required String branchCode,
      required String dcCode,
      required String subsidiaryId,
      required String baseUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));

      final request = ModelRequest(
        sprintf(endpoints.getAnnouncementsForMobile,
            [userId, branchCode, dcCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<AnnouncementResponse>.from(
                api.map((x) => AnnouncementResponse.fromJson(x))));
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
  Future<AnnouncementResponse> getDetailAnnouncement(
      {required int annId, required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(endpoints.getDetailAnnouncementForMobile, [annId, subsidiaryId]),
    );
    return await client.get<AnnouncementResponse>(
        request, (data) => AnnouncementResponse.fromJson(data));
  }

  @override
  Future<StatusResponse> saveUpdateAnnouncement(
      {required AnnouncementUpdateRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(endpoints.saveAnnouncementEndorse, [subsidiaryId]),
        body: content.toMap());
    return await client.post<StatusResponse>(
        request, (data) => StatusResponse.fromJson(data));
  }

  @override
  Future<ApiResult> refreshToken({required RefreshTokenReq content}) async {
    final request = ModelRequest(endpoints.revokeToken, body: content.toJson());
    final api = await client.postNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(data: LoginResponse.fromJson(api));
    } else {
      return ApiResult.fail(
          error: api,
          errorCode: api.response == null
              ? constants.errorNoConnect
              : api.response!.statusCode!);
    }
  }

  @override
  Future<ApiResult> loginCustomer(
      {required CustomerLoginReq content, required String baseUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      final request = ModelRequest(endpoints.customerLogin,
          parameters: null, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: LoginResponse.fromJson(api));
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
  Future<ApiResult<SubsidiaryRes>> getSubsidiary(
      {required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerSubsidiary, [subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: SubsidiaryRes.fromJson(api));
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
