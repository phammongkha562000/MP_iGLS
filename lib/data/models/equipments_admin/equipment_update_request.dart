class EquipmentUpdateRequest {
  final String equipmentCode;
  final String equipmentDesc;
  final String equipTypeNo;
  final String ownership;
  final String brand;
  final String model;
  final String color;
  final String refEquipCode;
  final String assetCode;
  final String serialNumber;
  final int latestMileage;
  final double purchaseAmt;
  final String purchaseDate;
  final double rentalAmtPerMonth;
  final dynamic soldDate;
  final double soldAmt;
  final String dcCode;
  final String createUser;
  final String updateUser;
  final String currency;
  final String defaultStaffId;
  final String listDcCode;
  String? fuelConsumption;
  String? gpsVendor;
  String? remarks;
  String? equipStatus;

  EquipmentUpdateRequest({
    required this.equipmentCode,
    required this.equipmentDesc,
    required this.equipTypeNo,
    required this.ownership,
    required this.brand,
    required this.model,
    required this.color,
    required this.refEquipCode,
    required this.assetCode,
    required this.serialNumber,
    required this.latestMileage,
    required this.purchaseAmt,
    required this.purchaseDate,
    required this.rentalAmtPerMonth,
    required this.soldDate,
    required this.soldAmt,
    required this.dcCode,
    required this.createUser,
    required this.updateUser,
    required this.currency,
    required this.defaultStaffId,
    required this.listDcCode,
    this.fuelConsumption,
    this.gpsVendor,
    this.remarks,
    this.equipStatus,
  });

  Map<String, dynamic> toJson() => {
        "EquipmentCode": equipmentCode,
        "EquipmentDesc": equipmentDesc,
        "EquipTypeNo": equipTypeNo,
        "Ownership": ownership,
        "Brand": brand,
        "Model": model,
        "Color": color,
        "RefEquipCode": refEquipCode,
        "AssetCode": assetCode,
        "SerialNumber": serialNumber,
        "LatestMileage": latestMileage,
        "PurchaseAmt": purchaseAmt,
        "PurchaseDate": purchaseDate,
        "RentalAmtPerMonth": rentalAmtPerMonth,
        "SoldDate": soldDate,
        "SoldAmt": soldAmt,
        "DCCode": dcCode,
        "CreateUser": createUser,
        "UpdateUser": updateUser,
        "Currency": currency,
        "DefaultStaffId": defaultStaffId,
        "ListDCCode": listDcCode,
        "FuelConsumption": fuelConsumption,
        "GPSVendor": gpsVendor,
        "Remarks": remarks,
        "EquipStatus": equipStatus,
      };
}
