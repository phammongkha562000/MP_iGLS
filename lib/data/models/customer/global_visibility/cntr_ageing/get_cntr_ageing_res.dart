class GetCntrAgeingRes {
  String? bCNo;
  String? bLNo;
  dynamic cDDate;
  dynamic cDNo;
  String? cNTRNo;
  String? cNTRType;
  String? carrier;
  dynamic deliveryDate;
  String? dueDate;
  int? overs;
  dynamic pickupDate;
  int? remained;
  String? wONo;
  String? wOStatus;
  int? woItemNo;

  GetCntrAgeingRes(
      {this.bCNo,
      this.bLNo,
      this.cDDate,
      this.cDNo,
      this.cNTRNo,
      this.cNTRType,
      this.carrier,
      this.deliveryDate,
      this.dueDate,
      this.overs,
      this.pickupDate,
      this.remained,
      this.wONo,
      this.wOStatus,
      this.woItemNo});

  GetCntrAgeingRes.fromJson(Map<String, dynamic> json) {
    bCNo = json['BCNo'];
    bLNo = json['BLNo'];
    cDDate = json['CDDate'];
    cDNo = json['CDNo'];
    cNTRNo = json['CNTRNo'];
    cNTRType = json['CNTRType'];
    carrier = json['Carrier'];
    deliveryDate = json['DeliveryDate'];
    dueDate = json['DueDate'];
    overs = json['Overs'];
    pickupDate = json['PickupDate'];
    remained = json['Remained'];
    wONo = json['WONo'];
    wOStatus = json['WOStatus'];
    woItemNo = json['WoItemNo'];
  }
}
