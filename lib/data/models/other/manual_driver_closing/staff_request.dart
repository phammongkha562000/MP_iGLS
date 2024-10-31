class StaffRequest {
  final String dCCode;
  final String staffName;
  final String staffUserId;
  final String roleType;
  final String mobileNo;
  StaffRequest({
    required this.dCCode,
    required this.staffName,
    required this.staffUserId,
    required this.roleType,
    required this.mobileNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'DCCode': dCCode,
      'StaffName': staffName,
      'StaffUserId': staffUserId,
      'RoleType': roleType,
      'MobileNo': mobileNo,
    };
  }
}
