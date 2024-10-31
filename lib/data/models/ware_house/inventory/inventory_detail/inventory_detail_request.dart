class InventoryDetailRequest {
  InventoryDetailRequest({
    required this.sbNo,
    required this.contactCode,
    required this.dcCode,
    required this.companyId,
  });

  int sbNo;
  String contactCode;
  String dcCode;
  String companyId;

  Map<String, dynamic> toMap() => {
        "SBNo": sbNo,
        "ContactCode": contactCode,
        "DCCode": dcCode,
        "CompanyId": companyId,
      };
}
