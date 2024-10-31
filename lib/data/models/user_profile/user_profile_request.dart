class UpdateUserProfileRequest {
  UpdateUserProfileRequest({
    required this.userId,
    required this.userName,
    required this.email,
    required this.mobileNo,
    required this.language,
    required this.defaultSystem,
    required this.defaultSubsidiary,
    required this.defaultContact,
    required this.defaultDc,
    required this.defaultBarnch,
    required this.updateUser,
    required this.empCode,
    required this.userRole,
    required this.cyCode,
    required this.dirverId,
  });

  String? userId;
  String? userName;
  String? email;
  String? mobileNo;
  String? language;
  String? defaultSystem;
  String? defaultSubsidiary;
  String? defaultContact;
  String? defaultDc;
  String? defaultBarnch;
  String? updateUser;
  String? empCode;
  String? userRole;
  String? cyCode;
  String? dirverId;

  Map<String, dynamic> toMap() => {
        "UserId": userId,
        "UserName": userName,
        "Email": email,
        "MobileNo": mobileNo,
        "Language": language,
        "DefaultSystem": defaultSystem,
        "DefaultSubsidiary": defaultSubsidiary,
        "DefaultContact": defaultContact,
        "DefaultDC": defaultDc,
        "DefaultBarnch": defaultBarnch,
        "UpdateUser": updateUser,
        "EmpCode": empCode,
        "UserRole": userRole,
        "CYCode": cyCode,
        "DirverId": dirverId,
      };
}
