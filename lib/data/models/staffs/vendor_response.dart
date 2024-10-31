class VendorResponse {
  String? contactCode;
  String? contactName;

  VendorResponse({
    this.contactCode,
    this.contactName,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) => VendorResponse(
        contactCode: json["ContactCode"],
        contactName: json["ContactName"],
      );
}
