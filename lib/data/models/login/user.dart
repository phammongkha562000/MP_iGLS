class UserLogin {
  final AccessToken? accessToken;
  final RefreshToken? refreshToken;
  bool? useDefaultPass;
  UserInfo? userInfo;
  final String? currentVersion;

  UserLogin({
    this.accessToken,
    this.refreshToken,
    this.useDefaultPass,
    this.userInfo,
    this.currentVersion,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        accessToken: AccessToken.fromJson(json["AccessToken"]),
        refreshToken: RefreshToken.fromJson(json["RefreshToken"]),
        useDefaultPass: json["UseDefaultPass"],
        userInfo: json["UserInfo"] == null
            ? null
            : UserInfo.fromJson(json["UserInfo"]),
        currentVersion: json["CurrentVersion"],
      );
}

class AccessToken {
  final String? token;
  final int? expiresIn;

  AccessToken({
    this.token,
    this.expiresIn,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        token: json["Token"],
        expiresIn: json["ExpiresIn"],
      );
}

class RefreshToken {
  final String? refreshToken;
  final DateTime? refreshTokenExpiryTime;

  RefreshToken({
    this.refreshToken,
    this.refreshTokenExpiryTime,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
        refreshToken: json["RefreshToken"],
        refreshTokenExpiryTime: json["RefreshTokenExpiryTime"] == null
            ? null
            : DateTime.parse(json["RefreshTokenExpiryTime"]),
      );
}

class UserInfo {
  String? subsidiaryId;
  String? subsidiaryName;
  String? userName;
  String? defaultSubsidiary;
  String? language;
  String? userRolePosition;
  int? yearSince;
  String? defaultClient;
  String? defaultCenter;
  dynamic defaultClientSmallLogo;
  dynamic defaultClientMidLogo;
  String? email;
  dynamic dashboardConfig;
  String? userId;
  String? defaultSystem;
  String? defaultBranch;
  String? empCode;
  String? userRole;
  String? mobileNo;
  String? webPortalURL;
  String? department;
  String? avartarThumbnail;
  String? workingLocation;
  String? divisionCode;

  UserInfo(
      {this.subsidiaryId,
      this.subsidiaryName,
      this.userName,
      this.defaultSubsidiary,
      this.language,
      this.userRolePosition,
      this.yearSince,
      this.defaultClient,
      this.defaultCenter,
      this.defaultClientSmallLogo,
      this.defaultClientMidLogo,
      this.email,
      this.dashboardConfig,
      this.userId,
      this.defaultSystem,
      this.defaultBranch,
      this.empCode,
      this.userRole,
      this.mobileNo,
      this.webPortalURL,
      this.department,
      this.avartarThumbnail,
      this.workingLocation,
      this.divisionCode});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        subsidiaryId: json["SubsidiaryId"],
        subsidiaryName: json["SubsidiaryName"],
        userName: json["UserName"],
        defaultSubsidiary: json["DefaultSubsidiary"],
        language: json["Language"],
        userRolePosition: json["UserRolePosition"],
        yearSince: json["YearSince"],
        defaultClient: json["DefaultClient"],
        defaultCenter: json["DefaultCenter"],
        defaultClientSmallLogo: json["DefaultClientSmallLogo"],
        defaultClientMidLogo: json["DefaultClientMidLogo"],
        email: json["Email"],
        dashboardConfig: json["DashboardConfig"],
        userId: json["UserId"],
        defaultSystem: json["DefaultSystem"],
        defaultBranch: json["DefaultBranch"],
        empCode: json["EmpCode"],
        userRole: json["UserRole"],
        mobileNo: json["MobileNo"],
        webPortalURL: json["WebPortalURL"],
        department: json["Department"],
        avartarThumbnail: json["AvartarThumbnail"],
        workingLocation: json["WorkingLocation"],
        divisionCode: json["DivisionCode"],
      );

  UserInfo copyWith(
      {String? subsidiaryId,
      String? subsidiaryName,
      String? userName,
      String? defaultSubsidiary,
      String? language,
      dynamic userRolePosition,
      int? yearSince,
      String? defaultClient,
      String? defaultCenter,
      dynamic defaultClientSmallLogo,
      dynamic defaultClientMidLogo,
      String? email,
      dynamic dashboardConfig,
      String? userId,
      String? defaultSystem,
      String? defaultBranch,
      String? empCode,
      String? userRole,
      String? mobileNo,
      String? webPortalURL,
      String? department,
      String? avartarThumbnail,
      String? workingLocation,
      String? divisionCode}) {
    return UserInfo(
      subsidiaryId: subsidiaryId ?? this.subsidiaryId,
      subsidiaryName: subsidiaryName ?? this.subsidiaryName,
      userName: userName ?? this.userName,
      defaultSubsidiary: defaultSubsidiary ?? this.defaultSubsidiary,
      language: language ?? this.language,
      userRolePosition: userRolePosition ?? this.userRolePosition,
      yearSince: yearSince ?? this.yearSince,
      defaultClient: defaultClient ?? this.defaultClient,
      defaultCenter: defaultCenter ?? this.defaultCenter,
      defaultClientSmallLogo:
          defaultClientSmallLogo ?? this.defaultClientSmallLogo,
      defaultClientMidLogo: defaultClientMidLogo ?? this.defaultClientMidLogo,
      email: email ?? this.email,
      dashboardConfig: dashboardConfig ?? this.dashboardConfig,
      userId: userId ?? this.userId,
      defaultSystem: defaultSystem ?? this.defaultSystem,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      empCode: empCode ?? this.empCode,
      userRole: userRole ?? this.userRole,
      mobileNo: mobileNo ?? this.mobileNo,
      webPortalURL: webPortalURL ?? this.webPortalURL,
      department: department ?? this.department,
      avartarThumbnail: avartarThumbnail ?? this.avartarThumbnail,
      workingLocation: workingLocation ?? this.workingLocation,
      divisionCode: divisionCode ?? this.divisionCode,
    );
  }
}
