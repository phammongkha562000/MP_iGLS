
class LoginResponse {
  LoginResponse({
    this.error,
    this.payload,
    this.success,
  });

  dynamic error;
  String? payload;
  bool? success;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        payload: json["payload"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "payload": payload,
        "success": success,
      };
}
