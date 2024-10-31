import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/cash_cost_appoval/cash_cost_approval_save_request.dart';
import 'package:igls_new/data/models/freight_fowarding/cash_cost_appoval/cash_cost_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../services/result/result.dart';

abstract class AbstractCashCostApprovalRepository
    implements AbstractRepository {
  Future<ApiResult> getCashCostApproval(
      {required BulkCostApprovalSearchRequest content,
      required String subsidiaryId});
  Future<StatusResponse> getCashCostApprovalSave(
      {required CashCostApprovalSaveRequest content,
      required String subsidiaryId});
}

@injectable
class CashCostApprovalRepository implements AbstractCashCostApprovalRepository {
  AbstractDioHttpClient client;
  CashCostApprovalRepository({required this.client});

  @override
  Future<ApiResult> getCashCostApproval(
      {required BulkCostApprovalSearchRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getBulkCostApproval,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: endpoints.getBulkCostApproval));
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
  Future<StatusResponse> getCashCostApprovalSave(
      {required CashCostApprovalSaveRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(
          endpoints.getSaveBulkCostApproval,
          [subsidiaryId],
        ),
        body: content.toMap());
    return await client.post<StatusResponse>(
        request, (data) => StatusResponse.fromJson(data));
  }
}
