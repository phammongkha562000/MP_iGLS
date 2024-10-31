class CashCostApprovalResponse {
  List<CashCostApprovalResult>? results;
  int? totalCount;
  int? totalPage;

  CashCostApprovalResponse({
    this.results,
    this.totalCount,
    this.totalPage,
  });

  factory CashCostApprovalResponse.fromJson(Map<String, dynamic> json) =>
      CashCostApprovalResponse(
        results: json["Results"] == null
            ? []
            : List<CashCostApprovalResult>.from(json["Results"]!
                .map((x) => CashCostApprovalResult.fromJson(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );
}

class CashCostApprovalResult {
  CashCostApprovalResult({
    this.items,
    this.itemGroup,
    this.name,
    this.total,
  });

  List<CashCostApproval>? items;
  List<List<CashCostApproval>>? itemGroup;
  String? name;
  double? total;

  factory CashCostApprovalResult.fromJson(Map<String, dynamic> json) =>
      CashCostApprovalResult(
        items: List<CashCostApproval>.from(
            json["Items"].map((x) => CashCostApproval.fromMap(x))),
        name: json["Name"],
        total: json["Total"],
      );

  CashCostApprovalResult copyWith({
    List<CashCostApproval>? items,
    String? name,
    double? total,
  }) =>
      CashCostApprovalResult(
        items: items ?? this.items,
        name: name ?? this.name,
        total: total ?? this.total,
      );
}

class CashCostApproval {
  CashCostApproval(
      {this.accountCode,
      this.accountDesc,
      this.amount,
      this.approvalDate,
      this.approvalUser,
      this.blNo,
      this.billingQty,
      this.cargoMode,
      this.carrierBcNo,
      this.cashHandler,
      this.contactCode,
      this.costSource,
      this.createDate,
      this.createUser,
      this.currency,
      this.docId,
      this.equipmentNo,
      this.equipmentType,
      this.payToContactName,
      this.paymentDate,
      this.paymentMode,
      this.postDate,
      this.postType,
      this.rate,
      this.taxCode,
      this.vendorInvNumber,
      this.woNo,
      this.isSelected});

  String? accountCode;
  String? accountDesc;
  double? amount;
  dynamic approvalDate;
  dynamic approvalUser;
  String? blNo;
  String? billingQty;
  String? cargoMode;
  String? carrierBcNo;
  String? cashHandler;
  String? contactCode;
  String? costSource;
  String? createDate;
  String? createUser;
  String? currency;
  int? docId;
  String? equipmentNo;
  String? equipmentType;
  String? payToContactName;
  dynamic paymentDate;
  dynamic paymentMode;
  dynamic postDate;
  dynamic postType;
  String? rate;
  String? taxCode;
  dynamic vendorInvNumber;
  String? woNo;
  bool? isSelected = false;
  CashCostApproval copyWith({
    String? accountCode,
    String? accountDesc,
    double? amount,
    dynamic approvalDate,
    dynamic approvalUser,
    String? blNo,
    String? billingQty,
    String? cargoMode,
    String? carrierBcNo,
    String? cashHandler,
    String? contactCode,
    String? costSource,
    String? createDate,
    String? createUser,
    String? currency,
    int? docId,
    String? equipmentNo,
    String? equipmentType,
    String? payToContactName,
    dynamic paymentDate,
    dynamic paymentMode,
    dynamic postDate,
    dynamic postType,
    String? rate,
    String? taxCode,
    dynamic vendorInvNumber,
    String? woNo,
    bool? isSelected,
  }) =>
      CashCostApproval(
          accountCode: accountCode ?? this.accountCode,
          accountDesc: accountDesc ?? this.accountDesc,
          amount: amount ?? this.amount,
          approvalDate: approvalDate ?? this.approvalDate,
          approvalUser: approvalUser ?? this.approvalUser,
          blNo: blNo ?? this.blNo,
          billingQty: billingQty ?? this.billingQty,
          cargoMode: cargoMode ?? this.cargoMode,
          carrierBcNo: carrierBcNo ?? this.carrierBcNo,
          cashHandler: cashHandler ?? this.cashHandler,
          contactCode: contactCode ?? this.contactCode,
          costSource: costSource ?? this.costSource,
          createDate: createDate ?? this.createDate,
          createUser: createUser ?? this.createUser,
          currency: currency ?? this.currency,
          docId: docId ?? this.docId,
          equipmentNo: equipmentNo ?? this.equipmentNo,
          equipmentType: equipmentType ?? this.equipmentType,
          payToContactName: payToContactName ?? this.payToContactName,
          paymentDate: paymentDate ?? this.paymentDate,
          paymentMode: paymentMode ?? this.paymentMode,
          postDate: postDate ?? this.postDate,
          postType: postType ?? this.postType,
          rate: rate ?? this.rate,
          taxCode: taxCode ?? this.taxCode,
          vendorInvNumber: vendorInvNumber ?? this.vendorInvNumber,
          woNo: woNo ?? this.woNo,
          isSelected: isSelected ?? this.isSelected);

  factory CashCostApproval.fromMap(Map<String, dynamic> json) =>
      CashCostApproval(
        accountCode: json["AccountCode"],
        accountDesc: json["AccountDesc"],
        amount: json["Amount"],
        approvalDate: json["ApprovalDate"],
        approvalUser: json["ApprovalUser"],
        blNo: json["BLNo"],
        billingQty: json["BillingQty"],
        cargoMode: json["CargoMode"],
        carrierBcNo: json["CarrierBCNo"],
        cashHandler: json["CashHandler"],
        contactCode: json["ContactCode"],
        costSource: json["CostSource"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        currency: json["Currency"],
        docId: json["DocId"],
        equipmentNo: json["EquipmentNo"],
        equipmentType: json["EquipmentType"],
        payToContactName: json["PayToContactName"],
        paymentDate: json["PaymentDate"],
        paymentMode: json["PaymentMode"],
        postDate: json["PostDate"],
        postType: json["PostType"],
        rate: json["Rate"],
        taxCode: json["TaxCode"],
        vendorInvNumber: json["VendorInvNumber"],
        woNo: json["WONo"],
      );
}
