class UpdateRelocationRequest {
  final int id;
  final String dCCode;
  final String contactCode;
  final String plandate;
  final String assignStaff;
  final String oldLocCode;
  final String newLocCode;
  final double qty;
  final bool isDone;
  final String completeMemo;
  final String updateUser;
  UpdateRelocationRequest({
    required this.id,
    required this.dCCode,
    required this.contactCode,
    required this.plandate,
    required this.assignStaff,
    required this.oldLocCode,
    required this.newLocCode,
    required this.qty,
    required this.isDone,
    required this.completeMemo,
    required this.updateUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': id,
      'DCCode': dCCode,
      'ContactCode': contactCode,
      'PlanDate': plandate,
      'AssignStaff': assignStaff,
      'OldLocCode': oldLocCode,
      'NewLocCode': newLocCode,
      'Qty': qty,
      'IsDone': isDone,
      'CompleteMemo': completeMemo,
      'UpdateUser': updateUser,
    };
  }
}
