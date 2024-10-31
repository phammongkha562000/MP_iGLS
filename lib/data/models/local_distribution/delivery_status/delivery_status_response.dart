class DeliveryStatusResponse {
  DeliveryStatusResponse({
    this.getTeTruckDashboard1,
    this.getTeTruckDashboard2,
  });

  List<GetTeTruckDashboard1>? getTeTruckDashboard1;
  List<GetTeTruckDashboard2>? getTeTruckDashboard2;

  DeliveryStatusResponse copyWith({
    List<GetTeTruckDashboard1>? getTeTruckDashboard1,
    List<GetTeTruckDashboard2>? getTeTruckDashboard2,
  }) =>
      DeliveryStatusResponse(
        getTeTruckDashboard1: getTeTruckDashboard1 ?? this.getTeTruckDashboard1,
        getTeTruckDashboard2: getTeTruckDashboard2 ?? this.getTeTruckDashboard2,
      );

  factory DeliveryStatusResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryStatusResponse(
        getTeTruckDashboard1: json["GetTETruckDashboard1"] != [] &&
                json["GetTETruckDashboard1"] != null
            ? List<GetTeTruckDashboard1>.from(json["GetTETruckDashboard1"]
                .map((x) => GetTeTruckDashboard1.fromJson(x)))
            : [],
        getTeTruckDashboard2: json["GetTETruckDashboard2"] != [] &&
                json["GetTETruckDashboard2"] != null
            ? List<GetTeTruckDashboard2>.from(json["GetTETruckDashboard2"]
                .map((x) => GetTeTruckDashboard2.fromJson(x)))
            : [],
      );
}

class GetTeTruckDashboard1 {
  GetTeTruckDashboard1({
    this.contact,
    this.done,
    this.progress,
    this.rate,
    this.trips,
  });

  String? contact;
  int? done;
  int? progress;
  double? rate;
  int? trips;

  GetTeTruckDashboard1 copyWith({
    String? contact,
    int? done,
    int? progress,
    double? rate,
    int? trips,
  }) =>
      GetTeTruckDashboard1(
        contact: contact ?? this.contact,
        done: done ?? this.done,
        progress: progress ?? this.progress,
        rate: rate ?? this.rate,
        trips: trips ?? this.trips,
      );

  factory GetTeTruckDashboard1.fromJson(Map<String, dynamic> json) =>
      GetTeTruckDashboard1(
        contact: json["Contact"],
        done: json["Done"],
        progress: json["Progress"],
        rate: json["Rate"],
        trips: json["Trips"],
      );
}

class GetTeTruckDashboard2 {
  GetTeTruckDashboard2({
    this.contactCode,
    this.done,
    this.driverId,
    this.etp,
    this.equipTypeNo,
    this.equipmentCode,
    this.lastGpsTime,
    this.leadTime,
    this.mobileNo,
    this.placeDesc,
    this.porter,
    this.porterName,
    this.shipTo,
    this.staffName,
    this.started,
    this.tripMemo,
    this.tripNo,
    this.tripType,
    this.updateStatus,
  });

  String? contactCode;
  String? done;
  String? driverId;
  String? etp;
  String? equipTypeNo;
  String? equipmentCode;
  dynamic lastGpsTime;
  int? leadTime;
  String? mobileNo;
  dynamic placeDesc;
  dynamic porter;
  String? porterName;
  String? shipTo;
  String? staffName;
  String? started;
  String? tripMemo;
  String? tripNo;
  String? tripType;
  String? updateStatus;

  factory GetTeTruckDashboard2.fromJson(Map<String, dynamic> json) =>
      GetTeTruckDashboard2(
        contactCode: json["ContactCode"],
        done: json["Done"],
        driverId: json["DriverId"],
        etp: json["ETP"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        lastGpsTime: json["LastGPSTime"],
        leadTime: json["LeadTime"],
        mobileNo: json["MobileNo"],
        placeDesc: json["PlaceDesc"],
        porter: json["Porter"],
        porterName: json["PorterName"],
        shipTo: json["ShipTo"],
        staffName: json["StaffName"],
        started: json["Started"],
        tripMemo: json["TripMemo"],
        tripNo: json["TripNo"],
        tripType: json["TripType"],
        updateStatus: json["UpdateStatus"],
      );
}
