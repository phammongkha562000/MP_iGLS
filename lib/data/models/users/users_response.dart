class UsersResponse {
  String? createDate;
  String? createUser;
  String? defaultBranch;
  String? defaultCenter;
  String? defaultClient;
  String? defaultSystem;
  String? email;
  String? empCode;
  String? lastLogin;
  String? mobileNo;
  String? updateDate;
  String? updateUser;
  String? userId;
  String? userName;
  String? userRole;

  UsersResponse({
    this.createDate,
    this.createUser,
    this.defaultBranch,
    this.defaultCenter,
    this.defaultClient,
    this.defaultSystem,
    this.email,
    this.empCode,
    this.lastLogin,
    this.mobileNo,
    this.updateDate,
    this.updateUser,
    this.userId,
    this.userName,
    this.userRole,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        defaultBranch: json["DefaultBranch"],
        defaultCenter: json["DefaultCenter"],
        defaultClient: json["DefaultClient"],
        defaultSystem: json["DefaultSystem"],
        email: json["Email"],
        empCode: json["EmpCode"],
        lastLogin: json["LastLogin"],
        mobileNo: json["MobileNo"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        userId: json["UserId"],
        userName: json["UserName"],
        userRole: json["UserRole"],
      );
}
