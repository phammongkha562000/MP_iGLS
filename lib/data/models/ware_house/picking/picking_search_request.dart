class PickingSearchRequest {
  final String contactCode;
  final String dcCode;
  final String companyId;
  final String searchType;
  final String searchValue;

  PickingSearchRequest({
    required this.contactCode,
    required this.dcCode,
    required this.companyId,
    required this.searchType,
    required this.searchValue,
  });

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "DCCode": dcCode,
        "CompanyId": companyId,
        "SearchType": searchType,
        "SearchValue": searchValue,
      };
}
