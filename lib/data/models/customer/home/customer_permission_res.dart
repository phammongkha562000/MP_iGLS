class CustomerPermissionRes {
  List<GetMenuResult>? getMenuResult;
  List<UserDCResult>? userDCResult;
  List<UserSubsidaryResult>? userSubsidaryResult;

  CustomerPermissionRes(
      {this.getMenuResult, this.userDCResult, this.userSubsidaryResult});

  CustomerPermissionRes.fromJson(Map<String, dynamic> json) {
    if (json['GetMenuResult'] != null) {
      getMenuResult = <GetMenuResult>[];
      json['GetMenuResult'].forEach((v) {
        getMenuResult!.add(GetMenuResult.fromJson(v));
      });
    }
    if (json['UserDCResult'] != null) {
      userDCResult = <UserDCResult>[];
      json['UserDCResult'].forEach((v) {
        userDCResult!.add(UserDCResult.fromJson(v));
      });
    }
    if (json['UserSubsidaryResult'] != null) {
      userSubsidaryResult = <UserSubsidaryResult>[];
      json['UserSubsidaryResult'].forEach((v) {
        userSubsidaryResult!.add(UserSubsidaryResult.fromJson(v));
      });
    }
  }
}

class GetMenuResult {
  String? eN;
  String? icon;
  bool? isGroup;
  String? menuId;
  String? menuName;
  String? pageId;
  String? pageName;
  String? parentsMenu;
  String? systemID;
  String? tagVariant;
  String? vI;

  GetMenuResult(
      {this.eN,
      this.icon,
      this.isGroup,
      this.menuId,
      this.menuName,
      this.pageId,
      this.pageName,
      this.parentsMenu,
      this.systemID,
      this.tagVariant,
      this.vI});

  GetMenuResult.fromJson(Map<String, dynamic> json) {
    eN = json['EN'];
    icon = json['Icon'];
    isGroup = json['IsGroup'];
    menuId = json['MenuId'];
    menuName = json['MenuName'];
    pageId = json['PageId'];
    pageName = json['PageName'];
    parentsMenu = json['ParentsMenu'];
    systemID = json['SystemID'];
    tagVariant = json['TagVariant'];
    vI = json['VI'];
  }
}

class UserDCResult {
  String? dCCode;
  String? dCDesc;
  String? userId;

  UserDCResult({this.dCCode, this.dCDesc, this.userId});

  UserDCResult.fromJson(Map<String, dynamic> json) {
    dCCode = json['DCCode'];
    dCDesc = json['DCDesc'];
    userId = json['UserId'];
  }
}

class UserSubsidaryResult {
  String? defaultBranch;
  String? defaultCenter;
  String? defaultClient;
  String? subsidiaryId;
  String? subsidiaryName;
  String? contactCode;

  UserSubsidaryResult({
    this.defaultBranch,
    this.defaultCenter,
    this.defaultClient,
    this.subsidiaryId,
    this.subsidiaryName,
    this.contactCode,
  });

  UserSubsidaryResult.fromJson(Map<String, dynamic> json) {
    defaultBranch = json['DefaultBranch'];
    defaultCenter = json['DefaultCenter'];
    defaultClient = json['DefaultClient'];
    subsidiaryId = json['SubsidiaryId'];
    subsidiaryName = json['SubsidiaryName'];
    contactCode = json['ContactCode'];
  }
}

class ContactCodeRes {
  String? clientId;
  String? smallLogo;

  ContactCodeRes({
    this.clientId,
    this.smallLogo,
  });

  factory ContactCodeRes.fromJson(Map<String, dynamic> json) => ContactCodeRes(
        clientId: json["ClientId"],
        smallLogo: json["SmallLogo"],
      );
}
