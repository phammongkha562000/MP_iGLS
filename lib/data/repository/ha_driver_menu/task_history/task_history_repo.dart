// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/check_equipment/check_equipment_request.dart';
import 'package:igls_new/data/models/equipment/equipment_request.dart';
import 'package:igls_new/data/models/equipment/equipment_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/ha_driver_menu/task_history/task_history_detail_item_response.dart';
import 'package:igls_new/data/models/ha_driver_menu/task_history/task_history_detail_response.dart';
import 'package:igls_new/data/models/ha_driver_menu/task_history/task_history_request.dart';
import 'package:igls_new/data/models/ha_driver_menu/task_history/update_time/update_time_request.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';

abstract class AbstracTaskHistoryRepository implements AbstractRepository {
  Future<ApiResult> getTaskHistory(
      {required TaskHistoryRequest content, required String subsidiaryId});
  Future<ApiResult> getHistoryDetail(
      {required int id, required String subsidiaryId});
  Future<ApiResult> getHistoryDetailItem(
      {required int dtdId, required String subsidiaryId});
  Future<ApiResult> updateWordOrderWithDataType({
    required UpdateWorkOrderRequest updateWorkOrderRequest,
    required String subsidiaryId,
  });
  Future<ApiResult> checkEquipment({
    required CheckEquipmentsRequest equipmentsRequest,
    required String subsidiaryId,
  });
  Future<ApiResult> getEquipment(
      {required EquipmentRequest content, required String subsidiaryId});
  Future<ApiResult> getEquipment3(
      {required content, required String subsidiaryId});
}

@injectable
class TaskHistoryRepository implements AbstracTaskHistoryRepository {
  AbstractDioHttpClient client;
  TaskHistoryRepository({required this.client});

  @override
  Future<ApiResult> getTaskHistory(
      {required TaskHistoryRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getTaskHistory, [subsidiaryId]),
        body: content.toJson(),
      );

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: endpoints.getTaskHistory));
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
  Future<ApiResult> getHistoryDetail(
      {required int id, required String subsidiaryId}) async {
    try {
      final request =
          ModelRequest(sprintf(endpoints.getHistoryDetail, [id, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: HistoryDetail.fromMap(api));
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
  Future<ApiResult> getHistoryDetailItem(
      {required int dtdId, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getHistoryDetailItem, [dtdId, subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: HistoryDetailItem.fromMap(api));
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
  Future<ApiResult> updateWordOrderWithDataType({
    required UpdateWorkOrderRequest updateWorkOrderRequest,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.updateTimeWithDetailItem, [subsidiaryId]),
        body: updateWorkOrderRequest.toMap(),
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
  Future<ApiResult> checkEquipment({
    required CheckEquipmentsRequest equipmentsRequest,
    required String subsidiaryId,
  }) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.checkEquipment, [subsidiaryId]),
        body: equipmentsRequest.toMap(),
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
  Future<ApiResult> getEquipment(
      {required content, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getEquipment,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<EquipmentResponse>.from(
                api.map((x) => EquipmentResponse.fromMap(x))));
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
  Future<ApiResult> getEquipment3(
      {required content, required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.getEquipment3,
            [subsidiaryId],
          ),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: List<EquipmentResponse>.from(
                api.map((x) => EquipmentResponse.fromMap(x))));
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
