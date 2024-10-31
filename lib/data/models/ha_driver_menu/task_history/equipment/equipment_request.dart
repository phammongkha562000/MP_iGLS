class EquipmentRequest {
  EquipmentRequest({
    required this.equipmentCode,
    required this.equipmentDesc,
    required this.equipTypeNo,
    required this.ownership,
    required this.equipmentGroup,
    required this.dcCode,
  });

  String equipmentCode;
  String equipmentDesc;
  String equipTypeNo;
  String ownership;
  String equipmentGroup;
  String dcCode;

  Map<String, dynamic> toMap() => {
        "EquipmentCode": equipmentCode,
        "EquipmentDesc": equipmentDesc,
        "EquipTypeNo": equipTypeNo,
        "Ownership": ownership,
        "EquipmentGroup": equipmentGroup,
        "DCCode": dcCode,
      };
}
