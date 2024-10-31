class EquipmentDetailResponse {
  List<EquipmentGetDataDetail>? getDataDetail;
  List<EquipmentGetDataDetail1>? getDataDetail1;

  EquipmentDetailResponse({
    this.getDataDetail,
    this.getDataDetail1,
  });

  factory EquipmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      EquipmentDetailResponse(
        getDataDetail: List<EquipmentGetDataDetail>.from(json["GetDataDetail"]
            .map((x) => EquipmentGetDataDetail.fromJson(x))),
        getDataDetail1: List<EquipmentGetDataDetail1>.from(
            json["GetDataDetail1"]
                .map((x) => EquipmentGetDataDetail1.fromJson(x))),
      );
}

class EquipmentGetDataDetail {
  String? assetCode;
  String? brand;
  String? color;
  String? createDate;
  String? createUser;
  String? currency;
  String? dcCode;
  String? defaultStaffId;
  dynamic equipStatus;
  String? equipTypeNo;
  String? equipmentCode;
  String? equipmentDesc;
  dynamic fuelNorm;
  dynamic gpsVendor;
  int? latestMileage;
  String? model;
  String? ownership;
  double? purchaseAmt;
  String? purchaseDate;
  String? refEquipCode;
  dynamic remarks;
  double? rentalAmtPerMonth;
  String? serialNumber;
  double? soldAmt;
  dynamic soldDate;
  String? staffName;
  String? updateDate;
  String? updateUser;

  EquipmentGetDataDetail({
    this.assetCode,
    this.brand,
    this.color,
    this.createDate,
    this.createUser,
    this.currency,
    this.dcCode,
    this.defaultStaffId,
    this.equipStatus,
    this.equipTypeNo,
    this.equipmentCode,
    this.equipmentDesc,
    this.fuelNorm,
    this.gpsVendor,
    this.latestMileage,
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
    this.updateDate,
    this.updateUser,
  });

  factory EquipmentGetDataDetail.fromJson(Map<String, dynamic> json) =>
      EquipmentGetDataDetail(
        assetCode: json["AssetCode"],
        brand: json["Brand"],
        color: json["Color"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        currency: json["Currency"],
        dcCode: json["DCCode"],
        defaultStaffId: json["DefaultStaffId"],
        equipStatus: json["EquipStatus"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        fuelNorm: json["FuelNorm"],
        gpsVendor: json["GPSVendor"],
        latestMileage: json["LatestMileage"],
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
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}

class EquipmentGetDataDetail1 {
  String? dcCode;
  String? equipmentCode;

  EquipmentGetDataDetail1({
    this.dcCode,
    this.equipmentCode,
  });

  factory EquipmentGetDataDetail1.fromJson(Map<String, dynamic> json) =>
      EquipmentGetDataDetail1(
        dcCode: json["DCCode"],
        equipmentCode: json["EquipmentCode"],
      );
}
