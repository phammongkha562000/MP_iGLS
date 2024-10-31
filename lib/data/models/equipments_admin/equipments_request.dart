class EquipmentsRequest {
  final String dcCode;
  final String equipTypeNo;
  final String equipmentCode;
  final String equipmentDesc;
  final String ownership;
  final String assetCode;
  final String serialNumber;
  final String equipmentGroup;

  EquipmentsRequest({
    required this.dcCode,
    required this.equipTypeNo,
    required this.equipmentCode,
    required this.equipmentDesc,
    required this.ownership,
    required this.assetCode,
    required this.serialNumber,
    required this.equipmentGroup,
  });

  Map<String, dynamic> toJson() => {
        "DCCode": dcCode,
        "EquipTypeNo": equipTypeNo,
        "EquipmentCode": equipmentCode,
        "EquipmentDesc": equipmentDesc,
        "Ownership": ownership,
        "AssetCode": assetCode,
        "SerialNumber": serialNumber,
        "EquipmentGroup": equipmentGroup,
      };
}
