class GetTimeLineRes {
  dynamic error;
  String? payload;
  bool? success;

  GetTimeLineRes({this.error, this.payload, this.success});

  GetTimeLineRes.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    payload = json['payload'];
    success = json['success'];
  }
}
