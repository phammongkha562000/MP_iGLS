class OrderResponse {
  OrderResponse({
    this.eta,
    this.iOrdId,
    this.iOrdType,
    this.orderNo,
    this.qty,
  });

  dynamic eta;
  int? iOrdId;
  dynamic iOrdType;
  String? orderNo;
  double? qty;

  factory OrderResponse.fromMap(Map<String, dynamic> json) => OrderResponse(
        eta: json["ETA"],
        iOrdId: json["IOrdID"],
        iOrdType: json["IOrdType"],
        orderNo: json["OrderNo"],
        qty: double.parse(json["Qty"].toString()),
      );
}

class InboundPhotoResponse {
  InboundPhotoResponse({this.totalCount, this.totalPage, this.results});

  List<InboundPhotoResult>? results;
  int? totalCount;
  int? totalPage;

  factory InboundPhotoResponse.fromMap(Map<String, dynamic> json) =>
      InboundPhotoResponse(
        results: json["Results"] == null
            ? []
            : List<InboundPhotoResult>.from(
                json["Results"].map((x) => InboundPhotoResult.fromMap(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );
}

class InboundPhotoResult {
  InboundPhotoResult({
    this.eta,
    this.iOrdId,
    this.iOrdType,
    this.orderNo,
    this.qty,
  });

  dynamic eta;
  int? iOrdId;
  dynamic iOrdType;
  String? orderNo;
  double? qty;

  factory InboundPhotoResult.fromMap(Map<String, dynamic> json) =>
      InboundPhotoResult(
        eta: json["ETA"],
        iOrdId: json["IOrdID"],
        iOrdType: json["IOrdType"],
        orderNo: json["OrderNo"],
        qty: double.parse(json["Qty"].toString()),
      );
}
