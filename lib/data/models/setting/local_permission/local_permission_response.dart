class LocalRespone {
  LocalRespone({
    this.dcLocal,
    this.contactLocal,
  });

  List<DcLocal>? dcLocal;
  List<ContactLocal>? contactLocal;

  factory LocalRespone.fromJson(Map<String, dynamic> json) => LocalRespone(
        dcLocal:
            List<DcLocal>.from(json["DCLocal"].map((x) => DcLocal.fromJson(x))),
        contactLocal: List<ContactLocal>.from(
            json["contactLocal"].map((x) => ContactLocal.fromJson(x))),
      );
}

class ContactLocal {
  ContactLocal({
    this.contactCode,
    this.contactName,
  });

  String? contactCode;
  String? contactName;

  factory ContactLocal.fromJson(Map<String, dynamic> json) => ContactLocal(
        contactCode: json["ContactCode"],
        contactName: json["ContactName"],
      );
}

class DcLocal {
  DcLocal({this.branchCode, this.dcCode, this.dcDesc, this.isSelected});

  String? branchCode;
  String? dcCode;
  String? dcDesc;
  bool? isSelected = false;

  DcLocal copyWith({
    String? branchCode,
    String? dcCode,
    String? dcDesc,
    bool? isSelected,
  }) =>
      DcLocal(
          branchCode: branchCode ?? this.branchCode,
          dcCode: dcCode ?? this.dcCode,
          dcDesc: dcDesc ?? this.dcDesc,
          isSelected: isSelected ?? this.isSelected);
  factory DcLocal.fromJson(Map<String, dynamic> json) => DcLocal(
        branchCode: json["BranchCode"],
        dcCode: json["DCCode"],
        dcDesc: json["DCDesc"],
      );
}
