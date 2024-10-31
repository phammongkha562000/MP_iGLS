class FrequentlyVisitPageResponse {
  String? menuName;
  String? pageId;
  String? pageName;
  String? tagVariant;
  String? termDic;
  int? visit;

  FrequentlyVisitPageResponse({
    this.menuName,
    this.pageId,
    this.pageName,
    this.tagVariant,
    this.termDic,
    this.visit,
  });

  factory FrequentlyVisitPageResponse.fromJson(Map<String, dynamic> json) =>
      FrequentlyVisitPageResponse(
        menuName: json["MenuName"],
        pageId: json["PageId"],
        pageName: json["PageName"],
        tagVariant: json["TagVariant"],
        termDic: json["TermDic"],
        visit: json["Visit"],
      );
}
