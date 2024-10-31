class CustomerOOSDetailRes {
  List<Item>? items;
  List<Movement>? movements;
  OrderDetail? orderDetail;
  List<OrderDocument>? orderDocuments;
  List<OrderDt>? orderDts;
  OrderOrg? orderOrg;
  List<dynamic>? orderOthers;
  OrderTrip? orderTrip;

  CustomerOOSDetailRes({
    this.items,
    this.movements,
    this.orderDetail,
    this.orderDocuments,
    this.orderDts,
    this.orderOrg,
    this.orderOthers,
    this.orderTrip,
  });

  factory CustomerOOSDetailRes.fromJson(Map<String, dynamic> json) =>
      CustomerOOSDetailRes(
        items: json["Items"] == null
            ? []
            : List<Item>.from(json["Items"]!.map((x) => Item.fromJson(x))),
        movements: json["Movements"] == null
            ? []
            : List<Movement>.from(
                json["Movements"]!.map((x) => Movement.fromJson(x))),
        orderDetail: json["OrderDetail"] == null
            ? null
            : OrderDetail.fromJson(json["OrderDetail"]),
        orderDocuments: json["OrderDocuments"] == null
            ? []
            : List<OrderDocument>.from(
                json["OrderDocuments"]!.map((x) => OrderDocument.fromJson(x))),
        orderDts: json["OrderDts"] == null
            ? []
            : List<OrderDt>.from(
                json["OrderDts"]!.map((x) => OrderDt.fromJson(x))),
        orderOrg: json["OrderOrg"] == null
            ? null
            : OrderOrg.fromJson(json["OrderOrg"]),
        orderOthers: json["OrderOthers"] == null
            ? []
            : List<dynamic>.from(json["OrderOthers"]!.map((x) => x)),
        orderTrip: json["OrderTrip"] == null
            ? null
            : OrderTrip.fromJson(json["OrderTrip"]),
      );
}

class Item {
  dynamic expiredDate;
  double? giQty;
  int? grQty;
  String? grade;
  String? itemCode;
  String? itemDesc;
  dynamic itemStatus;
  String? lotCode;
  dynamic productionDate;
  double? qty;

  Item({
    this.expiredDate,
    this.giQty,
    this.grQty,
    this.grade,
    this.itemCode,
    this.itemDesc,
    this.itemStatus,
    this.lotCode,
    this.productionDate,
    this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        expiredDate: json["ExpiredDate"],
        giQty: json["GIQty"],
        grQty: json["GRQty"],
        grade: json["Grade"],
        itemCode: json["ItemCode"],
        itemDesc: json["ItemDesc"],
        itemStatus: json["ItemStatus"],
        lotCode: json["LotCode"],
        productionDate: json["ProductionDate"],
        qty: json["Qty"],
      );
}

class Movement {
  String? createDate;
  String? createUser;
  String? memo;
  String? processType;

  Movement({
    this.createDate,
    this.createUser,
    this.memo,
    this.processType,
  });

  factory Movement.fromJson(Map<String, dynamic> json) => Movement(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        memo: json["Memo"],
        processType: json["ProcessType"],
      );
}

class OrderDetail {
  double? codAmount;
  String? clientRefNo;
  String? contactCode;
  String? createDate;
  String? createUser;
  dynamic deleteDate;
  dynamic deleteUser;
  String? isUse;
  String? ordStatus;
  String? ordStatusDesc;
  int? ordeId;
  String? orderNote;
  String? orderType;
  String? orderTypeDesc;
  String? ownerShip;
  String? receiptDate;
  String? toDcCode;
  String? toOwnerShip;
  String? tripStatusName;
  dynamic truckType;
  dynamic updateDate;
  dynamic updateUser;
  String? waveGroup;

  OrderDetail({
    this.codAmount,
    this.clientRefNo,
    this.contactCode,
    this.createDate,
    this.createUser,
    this.deleteDate,
    this.deleteUser,
    this.isUse,
    this.ordStatus,
    this.ordStatusDesc,
    this.ordeId,
    this.orderNote,
    this.orderType,
    this.orderTypeDesc,
    this.ownerShip,
    this.receiptDate,
    this.toDcCode,
    this.toOwnerShip,
    this.tripStatusName,
    this.truckType,
    this.updateDate,
    this.updateUser,
    this.waveGroup,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        codAmount: json["CODAmount"],
        clientRefNo: json["ClientRefNo"],
        contactCode: json["ContactCode"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        deleteDate: json["DeleteDate"],
        deleteUser: json["DeleteUser"],
        isUse: json["IsUse"],
        ordStatus: json["OrdStatus"],
        ordStatusDesc: json["OrdStatusDesc"],
        ordeId: json["OrdeId"],
        orderNote: json["OrderNote"],
        orderType: json["OrderType"],
        orderTypeDesc: json["OrderTypeDesc"],
        ownerShip: json["OwnerShip"],
        receiptDate: json["ReceiptDate"],
        toDcCode: json["ToDCCode"],
        toOwnerShip: json["ToOwnerShip"],
        tripStatusName: json["TripStatusName"],
        truckType: json["TruckType"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
        waveGroup: json["WaveGroup"],
      );
}

class OrderDocument {
  String? createDate;
  String? createUser;
  int? docNo;
  String? docRefType;
  String? fileName;
  String? filePath;
  int? fileSize;
  String? fileType;
  String? refNoType;
  String? refNoValue;
  dynamic updateDate;
  dynamic updateUser;

  OrderDocument({
    this.createDate,
    this.createUser,
    this.docNo,
    this.docRefType,
    this.fileName,
    this.filePath,
    this.fileSize,
    this.fileType,
    this.refNoType,
    this.refNoValue,
    this.updateDate,
    this.updateUser,
  });

  factory OrderDocument.fromJson(Map<String, dynamic> json) => OrderDocument(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        docNo: json["DocNo"],
        docRefType: json["DocRefType"],
        fileName: json["FileName"],
        filePath: json["FilePath"],
        fileSize: json["FileSize"],
        fileType: json["FileType"],
        refNoType: json["RefNoType"],
        refNoValue: json["RefNoValue"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}

class OrderDt {
  String? dateType;
  String? dateValue;
  String? dateValueString;
  int? itemNo;
  int? ordeId;

  OrderDt({
    this.dateType,
    this.dateValue,
    this.dateValueString,
    this.itemNo,
    this.ordeId,
  });

  factory OrderDt.fromJson(Map<String, dynamic> json) => OrderDt(
        dateType: json["DateType"],
        dateValue: json["DateValue"],
        dateValueString: json["DateValueString"],
        itemNo: json["ItemNo"],
        ordeId: json["OrdeId"],
      );
}

class OrderOrg {
  int? itemNo;
  int? ordeId;
  String? orgAddr1;
  String? orgAddr2;
  String? orgAddr3;
  String? orgAddr4;
  String? orgArea;
  String? orgCity;
  String? orgCode;
  String? orgCountry;
  String? orgId;
  String? orgName;
  String? orgProvince;
  String? orgType;
  String? orgTypeDesc;
  String? orgZipCode;

  OrderOrg({
    this.itemNo,
    this.ordeId,
    this.orgAddr1,
    this.orgAddr2,
    this.orgAddr3,
    this.orgAddr4,
    this.orgArea,
    this.orgCity,
    this.orgCode,
    this.orgCountry,
    this.orgId,
    this.orgName,
    this.orgProvince,
    this.orgType,
    this.orgTypeDesc,
    this.orgZipCode,
  });

  factory OrderOrg.fromJson(Map<String, dynamic> json) => OrderOrg(
        itemNo: json["ItemNo"],
        ordeId: json["OrdeId"],
        orgAddr1: json["OrgAddr1"],
        orgAddr2: json["OrgAddr2"],
        orgAddr3: json["OrgAddr3"],
        orgAddr4: json["OrgAddr4"],
        orgArea: json["OrgArea"],
        orgCity: json["OrgCity"],
        orgCode: json["OrgCode"],
        orgCountry: json["OrgCountry"],
        orgId: json["OrgId"],
        orgName: json["OrgName"],
        orgProvince: json["OrgProvince"],
        orgType: json["OrgType"],
        orgTypeDesc: json["OrgTypeDesc"],
        orgZipCode: json["OrgZipCode"],
      );
}

class OrderTrip {
  String? equipTypeNo;
  String? equipmentCode;
  String? tripNo;

  OrderTrip({
    this.equipTypeNo,
    this.equipmentCode,
    this.tripNo,
  });

  factory OrderTrip.fromJson(Map<String, dynamic> json) => OrderTrip(
        equipTypeNo: json["EquipTypeNo"],
        equipmentCode: json["EquipmentCode"],
        tripNo: json["TripNo"],
      );
}
