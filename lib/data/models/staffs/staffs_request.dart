class StaffsRequest {
  final String dcCode;
  final String staffName;
  final String staffUserId;
  final String roleType;
  final String mobileNo;
  final int isDeleted;
  final String? statusWorking;

  StaffsRequest(
      {required this.dcCode,
      required this.staffName,
      required this.staffUserId,
      required this.roleType,
      required this.mobileNo,
      required this.isDeleted,
      this.statusWorking});

  Map<String, dynamic> toJson() => {
        "DCCode": dcCode,
        "StaffName": staffName,
        "StaffUserId": staffUserId,
        "RoleType": roleType,
        "MobileNo": mobileNo,
        "IsDeleted": isDeleted,
        "StatusWorking": statusWorking
      };
}
