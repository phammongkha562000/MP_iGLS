class GrTrackingResponse {
  String? actionDate;
  String? grNo;
  String? newLocCode;
  String? oldLocCode;
  double? qty;
  int? sequenNo;
  String? transactionType;

  GrTrackingResponse({
    this.actionDate,
    this.grNo,
    this.newLocCode,
    this.oldLocCode,
    this.qty,
    this.sequenNo,
    this.transactionType,
  });

  factory GrTrackingResponse.fromJson(Map<String, dynamic> json) =>
      GrTrackingResponse(
        actionDate: json["ActionDate"],
        grNo: json["GRNo"],
        newLocCode: json["NewLocCode"],
        oldLocCode: json["OldLocCode"],
        qty: json["Qty"],
        sequenNo: json["SequenNo"],
        transactionType: json["TransactionType"],
      );
}
