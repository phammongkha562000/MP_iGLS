import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/setting/change_pass/change_pass_request.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/models/user_profile/user_profile_request.dart';
import 'package:igls_new/data/services/network/client.dart';

import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/config/serverconfig.dart';
import '../../models/config/server_infor.dart';
import '../../models/notification/firebase_noti_model.dart';
import '../../shared/preference/share_pref_service.dart';

abstract class AbstractUserProfileRepository implements AbstractRepository {
  Future<ApiResult> getLocal({
    required String userId,
    required String subsidiaryId,
  });
  Future<ApiResult> updateUserProfile(
      {required UpdateUserProfileRequest content,
      required String subsidiaryId});
  Future<StatusResponse> changePass(
      {required ChangePassRequest content, required String subsidiaryId});
  Future<ApiResult> getContact({
    required String userId,
    required String subsidiaryId,
  });
  Future<ApiResult> loginToHub({
    required NotificationsModel model,
  });
  Future<ApiResult> logoutFromHub({
    required NotificationsModel model,
  });
  // Future<StaffResponse> getStaffDetail({
  //   required String empCode,
  //   required String subsidiaryId,
  // });
}

@injectable
class UserProfileRepository implements AbstractUserProfileRepository {
  AbstractDioHttpClient client;
  UserProfileRepository({required this.client});

  @override
  Future<ApiResult> getLocal({
    required String userId,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(
            endpoints.getLocalPermissionForUserProfile, [userId, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: LocalRespone.fromJson(api));
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
  Future<ApiResult> updateUserProfile(
      {required UpdateUserProfileRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.updateUserProfile, [subsidiaryId]),
        body: content.toMap(),
      );
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
  Future<StatusResponse> changePass(
      {required ChangePassRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(endpoints.changePass, [subsidiaryId]),
      body: content.toMap(),
    );
    return await client.post(request, (data) => StatusResponse.fromJson(data));
  }

  @override
  Future<ApiResult> getContact(
      {required String userId, required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(endpoints.getContactByUserId, [subsidiaryId, userId]),
    );
    try {
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
  Future<ApiResult> loginToHub({
    required NotificationsModel model,
  }) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverCode);
      String startUrl = serverInfo.serverHub.toString();
      BaseOptions options = BaseOptions(
          baseUrl: "$startUrl${endpoints.loginHub}",
          method: "POST",
          connectTimeout: const Duration(minutes: 1));
      Dio dio = Dio(options);
      String path = "$startUrl${endpoints.loginHub}";
      final loginToHub = await dio.post(
        path,
        data: model,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (loginToHub.statusCode == 200) {
        return ApiResult.success(
          data: "",
        );
      } else {
        return ApiResult.fail(
            error: loginToHub, errorCode: loginToHub.statusCode ?? 0);
      }
    } catch (e) {
      return ApiResult.fail(
        error: e,
        errorCode: 0,
      );
    }
  }

  @override
  Future<ApiResult> logoutFromHub({
    required NotificationsModel model,
  }) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverCode);
      String startUrl = serverInfo.serverHub.toString();
      BaseOptions options = BaseOptions(
        baseUrl: "$startUrl${endpoints.logoutHub}",
        method: "POST",
      );
      Dio dio = Dio(options);
      String path = "$startUrl${endpoints.logoutHub}";
      final loginToHub = await dio.post(
        path,
        data: model,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (loginToHub.statusCode == 200) {
        return ApiResult.success(
          data: "",
        );
      } else {
        return ApiResult.fail(
            error: loginToHub, errorCode: loginToHub.statusCode ?? 0);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
}
