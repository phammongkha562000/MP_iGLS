class EquipmentResponse {
  EquipmentResponse({
    this.assetCode,
    this.dcCode,
    this.equipTypeNo,
    this.equipmentCode,
    this.equipmentDesc,
    this.equipmentGroup,
    this.ownership,
    this.serialNumber,
  });

  dynamic assetCode;
  String? dcCode;
  String? equipTypeNo;
  String? equipmentCode;
  String? equipmentDesc;
  dynamic equipmentGroup;
  String? ownership;
  dynamic serialNumber;

  factory EquipmentResponse.fromMap(Map<String, dynamic> json) =>
      EquipmentResponse(
        assetCode: json["AssetCode"],
        dcCode: json["DCCode"],
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        equipmentGroup: json["EquipmentGroup"],
        ownership: json["Ownership"],
        serialNumber: json["SerialNumber"],
      );

  Map<String, dynamic> toMap() => {
        "AssetCode": assetCode,
        "DCCode": dcCode,
        "EquipTypeNo": equipTypeNo,
        "EquipmentCode": equipmentCode,
        "EquipmentDesc": equipmentDesc,
        "EquipmentGroup": equipmentGroup,
        "Ownership": ownership,
        "SerialNumber": serialNumber,
      };
}
