class GetStdCodeRes {
  String? codeDesc;
  String? codeID;
  int? codeNumeric;
  String? codeType;
  dynamic codeVariant;
  String? createDate;
  String? createUser;
  bool? isUse;
  int? seqNo;
  dynamic updateDate;
  dynamic updateUser;

  GetStdCodeRes(
      {this.codeDesc,
      this.codeID,
      this.codeNumeric,
      this.codeType,
      this.codeVariant,
      this.createDate,
      this.createUser,
      this.isUse,
      this.seqNo,
      this.updateDate,
      this.updateUser});

  GetStdCodeRes.fromJson(Map<String, dynamic> json) {
    codeDesc = json['CodeDesc'];
    codeID = json['CodeID'];
    codeNumeric = json['CodeNumeric'];
    codeType = json['CodeType'];
    codeVariant = json['CodeVariant'];
    createDate = json['CreateDate'];
    createUser = json['CreateUser'];
    isUse = json['IsUse'];
    seqNo = json['SeqNo'];
    updateDate = json['UpdateDate'];
    updateUser = json['UpdateUser'];
  }

 
}
