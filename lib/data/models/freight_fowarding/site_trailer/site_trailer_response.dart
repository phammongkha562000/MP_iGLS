class SiteTrailerResponse {
  String? cntrNo;
  String? cyName;
  String? createDate;
  String? createUser;
  String? equipTypeDesc;
  String? ledStatus;
  String? purchaseDate;
  String? remark;
  int? tRLId;
  String? tireStatus;
  String? trailerNumber;
  String? cntrStatus;
  String? workingStatus;
  SiteTrailerResponse(
      {this.createDate,
      this.trailerNumber,
      this.cyName,
      this.purchaseDate,
      this.equipTypeDesc,
      this.tireStatus,
      this.ledStatus,
      this.remark,
      this.createUser,
      this.cntrNo,
      this.cntrStatus,
      this.tRLId,
      this.workingStatus});

  factory SiteTrailerResponse.fromMap(Map<String, dynamic> map) {
    return SiteTrailerResponse(
      createDate:
          map['CreateDate'] != null ? map['CreateDate'] as String : null,
      trailerNumber:
          map['TrailerNumber'] != null ? map['TrailerNumber'] as String : null,
      cyName: map['CYName'] != null ? map['CYName'] as String : null,
      equipTypeDesc:
          map['EquipTypeDesc'] != null ? map['EquipTypeDesc'] as String : null,
      tireStatus:
          map['TireStatus'] != null ? map['TireStatus'] as String : null,
      ledStatus: map['LedStatus'] != null ? map['LedStatus'] as String : null,
      remark: map['Remark'] != null ? map['Remark'] as String : null,
      createUser:
          map['CreateUser'] != null ? map['CreateUser'] as String : null,
      cntrNo: map['CNTRNo'] != null ? map['CNTRNo'] as String : null,
      tRLId: map['TRLId'] != null ? map['TRLId'] as int : null,
      cntrStatus:
          map['CNTRStatus'] != null ? map['CNTRStatus'] as String : null,
      workingStatus:
          map['WorkingStatus'] != null ? map['WorkingStatus'] as String : null,
    );
  }
}
