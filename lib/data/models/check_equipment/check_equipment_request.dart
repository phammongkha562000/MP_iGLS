class CheckEquipmentsRequest {
  CheckEquipmentsRequest({
    required this.equipmentCode,
    required this.equipmentDesc,
    required this.equipTypeNo,
    required this.ownership,
    required this.equipmentGroup,
    required this.dcCode,
  });

  String? equipmentCode;
  String? equipmentDesc;
  String? equipTypeNo;
  String? ownership;
  String? equipmentGroup;
  String? dcCode;

  factory CheckEquipmentsRequest.fromMap(Map<String, dynamic> json) =>
      CheckEquipmentsRequest(
        equipmentCode: json["EquipmentCode"],
        equipmentDesc: json["EquipmentDesc"],
        equipTypeNo: json["EquipTypeNo"],
        ownership: json["Ownership"],
        equipmentGroup: json["EquipmentGroup"],
        dcCode: json["DCCode"],
      );

  Map<String, dynamic> toMap() => {
        "EquipmentCode": equipmentCode,
        "EquipmentDesc": equipmentDesc,
        "EquipTypeNo": equipTypeNo,
        "Ownership": ownership,
        "EquipmentGroup": equipmentGroup,
        "DCCode": dcCode,
      };
}
