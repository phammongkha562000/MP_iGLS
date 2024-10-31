class FrequentlyVisitPageRequest {
  final String userId;
  final String subSidiaryId;
  final String pageId;
  final String pageName;
  final String accessDatetime;
  final String systemId;

  FrequentlyVisitPageRequest({
    required this.userId,
    required this.subSidiaryId,
    required this.pageId,
    required this.pageName,
    required this.accessDatetime,
    required this.systemId,
  });

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "SubSidiaryId": subSidiaryId,
        "PageId": pageId,
        "PageName": pageName,
        "AccessDatetime": accessDatetime,
        "SystemId": systemId,
      };
}
