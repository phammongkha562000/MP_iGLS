class SaveNotifySettingReq {
  String? wONo;
  int? itemNo;
  String? userId;
  String? receiver;
  String? messageType;
  String? notes;

  SaveNotifySettingReq(
      {this.wONo,
      this.itemNo,
      this.userId,
      this.receiver,
      this.messageType,
      this.notes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};      
    data['WONo'] = wONo;
    data['ItemNo'] = itemNo;
    data['UserId'] = userId;
    data['Receiver'] = receiver;
    data['MessageType'] = messageType;
    data['Notes'] = notes;
    return data;
  }
}
