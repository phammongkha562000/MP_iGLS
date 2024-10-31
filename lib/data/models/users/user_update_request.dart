class UserDetailUpdateRequest {
  final String userId;
  final String userName;
  final String email;
  final String mobileNo;
  final String language;
  final String defaultSystem;
  final String defaultSubsidiary;
  final String defaultContact;
  final String defaultDc;
  final String defaultBarnch;
  final String updateUser;
  final String empCode;
  final String userRole;
  final dynamic cyCode;
  final dynamic dirverId;

  UserDetailUpdateRequest({
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

  Map<String, dynamic> toJson() => {
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
