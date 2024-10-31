import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:igls_new/data/models/mpi/common/work_flow_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_response.dart';

import '../../models/mpi/leave/leaves/leaves.dart';

class MPiApiResponse {
  MPiApiResponse({
    required this.success,
    this.payload,
    required this.error,
  });

  bool success;
  dynamic payload;
  Error error;

  factory MPiApiResponse.fromJson(Map<String, dynamic> json,
          {required String endpoint}) =>
      MPiApiResponse(
        success: json["success"],
        payload: fromJson(endpoint, json),
        error: Error.fromJson(json["error"]),
      );
}

class Error {
  Error({
    this.errorCode,
    this.errorMessage,
  });

  dynamic errorCode;
  dynamic errorMessage;

  Error copyWith({
    dynamic errorCode,
    dynamic errorMessage,
  }) =>
      Error(
        errorCode: errorCode ?? this.errorCode,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };
}

dynamic fromJson(String endpoint, Map<String, dynamic> json) {
  switch (endpoint) {
    //endpoint nào thì map về model đó
    case endpoints.getTimeSheetService:
      return json['payload'] == null
          ? null
          : TimesheetResponse.fromJson(json["payload"]);

    case endpoints.postCheckInOut:
      return json["payload"];
    case endpoints.getLeave:
      return json["payload"] == null
          ? null
          : LeavePayload.fromJson(json["payload"]);
    case endpoints.getLeaveDetail:
      return json["payload"] == null
          ? null
          : LeaveDetailPayload.fromJson(json["payload"]);

    case endpoints.getWorkFlow:
      return json["payload"] == null
          ? null
          : List<WorkFlowResponse>.from(
              json["payload"].map((x) => WorkFlowResponse.fromJson(x)));

    case endpoints.createNewLeave:
      return json["payload"];
    case endpoints.checkLeaveWithType:
      return json["payload"] == null
          ? null
          : CheckLeaveResponse.fromJson(json["payload"]);

    default:
      return null;
  }
}
