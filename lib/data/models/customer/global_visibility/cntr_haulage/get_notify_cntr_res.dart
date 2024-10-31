class GetNotifyCntrRes {
  String? createDate;
  String? createUser;
  int? id;
  int? itemNo;
  String? messageType;
  String? notes;
  String? receiver;
  String? updateDate;
  String? wONo;

  GetNotifyCntrRes(
      {this.createDate,
      this.createUser,
      this.id,
      this.itemNo,
      this.messageType,
      this.notes,
      this.receiver,
      this.updateDate,
      this.wONo});

  GetNotifyCntrRes.fromJson(Map<String, dynamic> json) {
    createDate = json['CreateDate'];
    createUser = json['CreateUser'];
    id = json['Id'];
    itemNo = json['ItemNo'];
    messageType = json['MessageType'];
    notes = json['Notes'];
    receiver = json['Receiver'];
    updateDate = json['UpdateDate'];
    wONo = json['WONo'];
  }
}
