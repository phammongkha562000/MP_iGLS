import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/std_code/std_code_2_response.dart';
import 'package:igls_new/data/models/users/user_copy_request.dart';
import 'package:igls_new/data/models/users/user_reset_pwd_request.dart';
import 'package:igls_new/data/models/users/users_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../models/users/user_detail_response.dart';
import '../../../models/users/user_update_request.dart';
import '../../../services/services.dart';

abstract class AbstractUsersRepository implements AbstractRepository {
  Future<ApiResult> getUsers(
      {required String userId,
      required String subsidiary,
      required int isDeleted});
  Future<ApiResult> getStdCode2({required codeGroup});
  Future<ApiResult> getUserDetail({required userId});
  Future<ApiResult> updateUser({required UserDetailUpdateRequest content});
  Future<ApiResult> copyUser({required UserCopyRequest content});
  Future<ApiResult> resetPWDUser({required UserResetPwdRequest content});
  Future<ApiResult> activeUser(
      {required String userId,
      required String updateUser,
      required String subsidiary});
}

@injectable
class UsersRepository implements AbstractUsersRepository {
  AbstractDioHttpClient client;
  UsersRepository({required this.client});

  @override
  Future<ApiResult> getUsers(
      {required String userId,
      required String subsidiary,
      required int isDeleted}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getUsers, [userId, subsidiary, isDeleted]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<UsersResponse>.from(
                api.map((x) => UsersResponse.fromJson(x))));
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
  Future<ApiResult> getStdCode2({required codeGroup}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getStdCode2, [codeGroup]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<StdCode2Response>.from(
                api.map((x) => StdCode2Response.fromJson(x))));
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
  Future<ApiResult> getUserDetail({required userId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getUserDetail, [userId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: UserDetailResponse.fromJson(api));
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
  Future<ApiResult> updateUser(
      {required UserDetailUpdateRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.updateUser, body: content.toJson());
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
  Future<ApiResult> copyUser({required UserCopyRequest content}) async {
    try {
      final request = ModelRequest(endpoints.copyUser, body: content.toJson());
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
  Future<ApiResult> resetPWDUser({required UserResetPwdRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.resetPWDUser, body: content.toJson());
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
  Future<ApiResult> activeUser(
      {required String userId,
      required String updateUser,
      required String subsidiary}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.activeUser, [userId, updateUser, subsidiary]));
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
