class SavePutAwayRequest {
  final int orderNo;
  final String pwDate;
  final String grade;
  final String itemStatus;
  final double pwQty;
  final double grQty;
  final String locCode;
  final String lotCode;
  final String grNo;
  final String userId;

  SavePutAwayRequest(
      {required this.orderNo,
      required this.pwDate,
      required this.grade,
      required this.itemStatus,
      required this.pwQty,
      required this.grQty,
      required this.locCode,
      required this.lotCode,
      required this.grNo,
      required this.userId});

  Map<String, dynamic> toJson() => {
        "IOrdNo": orderNo,
        "PWDate": pwDate,
        "Grade": grade,
        "ItemStatus": itemStatus,
        "LocCode": locCode,
        "LotCode": lotCode,
        "PWQty": pwQty,
        "GRQty": grQty,
        "GRNo": grNo,
        "UserId": userId,
      };
}
