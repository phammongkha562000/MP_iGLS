class LoadingStatusDetailResponse {
  String? createDate;
  String? createUser;
  String? driver;
  String? equipType;
  String? equipment;
  String? loadingEnd;
  String? loadingMemo;
  String? loadingStart;
  dynamic pickUpTime;
  dynamic startDeliveryTime;
  String? tripNo;
  String? updateDate;
  String? updateUser;

  LoadingStatusDetailResponse({
    this.createDate,
    this.createUser,
    this.driver,
    this.equipType,
    this.equipment,
    this.loadingEnd,
    this.loadingMemo,
    this.loadingStart,
    this.pickUpTime,
    this.startDeliveryTime,
    this.tripNo,
    this.updateDate,
    this.updateUser,
  });

  factory LoadingStatusDetailResponse.fromJson(Map<String, dynamic> json) =>
      LoadingStatusDetailResponse(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        driver: json["Driver"],
        equipType: json["EquipType"],
        equipment: json["Equipment"],
        loadingEnd: json["LoadingEnd"],
        loadingMemo: json["LoadingMemo"],
        loadingStart: json["LoadingStart"],
        pickUpTime: json["PickUpTime"],
        startDeliveryTime: json["StartDeliveryTime"],
        tripNo: json["TripNo"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}
