class GetUnlocRes {
  List<GetUnlocResult>? lstUnlocResult;

  GetUnlocRes({this.lstUnlocResult});

  GetUnlocRes.fromJson(Map<String, dynamic> json) {
    if (json['GetUnlocResult'] != null) {
      lstUnlocResult = <GetUnlocResult>[];
      json['GetUnlocResult'].forEach((v) {
        lstUnlocResult!.add(GetUnlocResult.fromJson(v));
      });
    }
  }
}

class GetUnlocResult {
  String? placeName;
  String? unlocCode;

  GetUnlocResult({this.placeName, this.unlocCode});

  GetUnlocResult.fromJson(Map<String, dynamic> json) {
    placeName = json['PlaceName'];
    unlocCode = json['UnlocCode'];
  }
}
