class ChangePassRes {
  dynamic error;
  int? payload;
  bool? success;

  ChangePassRes({this.error, this.payload, this.success});

  ChangePassRes.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    payload = json['payload'];
    success = json['success'];
  }
}
