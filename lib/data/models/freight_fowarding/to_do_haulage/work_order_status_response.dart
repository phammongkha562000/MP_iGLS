class StatusResponse {
  StatusResponse({
    this.isSuccess,
    this.message,
    this.valueReturn,
  });

  bool? isSuccess;
  dynamic message;
  String? valueReturn;

  factory StatusResponse.fromJson(Map<String, dynamic> json) => StatusResponse(
        isSuccess: json["IsSuccess"],
        message: json["Message"],
        valueReturn: json["ValueReturn"],
      );
}
