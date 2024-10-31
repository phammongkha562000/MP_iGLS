import 'package:dio/dio.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_cntr_haulage_res.dart';
import 'package:igls_new/data/models/freight_fowarding/freight_fowarding.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../base/abstract_repository.dart';
import '../../../../models/customer/global_visibility/cntr_haulage/get_cntr_haulage_req.dart';
import '../../../../models/customer/global_visibility/cntr_haulage/get_detail_cntr_haulage_res.dart';
import '../../../../models/customer/global_visibility/cntr_haulage/get_notify_cntr_res.dart';
import '../../../../models/customer/global_visibility/cntr_haulage/save_notify_setting_req.dart';
import '../../../../models/login/data_login_request.dart';
import '../../../../services/network/client.dart';
import '../../../../services/result/api_result.dart';

abstract class AbstractCntrHaulageRepository implements AbstractRepository {
  Future<ApiResult> getCntrHaulage(
      {required GetCntrHaulageReq model, required String strCompany});
  Future<ApiResult<GetDetailCntrHaulageRes>> getDetailCntrHaulage(
      {required String woNo,
      required String woItemNo,
      required String subsidiaryId});
  Future<ApiResult<GetNotifyCntrRes>> getNotifyCntr(
      {required String woNo,
      required String woItemNo,
      required String subsidiaryId});
  Future<ApiResult> saveNotifySetting(
      {required SaveNotifySettingReq model, required String subsidiaryId});
  Future<ApiResult> delNotifySetting(
      {required String woNo,
      required String userId,
      required int itemNo,
      required String subsidiaryId});
}

@injectable
class CntrHaulageRepository implements AbstractCntrHaulageRepository {
  AbstractDioHttpClient client;
  CntrHaulageRepository({required this.client});
  @override
  Future<ApiResult> getCntrHaulage(
      {required GetCntrHaulageReq model, required String strCompany}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerGetCntrHaulage, [strCompany]),
          body: model.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<GetCntrHaulageRes>.from(
                api.map((x) => GetCntrHaulageRes.fromJson(x))));
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
  Future<ApiResult<GetDetailCntrHaulageRes>> getDetailCntrHaulage(
      {required String woNo,
      required String woItemNo,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerGetDetailCntrHaulage,
            [woNo, woItemNo, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: GetDetailCntrHaulageRes.fromJson(api));
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
  Future<ApiResult<GetNotifyCntrRes>> getNotifyCntr(
      {required String woNo,
      required String woItemNo,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerGetNotifyCntr, [subsidiaryId]),
        body: {"ItemNo": woItemNo, "WONo": woNo},
      );
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: GetNotifyCntrRes.fromJson(api));
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
  Future<ApiResult> saveNotifySetting(
      {required SaveNotifySettingReq model,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerSaveNotifySetting, [subsidiaryId]),
        body: model.toJson(),
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
  Future<ApiResult> delNotifySetting(
      {required String woNo,
      required String userId,
      required int itemNo,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerDelNotifySetting,
            [woNo, itemNo, userId, subsidiaryId]),
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
}
