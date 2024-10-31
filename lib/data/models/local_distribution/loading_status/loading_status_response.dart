class LoadingStatusResponse {
  String? contactCode;
  String? etp;
  String? tripNo;
  String? equipType;
  String? equipment;
  String? driver;
  String? loadingStart;
  String? loadingEnd;
  String? loadingMemo;
  String? createDate;
  String? createUser;
  String? updateDate;
  String? updateUser;
  String? pickUpTime;
  String? deliveryTime;
  String? tripMemo;
  int? orders;
  double? qty;
  String? staffName;

  LoadingStatusResponse(
      {this.etp,
      this.tripNo,
      this.equipType,
      this.equipment,
      this.driver,
      this.loadingStart,
      this.loadingEnd,
      this.loadingMemo,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.pickUpTime,
      this.deliveryTime,
      this.tripMemo,
      this.orders,
      this.qty,
      this.staffName,
      this.contactCode});

  factory LoadingStatusResponse.fromJson(Map<String, dynamic> json) =>
      LoadingStatusResponse(
        etp: json["ETP"],
        tripNo: json["TripNo"],
        equipType: json["EquipType"],
        equipment: json["Equipment"],
        driver: json["Driver"],
        loadingStart: json["LoadingStart"],
        loadingEnd: json["LoadingEnd"],
        loadingMemo: json["LoadingMemo"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        pickUpTime: json["PickUpTime"],
        deliveryTime: json["DeliveryTime"],
        tripMemo: json["TripMemo"],
        orders: json["Orders"],
        qty: json["Qty"]?.toDouble(),
        staffName: json["StaffName"],
        contactCode: json["ContactCode"],
      );
}
