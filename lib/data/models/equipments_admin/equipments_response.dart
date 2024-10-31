class EquipmentsResponse {
  String? assetCode;
  String? brand;
  String? color;
  String? createDate;
  String? createUser;
  String? currency;
  String? dcCode;
  String? defaultStaffId;
  String? eqGroupCode;
  dynamic equipStatus;
  String? equipTypeNo;
  String? equipmentCode;
  String? equipmentDesc;
  String? equipmentGroup;
  dynamic fuelConsumption;
  String? gpsVendor;
  dynamic lastPlaceDesc;
  dynamic lastSignalTime;
  dynamic lastSpeed;
  int? latestMileage;
  int? licenseExpired;
  String? model;
  String? ownership;
  double? purchaseAmt;
  String? purchaseDate;
  String? refEquipCode;
  String? remarks;
  double? rentalAmtPerMonth;
  String? serialNumber;
  double? soldAmt;
  dynamic soldDate;
  String? staffName;
  double? todayKm;
  String? updateDate;
  String? updateUser;

  EquipmentsResponse({
    this.assetCode,
    this.brand,
    this.color,
    this.createDate,
    this.createUser,
    this.currency,
    this.dcCode,
    this.defaultStaffId,
    this.eqGroupCode,
    this.equipStatus,
    this.equipTypeNo,
    this.equipmentCode,
    this.equipmentDesc,
    this.equipmentGroup,
    this.fuelConsumption,
    this.gpsVendor,
    this.lastPlaceDesc,
    this.lastSignalTime,
    this.lastSpeed,
    this.latestMileage,
    this.licenseExpired,
    this.model,
    this.ownership,
    this.purchaseAmt,
    this.purchaseDate,
    this.refEquipCode,
    this.remarks,
    this.rentalAmtPerMonth,
    this.serialNumber,
    this.soldAmt,
    this.soldDate,
    this.staffName,
    this.todayKm,
    this.updateDate,
    this.updateUser,
  });

  factory EquipmentsResponse.fromJson(Map<String, dynamic> json) =>
      EquipmentsResponse(
        assetCode: json["AssetCode"],
        brand: json["Brand"],
        color: json["Color"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        currency: json["Currency"],
        dcCode: json["DCCode"],
        defaultStaffId: json["DefaultStaffId"],
        eqGroupCode: json["EqGroupCode"],
        equipStatus: json["EquipStatus"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        equipmentGroup: json["EquipmentGroup"],
        fuelConsumption: json["FuelConsumption"],
        gpsVendor: json["GPSVendor"],
        lastPlaceDesc: json["LastPlaceDesc"],
        lastSignalTime: json["LastSignalTime"],
        lastSpeed: json["LastSpeed"],
        latestMileage: json["LatestMileage"],
        licenseExpired: json["LicenseExpired"],
        model: json["Model"],
        ownership: json["Ownership"],
        purchaseAmt: json["PurchaseAmt"],
        purchaseDate: json["PurchaseDate"],
        refEquipCode: json["RefEquipCode"],
        remarks: json["Remarks"],
        rentalAmtPerMonth: json["RentalAmtPerMonth"],
        serialNumber: json["SerialNumber"],
        soldAmt: json["SoldAmt"],
        soldDate: json["SoldDate"],
        staffName: json["StaffName"],
        todayKm: json["TodayKM"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}
