class VendorRequest {
  final String contactCode;
  final String contactName;
  final String contactType;
  final String country;
  final int isUse;

  VendorRequest({
    required this.contactCode,
    required this.contactName,
    required this.contactType,
    required this.country,
    required this.isUse,
  });

  Map<String, dynamic> toJson() => {
        "ContactCode": contactCode,
        "ContactName": contactName,
        "ContactType": contactType,
        "Country": country,
        "IsUse": isUse,
      };
}
