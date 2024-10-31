// ignore_for_file: prefer_if_null_operators

class HistoryDetail {
  HistoryDetail({
    required this.dailyTask,
    required this.listDetail,
  });

  DailyTask dailyTask;
  List<ListDetail> listDetail;

  factory HistoryDetail.fromMap(Map<String, dynamic> json) => HistoryDetail(
        dailyTask: DailyTask.fromMap(json["DailyTask"]),
        listDetail: List<ListDetail>.from(
            json["ListDetail"].map((x) => ListDetail.fromMap(x))),
      );
}

class DailyTask {
  DailyTask({
    this.actualAmt,
    this.cashAdvanceAmt,
    this.completeDate,
    this.completeUser,
    this.createDate,
    this.createUser,
    this.dcCode,
    this.dtId,
    this.dailyTaskStatus,
    this.dailyTaskStatusDesc,
    this.docNo,
    this.equipmentCode,
    this.estimatedAmount,
    this.offSetAmt,
    this.paymentDate,
    this.paymentUser,
    this.staffName,
    this.staffUserId,
    this.taskDate,
    this.taskMemo,
    this.taskQty,
    this.updateDate,
    this.updateUser,
  });

  double? actualAmt;
  double? cashAdvanceAmt;
  String? completeDate;
  String? completeUser;
  String? createDate;
  String? createUser;
  String? dcCode;
  int? dtId;
  String? dailyTaskStatus;
  String? dailyTaskStatusDesc;
  String? docNo;
  String? equipmentCode;
  double? estimatedAmount;
  double? offSetAmt;
  String? paymentDate;
  String? paymentUser;
  String? staffName;
  String? staffUserId;
  String? taskDate;
  String? taskMemo;
  int? taskQty;
  String? updateDate;
  String? updateUser;

  factory DailyTask.fromMap(Map<String, dynamic> json) => DailyTask(
        actualAmt: json["ActualAmt"],
        cashAdvanceAmt: json["CashAdvanceAmt"],
        completeDate: json["CompleteDate"],
        completeUser: json["CompleteUser"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        dtId: json["DTId"],
        dailyTaskStatus: json["DailyTaskStatus"],
        dailyTaskStatusDesc: json["DailyTaskStatusDesc"],
        docNo: json["DocNo"],
        equipmentCode: json["EquipmentCode"],
        estimatedAmount: json["EstimatedAmount"],
        offSetAmt: json["OffSetAmt"],
        paymentDate: json["PaymentDate"],
        paymentUser: json["PaymentUser"],
        staffName: json["StaffName"],
        staffUserId: json["StaffUserId"],
        taskDate: json["TaskDate"],
        taskMemo: json["TaskMemo"],
        taskQty: json["TaskQty"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}

class ListDetail {
  ListDetail({
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

  factory ListDetail.fromMap(Map<String, dynamic> json) => ListDetail(
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
        secEquipmentCode:
            json["SecEquipmentCode"] == null ? null : json["SecEquipmentCode"],
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
      );
}
