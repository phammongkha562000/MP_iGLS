class ShipmentStatusResponse {
  ShipmentStatusResponse({
    this.blNo,
    this.carrierBcNo,
    this.contactCode,
    this.endDeliveryDate,
    this.endLoadingDate,
    this.endPickupDate,
    this.equipmentNo,
    this.equipmentType,
    this.itemNo,
    this.startDeliveryDate,
    this.startLoadingDate,
    this.startPickupDate,
    this.tradeType,
    this.woNo,
  });

  String? blNo;
  String? carrierBcNo;
  String? contactCode;
  String? endDeliveryDate;
  String? endLoadingDate;
  String? endPickupDate;
  String? equipmentNo;
  String? equipmentType;
  int? itemNo;
  String? startDeliveryDate;
  String? startLoadingDate;
  String? startPickupDate;
  String? tradeType;
  String? woNo;

  factory ShipmentStatusResponse.fromMap(Map<String, dynamic> json) =>
      ShipmentStatusResponse(
        blNo: json["BLNo"],
        carrierBcNo: json["CarrierBCNo"],
        contactCode: json["ContactCode"],
        endDeliveryDate: json["EndDeliveryDate"],
        endLoadingDate: json["EndLoadingDate"],
        endPickupDate: json["EndPickupDate"],
        equipmentNo: json["EquipmentNo"],
        equipmentType: json["EquipmentType"],
        itemNo: json["ItemNo"],
        startDeliveryDate: json["StartDeliveryDate"],
        startLoadingDate: json["StartLoadingDate"],
        startPickupDate: json["StartPickupDate"],
        tradeType: json["TradeType"],
        woNo: json["WONo"],
      );
}
