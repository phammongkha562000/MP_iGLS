class OrderTypeRes {
  String? orderType;
  String? orderTypeDesc;
  int? seqNo;

  OrderTypeRes({
    this.orderType,
    this.orderTypeDesc,
    this.seqNo,
  });

  factory OrderTypeRes.fromJson(Map<String, dynamic> json) => OrderTypeRes(
        orderType: json["OrderType"],
        orderTypeDesc: json["OrderTypeDesc"],
        seqNo: json["SeqNo"],
      );
}
