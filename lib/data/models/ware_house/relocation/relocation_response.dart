class RelocationResponse {
  List<RelocationResult>? results;
  int? totalCount;
  int? totalPage;

  RelocationResponse({
    this.results,
    this.totalCount,
    this.totalPage,
  });

  factory RelocationResponse.fromJson(Map<String, dynamic> json) =>
      RelocationResponse(
        results: json["Results"] == null
            ? []
            : List<RelocationResult>.from(
                json["Results"]!.map((x) => RelocationResult.fromMap(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );
}

class RelocationResult {
  int? id;
  int? sBNo;
  String? plandate;
  String? assignStaff;
  String? itemCode;
  String? itemDesc;
  String? oldLocCode;
  String? newLocCode;
  double? qty;
  bool? isDone;
  String? completeMemo;
  String? createUser;
  String? createDate;
  String? updateUser;
  String? updateDate;
  RelocationResult({
    this.id,
    this.sBNo,
    this.plandate,
    this.assignStaff,
    this.itemCode,
    this.itemDesc,
    this.oldLocCode,
    this.newLocCode,
    this.qty,
    this.isDone,
    this.completeMemo,
    this.createUser,
    this.createDate,
    this.updateUser,
    this.updateDate,
  });

  factory RelocationResult.fromMap(Map<String, dynamic> map) {
    return RelocationResult(
      id: map['Id'],
      sBNo: map['SBNo'],
      plandate: map['Plandate'],
      assignStaff: map['AssignStaff'],
      itemCode: map['ItemCode'],
      itemDesc: map['ItemDesc'],
      oldLocCode: map['OldLocCode'],
      newLocCode: map['NewLocCode'],
      qty: map['Qty'],
      isDone: map['IsDone'],
      completeMemo: map['CompleteMemo'],
      createUser: map['CreateUser'],
      createDate: map['CreateDate'],
      updateUser: map['UpdateUser'],
      updateDate: map['UpdateDate'],
    );
  }
}
