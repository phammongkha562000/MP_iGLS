import 'package:dio/dio.dart';
import 'package:igls_new/data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/track_and_trace/track_and_trace_status_res.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../base/abstract_repository.dart';
import '../../../../models/customer/global_visibility/track_and_trace/get_track_and_trace_req.dart';
import '../../../../models/login/data_login_request.dart';
import '../../../../services/network/client.dart';
import '../../../../services/result/api_result.dart';

abstract class AbstractTrackAndTraceRepository implements AbstractRepository {
  Future<ApiResult> getTrackAndTraceStatus(
      {required String updateBased, required String strCompany});
  Future<ApiResult<GetUnlocRes>> getUnloc({required String unLocCode});
  Future<ApiResult> getTrackAndTrace(
      {required GetTrackAndTraceReq model, required String strCompany});
}

@injectable
class TrackAndTraceRepository implements AbstractTrackAndTraceRepository {
  AbstractDioHttpClient client;
  TrackAndTraceRepository({required this.client});
  @override
  Future<ApiResult> getTrackAndTraceStatus(
      {required String updateBased, required String strCompany}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerTrackTraceStatus, [updateBased, strCompany]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<TrackAndTraceStatusRes>.from(
                api.map((x) => TrackAndTraceStatusRes.fromJson(x))));
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
  Future<ApiResult<GetUnlocRes>> getUnloc({required String unLocCode}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerGetUnloc, [unLocCode]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: GetUnlocRes.fromJson(api));
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
  Future<ApiResult> getTrackAndTrace(
      {required GetTrackAndTraceReq model, required String strCompany}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerGetTrackAndTrace, [strCompany]),
          body: model.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<TrackAndTraceStatusRes>.from(
                api.map((x) => TrackAndTraceStatusRes.fromJson(x))));
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
