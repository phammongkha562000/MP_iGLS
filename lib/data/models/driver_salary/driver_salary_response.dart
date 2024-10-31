class DriverSalaryResponse {
  DriverSalaryResponse({
    this.success,
    this.payload,
    this.error,
  });

  bool? success;
  List<DriverSalaryPayload>? payload;
  DriverSalaryError? error;

  factory DriverSalaryResponse.fromMap(Map<String, dynamic> json) =>
      DriverSalaryResponse(
        success: json["success"],
        payload: List<DriverSalaryPayload>.from(
            json["payload"].map((x) => DriverSalaryPayload.fromMap(x))),
        error: DriverSalaryError.fromMap(json["error"]),
      );
}

class DriverSalaryError {
  DriverSalaryError({
    this.errorCode,
    this.errorMessage,
  });

  dynamic errorCode;
  dynamic errorMessage;

  factory DriverSalaryError.fromMap(Map<String, dynamic> json) =>
      DriverSalaryError(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );
}

class DriverSalaryPayload {
  DriverSalaryPayload({
    this.yyyymm,
    this.pdfPayslip,
    this.pdfTaskDetail,
  });

  String? yyyymm;
  String? pdfPayslip;
  String? pdfTaskDetail;

  factory DriverSalaryPayload.fromMap(Map<String, dynamic> json) =>
      DriverSalaryPayload(
        yyyymm: json["yyyymm"],
        pdfPayslip: json["pdfPayslip"],
        pdfTaskDetail: json["pdfTaskDetail"],
      );
}
