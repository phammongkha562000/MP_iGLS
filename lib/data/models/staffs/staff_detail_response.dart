class StaffDetailResponse {
  List<StaffGetDetail1>? getDetail1;
  List<StaffGetDetail2>? getDetail2;

  StaffDetailResponse({
    this.getDetail1,
    this.getDetail2,
  });

  factory StaffDetailResponse.fromJson(Map<String, dynamic> json) =>
      StaffDetailResponse(
        getDetail1: json["GetDetail1"] == null
            ? []
            : List<StaffGetDetail1>.from(
                json["GetDetail1"]!.map((x) => StaffGetDetail1.fromJson(x))),
        getDetail2: json["GetDetail2"] == null
            ? []
            : List<StaffGetDetail2>.from(
                json["GetDetail2"]!.map((x) => StaffGetDetail2.fromJson(x))),
      );
}

class StaffGetDetail1 {
  String? createDate;
  String? createUser;
  String? dcCode;
  dynamic dateOfJoined;
  String? defaultEquipment;
  String? driverLicenseNo;
  String? icNo;
  String? isUse;
  String? mobileNo;
  String? remark;
  dynamic resignedDate;
  String? roleType;
  String? staffName;
  String? staffUserId;
  String? statusWorking;
  String? updateDate;
  String? updateUser;
  dynamic vendorCode;

  StaffGetDetail1({
    this.createDate,
    this.createUser,
    this.dcCode,
    this.dateOfJoined,
    this.defaultEquipment,
    this.driverLicenseNo,
    this.icNo,
    this.isUse,
    this.mobileNo,
    this.remark,
    this.resignedDate,
    this.roleType,
    this.staffName,
    this.staffUserId,
    this.statusWorking,
    this.updateDate,
    this.updateUser,
    this.vendorCode,
  });

  factory StaffGetDetail1.fromJson(Map<String, dynamic> json) =>
      StaffGetDetail1(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        dcCode: json["DCCode"],
        dateOfJoined: json["DateOfJoined"],
        defaultEquipment: json["DefaultEquipment"],
        driverLicenseNo: json["DriverLicenseNo"],
        icNo: json["ICNo"],
        isUse: json["IsUse"],
        mobileNo: json["MobileNo"],
        remark: json["Remark"],
        resignedDate: json["ResignedDate"],
        roleType: json["RoleType"],
        staffName: json["StaffName"],
        staffUserId: json["StaffUserId"],
        statusWorking: json["StatusWorking"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        vendorCode: json["VendorCode"],
      );
}

class StaffGetDetail2 {
  String? dcCode;
  String? staffUserId;

  StaffGetDetail2({
    this.dcCode,
    this.staffUserId,
  });

  factory StaffGetDetail2.fromJson(Map<String, dynamic> json) =>
      StaffGetDetail2(
        dcCode: json["DCCode"],
        staffUserId: json["StaffUserId"],
      );
}
