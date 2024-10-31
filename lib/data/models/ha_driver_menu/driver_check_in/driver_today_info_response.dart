class DriverTodayInfo {
  String? equipmentCode;
  String? onDate;
  String? leaveDate;
  List<DailyTaskAmount>? dailyTaskAmount;

  DriverTodayInfo(
      {this.equipmentCode, this.dailyTaskAmount, this.leaveDate, this.onDate});
  factory DriverTodayInfo.fromJson(Map<String, dynamic> json) {
    return DriverTodayInfo(
        onDate: json['OnDate'],
        // ignore: prefer_null_aware_operators
        dailyTaskAmount: json['DailyTaskAmount'] != null
            ? json['DailyTaskAmount']
                .map<DailyTaskAmount>((json) => DailyTaskAmount.fromJson(json))
                .toList()
            : null,
        leaveDate: json['LeaveDate'],
        equipmentCode: json['EquipmentCode']);
  }
}

class DailyTaskAmount {
  String? docNo;
  double? cashAdvanceAmt;
  String? taskMemo;
  DailyTaskAmount({this.docNo, this.taskMemo, this.cashAdvanceAmt});
  factory DailyTaskAmount.fromJson(Map<String, dynamic> json) {
    return DailyTaskAmount(
        docNo: json['DocNo'] as String,
        cashAdvanceAmt: double.parse(json['CashAdvanceAmt'].toString()),
        taskMemo: json['TaskMemo'] as String);
  }
}
