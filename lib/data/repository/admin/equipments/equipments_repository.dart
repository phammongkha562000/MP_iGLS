import 'package:dio/dio.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_detail_response.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_type_response.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_update_request.dart';
import 'package:igls_new/data/models/equipments_admin/equipments_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../base/base.dart';
import '../../../models/equipments_admin/equipments_request.dart';
import '../../../services/services.dart';

abstract class AbstractEquipmentsRepository implements AbstractRepository {
  Future<ApiResult> getEquipments(
      {required String subsidiary, required EquipmentsRequest content});
  Future<ApiResult> getEquipmentDetail(
      {required String subsidiary, required String equipmentCode});
  Future<ApiResult> updateEquipment(
      {required String subsidiary, required EquipmentUpdateRequest content});
  Future<ApiResult> getEquipmentType(
      {required String subsidiary,
      required String strEquipTypeNo,
      required String strEquipTypeDesc});
}

@injectable
class EquipmentsRepository implements AbstractEquipmentsRepository {
  AbstractDioHttpClient client;
  EquipmentsRepository({required this.client});

  @override
  Future<ApiResult> getEquipments(
      {required String subsidiary, required EquipmentsRequest content}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getEquipmentsAdmin,
            [subsidiary],
          ),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<EquipmentsResponse>.from(
                api.map((x) => EquipmentsResponse.fromJson(x))));
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
  Future<ApiResult> getEquipmentDetail(
      {required String subsidiary, required String equipmentCode}) async {
    try {
      final request = ModelRequest(
        sprintf(
          endpoints.getEquipmentDetailAdmin,
          [equipmentCode, subsidiary],
        ),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: EquipmentDetailResponse.fromJson(api));
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
  Future<ApiResult> updateEquipment(
      {required String subsidiary,
      required EquipmentUpdateRequest content}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.updateEquipment,
            [subsidiary],
          ),
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
  Future<ApiResult> getEquipmentType(
      {required String subsidiary,
      required String strEquipTypeNo,
      required String strEquipTypeDesc}) async {
    try {
      final request = ModelRequest(
        sprintf(
          endpoints.getEquipmentType,
          [strEquipTypeNo, strEquipTypeDesc, subsidiary],
        ),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<EquipmentTypeResponse>.from(
                api.map((x) => EquipmentTypeResponse.fromJson(x))));
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
