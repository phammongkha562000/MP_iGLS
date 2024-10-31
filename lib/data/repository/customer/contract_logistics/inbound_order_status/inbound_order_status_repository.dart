import 'package:dio/dio.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../../businesses_logics/config/serverconfig.dart';
import '../../../../base/abstract_repository.dart';
import '../../../../global/global_app.dart';
import '../../../../models/customer/contract_logistics/inbound_order_status/get_inbound_order_req.dart';
import '../../../../models/customer/contract_logistics/inbound_order_status/get_inbound_order_res.dart';
import '../../../../models/customer/contract_logistics/inbound_order_status/get_ios_detail_res.dart';
import '../../../../models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import '../../../../models/models.dart';
import '../../../../services/network/client.dart';
import '../../../../services/result/api_result.dart';
import '../../../../shared/preference/share_pref_service.dart';

abstract class AbstractCustomerIOSRepository implements AbstractRepository {
  Future<ApiResult> getStdCode(
      {required String stdCodeType, required String subsidiaryId});
  Future<ApiResult> getInboundOrder(
      {required GetInboundOrderReq model, required String subsidiaryId});
  Future<ApiResult> getIOSDetail(
      {required String orderid, required String strCompany});
  Future<ApiResult> downLoadFile(
      {required String savePath,
      required String docNo,
      required String strCompany,
      required String fileName});
}

@injectable
class CustomerIOSRepository implements AbstractCustomerIOSRepository {
  AbstractDioHttpClient client;
  CustomerIOSRepository({required this.client});

  @override
  Future<ApiResult> getStdCode(
      {required String stdCodeType, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerStdCode, [stdCodeType, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<GetStdCodeRes>.from(
                api.map((x) => GetStdCodeRes.fromJson(x))));
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
  Future<ApiResult> getInboundOrder(
      {required GetInboundOrderReq model, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerGetInboundOrder, [subsidiaryId]),
          body: model.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<GetInboundOrderRes>.from(
                api.map((x) => GetInboundOrderRes.fromJson(x))));
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
  Future<ApiResult<GetIOSDetailRes>> getIOSDetail(
      {required String orderid, required String strCompany}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerGetIOSDetail, [orderid, strCompany]),
      );
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: GetIOSDetailRes.fromJson(api));
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
  Future<ApiResult> downLoadFile(
      {required String savePath,
      required String docNo,
      required String strCompany,
      required String fileName}) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverCode);
      String startUrl = serverInfo.serverAddress.toString();

      final api = await Dio().download(
          "${startUrl}WP/WPRestFullSvc.svc/DownloadFileStream?docNo=$docNo&strCompany=$strCompany",
          "$savePath/$fileName",
          options: Options(
            method: "GET",
            headers: {
              'Authorization': "Bearer ${globalApp.token}",
              "Content-Type": "application/json"
            },
          ));

      if (api is! DioException) {
        return ApiResult.success(data: true);
      } else {
        return ApiResult.fail(error: false, errorCode: 500);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
}
