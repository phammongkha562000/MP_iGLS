class UserDetailResponse {
  List<UserGetDetail>? getDetail;
  List<UserGetDetail1>? getDetail1;

  UserDetailResponse({
    this.getDetail,
    this.getDetail1,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailResponse(
        getDetail: json["GetDetail"] == null
            ? []
            : List<UserGetDetail>.from(
                json["GetDetail"]!.map((x) => UserGetDetail.fromJson(x))),
        getDetail1: json["GetDetail1"] == null
            ? []
            : List<UserGetDetail1>.from(
                json["GetDetail1"]!.map((x) => UserGetDetail1.fromJson(x))),
      );
}

class UserGetDetail {
  String? createDate;
  dynamic createUser;
  String? defaultSubsidiary;
  String? email;
  dynamic empCode;
  bool? isUse;
  String? lastLogin;
  dynamic mobileNo;
  String? password;
  String? updateDate;
  String? updateUser;
  String? userId;
  String? userName;
  dynamic userRole;

  UserGetDetail({
    this.createDate,
    this.createUser,
    this.defaultSubsidiary,
    this.email,
    this.empCode,
    this.isUse,
    this.lastLogin,
    this.mobileNo,
    this.password,
    this.updateDate,
    this.updateUser,
    this.userId,
    this.userName,
    this.userRole,
  });

  factory UserGetDetail.fromJson(Map<String, dynamic> json) => UserGetDetail(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        defaultSubsidiary: json["DefaultSubsidiary"],
        email: json["Email"],
        empCode: json["EmpCode"],
        isUse: json["IsUse"],
        lastLogin: json["LastLogin"],
        mobileNo: json["MobileNo"],
        password: json["Password"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        userId: json["UserId"],
        userName: json["UserName"],
        userRole: json["UserRole"],
      );
}

class UserGetDetail1 {
  String? defaultBranch;
  String? defaultCenter;
  String? defaultClient;
  String? defaultSubsidiary;
  String? defaultSystem;
  String? lang;
  String? subsidiaryId;
  String? subsidiaryName;

  UserGetDetail1({
    this.defaultBranch,
    this.defaultCenter,
    this.defaultClient,
    this.defaultSubsidiary,
    this.defaultSystem,
    this.lang,
    this.subsidiaryId,
    this.subsidiaryName,
  });

  factory UserGetDetail1.fromJson(Map<String, dynamic> json) => UserGetDetail1(
        defaultBranch: json["DefaultBranch"],
        defaultCenter: json["DefaultCenter"],
        defaultClient: json["DefaultClient"],
        defaultSubsidiary: json["DefaultSubsidiary"],
        defaultSystem: json["DefaultSystem"],
        lang: json["LANG"],
        subsidiaryId: json["SubsidiaryId"],
        subsidiaryName: json["SubsidiaryName"],
      );
}
