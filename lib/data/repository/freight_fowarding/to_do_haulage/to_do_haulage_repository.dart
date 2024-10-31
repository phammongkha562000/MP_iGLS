import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/container_seal_no_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/document_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/image_todohaulage_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/plan_transfer_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/todo_haulage_detail_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/todo_haulage_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/trailer_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/upload_document_entry_response.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_request.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/work_order_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';

import 'package:igls_new/data/services/network/client.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../services/result/result.dart';

abstract class AbstractFreightFowardingRepository
    implements AbstractRepository {
  Future<ApiResult> getListToDoHaulage(
      {required ListToDoHaulageRequest content, required String subsidiaryId});
  Future<ApiResult> getToDoHaulageDetail(
      {required int woTaskId, required String subsidiaryId});
  Future<ApiResult> updateWorkOrderStatus(
      {required WorkOrderStatusRequest content, required String subsidiaryId});
  Future<ApiResult> updateTrailer(
      {required UpdateTrailerRequest content, required String subsidiaryId});
  Future<ApiResult> getUpdateNote(
      {required WorkTaskUpdateNoteRequest content,
      required String subsidiaryId});
  Future<ApiResult> updateContainerSealNo(
      {required ContainerAndSealNoRequest content,
      required String subsidiaryId});
  Future<ApiResult> getUploadImage(
      {required String refNoValue,
      required String refNoType,
      required String docRefType,
      required String subsidiaryId});
  Future<ApiResult> updateUploadDocumentEntry(
      {required UploadDocumentEntryRequest content,
      required String subsidiaryId});
  Future<StatusResponse> getUpdateTransfer(
      {required PlanTransferRequest content, required String subsidiaryId});
  Future<List<ImageTodoHaulageResponse>> getImageTodoHaulage(
      {required String refNoValue,
      required String docRefType,
      required String refNoType,
      required String subsidiaryId});
}

@injectable
class ToDoHaulageRepository implements AbstractFreightFowardingRepository {
  AbstractDioHttpClient client;
  ToDoHaulageRepository({required this.client});

  @override
  Future<ApiResult> getListToDoHaulage(
      {required ListToDoHaulageRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.getHaulageTodoList, [subsidiaryId]),
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: endpoints
                    .getHaulageTodoList) /*  TodoHaulageResponse.fromJson(api) */);
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
  Future<ApiResult> getToDoHaulageDetail(
      {required int woTaskId, required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(endpoints.getHaulageTodoByIdForMobile, [woTaskId, subsidiaryId]),
    );
    try {
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(data: HaulageToDoDetail.fromMap(api));
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
  Future<ApiResult> updateWorkOrderStatus(
      {required WorkOrderStatusRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateWorkOrderStatus, [subsidiaryId]),
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

  @override
  Future<ApiResult> updateTrailer(
      {required UpdateTrailerRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateWorkOrderTrailer, [subsidiaryId]),
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

  @override
  Future<ApiResult> getUpdateNote(
      {required WorkTaskUpdateNoteRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateWOEquipTaskDriverMemo, [subsidiaryId]),
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

  @override
  Future<ApiResult> updateContainerSealNo(
      {required ContainerAndSealNoRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.updateContainerAndSealNo, [subsidiaryId]),
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

  @override
  Future<ApiResult> getUploadImage(
      {required String refNoValue,
      required String refNoType,
      required String docRefType,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
        sprintf(endpoints.getUploadedDocuments,
            [refNoValue, docRefType, refNoType, subsidiaryId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                List<DocumentDTO>.from(api.map((x) => DocumentDTO.fromMap(x))));
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
  Future<ApiResult> updateUploadDocumentEntry(
      {required UploadDocumentEntryRequest content,
      required String subsidiaryId}) async {
    try {
      final request = ModelRequest(
          sprintf(
            endpoints.uploadDocument,
            [subsidiaryId],
          ),
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

  @override
  Future<StatusResponse> getUpdateTransfer(
      {required PlanTransferRequest content,
      required String subsidiaryId}) async {
    final request = ModelRequest(
        sprintf(
          endpoints.updateWorkOrderEquipAssignTask,
          [subsidiaryId],
        ),
        body: content.toMap());
    return await client.post<StatusResponse>(
        request, (data) => StatusResponse.fromJson(data));
  }

//DocRefType=OT&RefNoType=EQ
  @override
  Future<List<ImageTodoHaulageResponse>> getImageTodoHaulage(
      {required String refNoValue,
      required String docRefType,
      required String refNoType,
      required String subsidiaryId}) async {
    final request = ModelRequest(
      sprintf(
        endpoints.getImageTodoHaulage,
        [refNoValue, docRefType, refNoType, subsidiaryId],
      ),
    );
    return await client.get<List<ImageTodoHaulageResponse>>(
        request,
        (data) => List<ImageTodoHaulageResponse>.from(
            data.map((x) => ImageTodoHaulageResponse.fromJson(x))));
  }
}
