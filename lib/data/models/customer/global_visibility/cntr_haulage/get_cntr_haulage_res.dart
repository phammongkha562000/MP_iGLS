class GetCntrHaulageRes {
  String? bLNo;
  dynamic cDComplete;
  dynamic cDNo;
  String? cNTRNo;
  String? cNTRType;
  String? carrier;
  String? carrierBCNo;
  dynamic deliveryReturnEndActual;
  String? deliveryReturnEndPlan;
  dynamic deliveryReturnStartActual;
  dynamic deliveryTrator;
  dynamic deliveryVendor;
  String? eTAETD;
  String? equipmentType;
  dynamic loadUnloadEnd;
  String? mBLNo;
  String? pOD;
  String? pOL;
  dynamic permitMode;
  String? pickTractor;
  dynamic pickUpEndActual;
  String? pickUpEndPlan;
  dynamic pickUpStartActual;
  String? pickVendor;
  String? sealNo;
  double? totalQty;
  String? tradeType;
  dynamic vesselOrFlight;
  double? volume;
  String? voyage;
  int? wOItemNo;
  String? wONo;
  double? weight;
  String? workOrderStatus;

  GetCntrHaulageRes(
      {this.bLNo,
      this.cDComplete,
      this.cDNo,
      this.cNTRNo,
      this.cNTRType,
      this.carrier,
      this.carrierBCNo,
      this.deliveryReturnEndActual,
      this.deliveryReturnEndPlan,
      this.deliveryReturnStartActual,
      this.deliveryTrator,
      this.deliveryVendor,
      this.eTAETD,
      this.equipmentType,
      this.loadUnloadEnd,
      this.mBLNo,
      this.pOD,
      this.pOL,
      this.permitMode,
      this.pickTractor,
      this.pickUpEndActual,
      this.pickUpEndPlan,
      this.pickUpStartActual,
      this.pickVendor,
      this.sealNo,
      this.totalQty,
      this.tradeType,
      this.vesselOrFlight,
      this.volume,
      this.voyage,
      this.wOItemNo,
      this.wONo,
      this.weight,
      this.workOrderStatus});

  GetCntrHaulageRes.fromJson(Map<String, dynamic> json) {
    bLNo = json['BLNo'];
    cDComplete = json['CDComplete'];
    cDNo = json['CDNo'];
    cNTRNo = json['CNTRNo'];
    cNTRType = json['CNTRType'];
    carrier = json['Carrier'];
    carrierBCNo = json['CarrierBCNo'];
    deliveryReturnEndActual = json['DeliveryReturnEndActual'];
    deliveryReturnEndPlan = json['DeliveryReturnEndPlan'];
    deliveryReturnStartActual = json['DeliveryReturnStartActual'];
    deliveryTrator = json['DeliveryTrator'];
    deliveryVendor = json['DeliveryVendor'];
    eTAETD = json['ETAETD'];
    equipmentType = json['EquipmentType'];
    loadUnloadEnd = json['LoadUnloadEnd'];
    mBLNo = json['MBLNo'];
    pOD = json['POD'];
    pOL = json['POL'];
    permitMode = json['PermitMode'];
    pickTractor = json['PickTractor'];
    pickUpEndActual = json['PickUpEndActual'];
    pickUpEndPlan = json['PickUpEndPlan'];
    pickUpStartActual = json['PickUpStartActual'];
    pickVendor = json['PickVendor'];
    sealNo = json['SealNo'];
    totalQty = json['TotalQty'];
    tradeType = json['TradeType'];
    vesselOrFlight = json['VesselOrFlight'];
    volume = json['Volume'];
    voyage = json['Voyage'];
    wOItemNo = json['WOItemNo'];
    wONo = json['WONo'];
    weight = json['Weight'];
    workOrderStatus = json['WorkOrderStatus'];
  }
}
