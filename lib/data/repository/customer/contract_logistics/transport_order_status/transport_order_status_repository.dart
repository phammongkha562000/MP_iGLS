import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_notify_order_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_notify_order_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_save_notify_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_detail_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_detail_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_res.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:sprintf/sprintf.dart';
import '../../../../services/result/api_result.dart';
import '../../../../services/services.dart';

abstract class AbstractCustomerTOSRepository implements AbstractRepository {
  Future<ApiResult> getCompany(
      {required CustomerCompanyReq content, required String subsidiaryId});

  Future<ApiResult> getTOS(
      {required CustomerTOSReq content, required String subsidiaryId});
  Future<ApiResult> getTOSDetail(
      {required CustomerTOSDetailReq content,
      required String subsidiaryId,
      required String contactCode});

  Future<ApiResult> getNotifyOrder({
    required CustomerNotifyOrderReq content,
    required String subsidiaryId,
  });

  Future<ApiResult> saveNotifyOrder({
    required CustomerSaveNotifyReq content,
    required String subsidiaryId,
  });

  Future<ApiResult> deleteNotifyOrder({
    required String tripNo,
    required String orderId,
    required String userId,
    required String subsidiaryId,
  });
}

@injectable
class CustomerTOSRepository implements AbstractCustomerTOSRepository {
  AbstractDioHttpClient client;
  CustomerTOSRepository({required this.client});

  @override
  Future<ApiResult> getCompany(
      {required CustomerCompanyReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerCompany, [subsidiaryId]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerCompanyRes>.from(
                api.map((x) => CustomerCompanyRes.fromJson(x))));
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
  Future<ApiResult> getTOS(
      {required CustomerTOSReq content, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerTOS, [subsidiaryId]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerTOSRes>.from(
                api.map((x) => CustomerTOSRes.fromJson(x))));
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
  Future<ApiResult> getTOSDetail(
      {required CustomerTOSDetailReq content,
      required String subsidiaryId,
      required String contactCode}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerTOSDetail, [subsidiaryId, contactCode]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: CustomerTOSDetailRes.fromJson(api));
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
  Future<ApiResult> getNotifyOrder(
      {required CustomerNotifyOrderReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerNotifyOrder, [subsidiaryId]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(data: CustomerNotifyOrderRes.fromJson(api));
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
  Future<ApiResult> saveNotifyOrder(
      {required CustomerSaveNotifyReq content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerSaveNotifyOrder, [subsidiaryId]),
          body: content.toJson());
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
  Future<ApiResult> deleteNotifyOrder(
      {required String tripNo,
      required String orderId,
      required String userId,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.customerDeleteNotifyOrder,
            [tripNo, orderId, userId, subsidiaryId]),
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
