class EquipmentTypeResponse {
  String? equipTypeDesc;
  String? equipTypeNo;

  EquipmentTypeResponse({
    this.equipTypeDesc,
    this.equipTypeNo,
  });

  factory EquipmentTypeResponse.fromJson(Map<String, dynamic> json) =>
      EquipmentTypeResponse(
        equipTypeDesc: json["EquipTypeDesc"],
        equipTypeNo: json["EquipTypeNo"],
      );
}
