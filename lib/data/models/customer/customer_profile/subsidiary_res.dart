class SubsidiaryRes {
  String? address1;
  String? address2;
  String? address3;
  dynamic city;
  String? companyCode;
  String? countryId;
  String? currency;
  String? fax;
  String? subsidiaryId;
  String? subsidiaryName;
  String? taxCode;
  String? tel;
  String? www;
  String? zipCode;

  SubsidiaryRes({
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.companyCode,
    this.countryId,
    this.currency,
    this.fax,
    this.subsidiaryId,
    this.subsidiaryName,
    this.taxCode,
    this.tel,
    this.www,
    this.zipCode,
  });

  factory SubsidiaryRes.fromJson(Map<String, dynamic> json) => SubsidiaryRes(
        address1: json["Address1"],
        address2: json["Address2"],
        address3: json["Address3"],
        city: json["City"],
        companyCode: json["CompanyCode"],
        countryId: json["CountryId"],
        currency: json["Currency"],
        fax: json["Fax"],
        subsidiaryId: json["SubsidiaryId"],
        subsidiaryName: json["SubsidiaryName"],
        taxCode: json["TaxCode"],
        tel: json["Tel"],
        www: json["WWW"],
        zipCode: json["ZipCode"],
      );
}
