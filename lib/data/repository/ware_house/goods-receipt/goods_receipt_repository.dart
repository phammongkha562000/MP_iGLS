import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/std_code/std_code_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/models/ware_house/goods_receipt/good_receipt_order_response.dart';
import 'package:igls_new/data/models/ware_house/goods_receipt/goods_receipt_save_request.dart';
import 'package:igls_new/data/models/ware_house/goods_receipt/sku_response.dart';
import 'package:igls_new/data/models/ware_house/inbound_photo/order_request.dart';
import 'package:igls_new/data/models/ware_house/inbound_photo/order_response.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

abstract class AbstractGoodsReceiptRepository implements AbstractRepository {
  Future<ApiResult> getGoodsReceipt(
      {required OrderInboundPhotoRequest content});
  Future<ApiResult> getGoodsReceiptDetail(
      {required OrderInboundPhotoRequest content});

  Future<ApiResult> getContact({
    required String stdCodeType,
    required String codeVariant,
    required String contactCode,
    required String subsidiaryId,
  });
  Future<ApiResult> getSku({required int iOrderNo, required String companyId});
  Future<ApiResult> getSaveGoodsRecepit(
      {required GoodsReceiptSaveRequest content, required String subsidiaryId});
}

@injectable
class GoodsReceiptRepository implements AbstractGoodsReceiptRepository {
  AbstractDioHttpClient client;
  GoodsReceiptRepository({required this.client});

  @override
  Future<ApiResult> getGoodsReceipt(
      {required OrderInboundPhotoRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getOrdersForGR, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<OrderResponse>.from(
                api.map((x) => OrderResponse.fromMap(x))));
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
  Future<ApiResult> getGoodsReceiptDetail(
      {required OrderInboundPhotoRequest content}) async {
    try {
      final request =
          ModelRequest(endpoints.getOrderDetailForGR, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: GoodsReceiptResponse.fromJson(api));
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
  Future<ApiResult> getContact(
      {required String stdCodeType,
      required String codeVariant,
      required String contactCode,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getContactStdCode,
            [stdCodeType, codeVariant, contactCode, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<StdCode>.from(api.map((x) => StdCode.fromJson(x))));
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
  Future<ApiResult> getSku(
      {required int iOrderNo, required String companyId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getSku, [iOrderNo, companyId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                List<SkuResponse>.from(api.map((x) => SkuResponse.fromMap(x))));
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
  Future<ApiResult> getSaveGoodsRecepit(
      {required GoodsReceiptSaveRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getSaveGRs, [subsidiaryId]),
          body: content.toMap());
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
