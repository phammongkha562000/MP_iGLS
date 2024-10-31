class PageMenuPermissions {
  PageMenuPermissions(
      {this.icon,
      this.isGroup,
      this.menuId,
      this.menuName,
      this.pageId,
      this.pageName,
      this.parentsMenu,
      this.systemId,
      this.tagVariant,
      this.tId,
      this.quickMenuSeq,
      this.parentsMenuTId});

  // dynamic en;
  String? icon;
  bool? isGroup;
  // dynamic ko;
  String? menuId;
  String? menuName;
  String? pageId;
  String? pageName;
  String? parentsMenu;
  String? systemId;
  String? tagVariant;
  // dynamic vi;
  // dynamic zh;
  int? quickMenuSeq;
  int? tId;
  int? parentsMenuTId;

  factory PageMenuPermissions.fromJson(Map<String, dynamic> json) =>
      PageMenuPermissions(
          icon: json["Icon"],
          isGroup: json["IsGroup"] == 0
              ? false
              : json["IsGroup"] == 1
                  ? true
                  : json["IsGroup"],
          menuId: json["MenuId"],
          menuName: json["MenuName"],
          pageId: json["PageId"],
          pageName: json["PageName"],
          parentsMenu: json["ParentsMenu"],
          systemId: json["SystemID"],
          tagVariant: json["TagVariant"],
          tId: json["TId"],
          parentsMenuTId: json["ParentsMenuTId"],
          quickMenuSeq: json["QuickMenuSeq"]);

  static int getSeqNo({required String menuId}) {
    switch (menuId) {
      case 'MB1005':
        return 1;
      case 'MB0057':
        return 2;
      case 'MB0023':
        return 3;
      case 'MB1004':
        return 4;
      case 'MB0024':
        return 5;
      case 'MB0027':
        return 7;
      case 'MB0053':
        return 8;
      case 'MB1001':
        return 10;
      case 'MB0034':
        return 20;
    }
    return 0;
  }
}
