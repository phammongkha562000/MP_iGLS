import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/data/models/models.dart';
import 'package:igls_new/data/models/mpi/common/mpi_std_code_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/clock_in_out/wifi_response.dart';

class ApiResponse {
  ApiError? error;
  dynamic payload;
  bool? success;

  ApiResponse({
    this.error,
    this.payload,
    this.success,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json,
          {required String endpoint}) =>
      ApiResponse(
        error: json["error"] == null ? null : ApiError.fromJson(json["error"]),
        payload: fromJson(endpoint, json),
        success: json["success"],
      );
}

class ApiError {
  dynamic detail;
  dynamic errorCode;
  dynamic message;

  ApiError({
    this.detail,
    this.errorCode,
    this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        detail: json["Detail"],
        errorCode: json["ErrorCode"],
        message: json["Message"],
      );
}

dynamic fromJson(String endpoint, Map<String, dynamic> json) {
  switch (endpoint) {
    //endpoint nào thì map về model đó
    case endpoints.getHaulageTodoList:
      return json['payload'] == null
          ? null
          : TodoHaulageResponse.fromJson(json["payload"]);
    case endpoints.getHistoryTodo:
      return json['payload'] == null
          ? null
          : HistoryTodoResponse.fromMap(json["payload"]);
    case endpoints.getBulkCostApproval:
      return json['payload'] == null
          ? null
          : CashCostApprovalResponse.fromJson(json['payload']);
    case endpoints.getRelocation:
      return json['payload'] == null
          ? null
          : RelocationResponse.fromJson(json['payload']);
    case endpoints.getTripTodo:
      return json['payload'] == null
          ? null
          : TodoResponse.fromJson(json['payload']);
    case endpoints.getTaskHistory:
      return json['payload'] == null
          ? null
          : TaskHistoryResponse.fromMap(json['payload']);
    case endpoints.getOrdersForInboundImage:
      return json['payload'] == null
          ? null
          : InboundPhotoResponse.fromMap(json['payload']);

    case endpoints.getcoworklocs:
      return json['payload'] == null
          ? null
          : List<WifiResponse>.from(
              json["payload"].map((x) => WifiResponse.fromJson(x)));

    case endpoints.mpiGetStdcode:
      return json['payload'] == null
          ? null
          : List<MPiStdCode>.from(
              json["payload"].map((x) => MPiStdCode.fromJson(x)));
    case endpoints.postCheckInOut:
      return json['payload'];
    default:
      return null;
  }
}
