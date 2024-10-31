class UpdateCusProfileRes {
  dynamic error;
  int? payload;
  bool? success;

  UpdateCusProfileRes({this.error, this.payload, this.success});

  UpdateCusProfileRes.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    payload = json['payload'];
    success = json['success'];
  }

  
}
