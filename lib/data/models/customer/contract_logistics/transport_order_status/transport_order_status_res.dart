class CustomerTOSRes {
  String? ata;
  String? atd;
  String? atp;
  double? codAmount;
  String? clientRefNo;
  String? createDate;
  String? dcCode;
  String? deliveryMode;
  String? etp;
  String? equipmentCode;
  String? gpsVendor;
  String? ordStatusName;
  int? ordeId;
  String? orderTypeDesc;
  String? pickName;
  String? processStatus;
  double? qty;
  String? receiptDate;
  String? shipToName;
  String? tripNo;
  double? volume;
  double? weight;

  CustomerTOSRes({
    this.ata,
    this.atd,
    this.atp,
    this.codAmount,
    this.clientRefNo,
    this.createDate,
    this.dcCode,
    this.deliveryMode,
    this.etp,
    this.equipmentCode,
    this.gpsVendor,
    this.ordStatusName,
    this.ordeId,
    this.orderTypeDesc,
    this.pickName,
    this.processStatus,
    this.qty,
    this.receiptDate,
    this.shipToName,
    this.tripNo,
    this.volume,
    this.weight,
  });

  factory CustomerTOSRes.fromJson(Map<String, dynamic> json) => CustomerTOSRes(
        ata: json["ATA"],
        atd: json["ATD"],
        atp: json["ATP"],
        codAmount: json["CODAmount"],
        clientRefNo: json["ClientRefNo"],
        createDate: json["CreateDate"],
        dcCode: json["DCCode"],
        deliveryMode: json["DeliveryMode"],
        etp: json["ETP"],
        equipmentCode: json["EquipmentCode"],
        gpsVendor: json["GPSVendor"],
        ordStatusName: json["OrdStatusName"],
        ordeId: json["OrdeId"],
        orderTypeDesc: json["OrderTypeDesc"],
        pickName: json["PickName"],
        processStatus: json["ProcessStatus"],
        qty: json["Qty"],
        receiptDate: json["ReceiptDate"],
        shipToName: json["ShipToName"],
        tripNo: json["TripNo"],
        volume: json["Volume"],
        weight: json["Weight"],
      );
}
