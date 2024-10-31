class StockCountRequest {
  StockCountRequest({
    required this.contactCode,
    required this.dcCode,
    required this.countCode,
    required this.createUser,
    required this.round,
    required this.companyId,
  });

  String contactCode;
  String dcCode;
  String countCode;
  String createUser;
  int round;
  String companyId;

  Map<String, dynamic> toMap() => {
        "ContactCode": contactCode,
        "DCCode": dcCode,
        "CountCode": countCode,
        "CreateUser": createUser,
        "Round": round,
        "CompanyId": companyId,
      };
}
