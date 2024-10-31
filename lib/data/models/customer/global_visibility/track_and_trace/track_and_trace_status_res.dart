class TrackAndTraceStatusRes {
  String? statusCode;
  String? statusDesc;
  String? updateBased;

  TrackAndTraceStatusRes({this.statusCode, this.statusDesc, this.updateBased});

  TrackAndTraceStatusRes.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusDesc = json['StatusDesc'];
    updateBased = json['UpdateBased'];
  }
}
