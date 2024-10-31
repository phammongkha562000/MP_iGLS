class TaskHistoryResponse {
  TaskHistoryResponse({this.totalCount, this.totalPage, this.results});

  List<TaskHistoryResult>? results;
  int? totalCount;
  int? totalPage;

  factory TaskHistoryResponse.fromMap(Map<String, dynamic> json) =>
      TaskHistoryResponse(
        results: json["Results"] == null
            ? []
            : List<TaskHistoryResult>.from(
                json["Results"].map((x) => TaskHistoryResult.fromJson(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );
}

class TaskHistoryResult {
  TaskHistoryResult(
      {this.actualAmt,
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
      this.taskCompleteQty});

  double? actualAmt;
  double? cashAdvanceAmt;
  dynamic completeDate;
  dynamic completeUser;
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
  dynamic paymentDate;
  dynamic paymentUser;
  String? staffName;
  String? staffUserId;
  String? taskDate;
  String? taskMemo;
  int? taskQty;
  String? updateDate;
  String? updateUser;
  int? taskCompleteQty;

  factory TaskHistoryResult.fromJson(Map<String, dynamic> json) =>
      TaskHistoryResult(
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
        taskCompleteQty: json["TaskCompleteQty"],
      );
}
