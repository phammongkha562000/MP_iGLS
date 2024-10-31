import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/ha_transaction_report/transaction_request.dart';
import 'package:igls_new/data/models/freight_fowarding/ha_transaction_report/transaction_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../services/result/api_result.dart';

abstract class AbstractTransactionReportRepository
    implements AbstractRepository {
  Future<ApiResult> getTransactionReport(
      {required TransactionReportRequest content,
      required String subsidiaryId});
}

@injectable
class TransactionReportRepository
    implements AbstractTransactionReportRepository {
  AbstractDioHttpClient client;
  TransactionReportRepository({required this.client});

  @override
  Future<ApiResult> getTransactionReport(
      {required TransactionReportRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getTransactionReport,
            [subsidiaryId],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: TransactionReportResponse.fromJson(api));
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
