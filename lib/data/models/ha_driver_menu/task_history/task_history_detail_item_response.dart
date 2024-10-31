class HistoryDetailItem {
  HistoryDetailItem({
    this.actualEnd,
    this.actualStart,
    this.bcNo,
    this.blNo,
    this.cntrCleanFee,
    this.cntrDepositFee,
    this.cntrNo,
    this.cntrProcessingFee,
    this.cntrType,
    this.contactCode,
    this.dtdId,
    this.dtId,
    this.deliveryPlace,
    this.driverMemo,
    this.hcaId,
    this.haveEir,
    this.haveInv,
    this.invoiceCntrCleanFee,
    this.invoiceDeposit,
    this.invoiceLiftOffFee,
    this.invoiceLiftOnFee,
    this.liftOffFee,
    this.liftOnFee,
    this.othersFee,
    this.pickUpPlace,
    this.portProcessingFee,
    this.returnPlace,
    this.sealNo,
    this.secEquipmentCode,
    this.seqNo,
    this.taskMemo,
    this.taskMode,
    this.taskModeOrginal,
    this.tollFee,
    this.totalFee,
    this.tradeType,
    this.trafficFee,
    this.woNo,
    this.woTaskId,
    this.workerFee,
    this.transportType,
  });

  String? actualEnd;
  String? actualStart;
  String? bcNo;
  String? blNo;
  double? cntrCleanFee;
  double? cntrDepositFee;
  String? cntrNo;
  double? cntrProcessingFee;
  String? cntrType;
  String? contactCode;
  int? dtdId;
  int? dtId;
  String? deliveryPlace;
  String? driverMemo;
  int? hcaId;
  String? haveEir;
  String? haveInv;
  String? invoiceCntrCleanFee;
  String? invoiceDeposit;
  String? invoiceLiftOffFee;
  String? invoiceLiftOnFee;
  double? liftOffFee;
  double? liftOnFee;
  double? othersFee;
  String? pickUpPlace;
  double? portProcessingFee;
  String? returnPlace;
  String? sealNo;
  String? secEquipmentCode;
  int? seqNo;
  String? taskMemo;
  String? taskMode;
  String? taskModeOrginal;
  double? tollFee;
  double? totalFee;
  String? tradeType;
  double? trafficFee;
  String? woNo;
  int? woTaskId;
  double? workerFee;
  String? transportType;

  factory HistoryDetailItem.fromMap(Map<String, dynamic> json) =>
      HistoryDetailItem(
        actualEnd: json["ActualEnd"],
        actualStart: json["ActualStart"],
        bcNo: json["BCNo"],
        blNo: json["BLNo"],
        cntrCleanFee: json["CNTRCleanFee"],
        cntrDepositFee: json["CNTRDepositFee"],
        cntrNo: json["CNTRNo"],
        cntrProcessingFee: json["CNTRProcessingFee"],
        cntrType: json["CNTRType"],
        contactCode: json["ContactCode"],
        dtdId: json["DTDId"],
        dtId: json["DTId"],
        deliveryPlace: json["DeliveryPlace"],
        driverMemo: json["DriverMemo"],
        hcaId: json["HCAId"],
        haveEir: json["HaveEIR"],
        haveInv: json["HaveINV"],
        invoiceCntrCleanFee: json["InvoiceCNTRCleanFee"],
        invoiceDeposit: json["InvoiceDeposit"],
        invoiceLiftOffFee: json["InvoiceLiftOffFee"],
        invoiceLiftOnFee: json["InvoiceLiftOnFee"],
        liftOffFee: json["LiftOffFee"],
        liftOnFee: json["LiftOnFee"],
        othersFee: json["OthersFee"],
        pickUpPlace: json["PickUpPlace"],
        portProcessingFee: json["PortProcessingFee"],
        returnPlace: json["ReturnPlace"],
        sealNo: json["SealNo"],
        secEquipmentCode: json["SecEquipmentCode"],
        seqNo: json["SeqNo"],
        taskMemo: json["TaskMemo"],
        taskMode: json["TaskMode"],
        taskModeOrginal: json["TaskModeOrginal"],
        tollFee: json["TollFee"],
        totalFee: json["TotalFee"],
        tradeType: json["TradeType"],
        trafficFee: json["TrafficFee"],
        woNo: json["WONo"],
        woTaskId: json["WOTaskId"],
        workerFee: json["WorkerFee"],
        transportType: json["TransportType"],
      );
}
