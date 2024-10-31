class SiteStockCheckResponse {
  String? cntrNo;
  String? cntrStatus;
  String? cyCode;
  String? cyName;
  String? createDate;
  String? createUser;
  String? dcCode;
  String? equipTypeDesc;
  String? ledStatus;
  dynamic purchaseDate;
  String? remark;
  int? trsId;
  String? tireStatus;
  String? trailerNumber;
  String? workingStatus;

  SiteStockCheckResponse({
    this.cntrNo,
    this.cntrStatus,
    this.cyCode,
    this.cyName,
    this.createDate,
    this.createUser,
    this.dcCode,
    this.equipTypeDesc,
    this.ledStatus,
    this.purchaseDate,
    this.remark,
    this.trsId,
    this.tireStatus,
    this.trailerNumber,
    this.workingStatus,
  });

  factory SiteStockCheckResponse.fromJson(Map<String, dynamic> json) =>
      SiteStockCheckResponse(
        cntrNo: json["CNTRNo"],
        cntrStatus: json["CNTRStatus"],
        cyCode: json["CYCode"],
        cyName: json["CYName"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        equipTypeDesc: json["EquipTypeDesc"],
        ledStatus: json["LedStatus"],
        purchaseDate: json["PurchaseDate"],
        remark: json["Remark"],
        trsId: json["TRSId"],
        tireStatus: json["TireStatus"],
        trailerNumber: json["TrailerNumber"],
        workingStatus: json["WorkingStatus"],
      );

  
}
