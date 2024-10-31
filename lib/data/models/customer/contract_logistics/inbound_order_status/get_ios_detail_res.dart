class GetIOSDetailRes {
  List<Items>? items;
  OrderDetail? orderDetail;
  List<OrderDocuments>? orderDocuments;
  List<OrderDts>? orderDts;
  List<OrderOthers>? orderOrgs;
  List<OrderOthers>? orderOthers;

  GetIOSDetailRes(
      {this.items,
      this.orderDetail,
      this.orderDocuments,
      this.orderDts,
      this.orderOrgs,
      this.orderOthers});

  GetIOSDetailRes.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    orderDetail = json['OrderDetail'] != null
        ? OrderDetail.fromJson(json['OrderDetail'])
        : null;
    if (json['OrderDocuments'] != null) {
      orderDocuments = <OrderDocuments>[];
      json['OrderDocuments'].forEach((v) {
        orderDocuments!.add(OrderDocuments.fromJson(v));
      });
    }
    if (json['OrderDts'] != null) {
      orderDts = <OrderDts>[];
      json['OrderDts'].forEach((v) {
        orderDts!.add(OrderDts.fromJson(v));
      });
    }
    if (json['OrderOrgs'] != null) {
      orderOrgs = <OrderOthers>[];
      json['OrderOrgs'].forEach((v) {
        orderOrgs!.add(OrderOthers.fromJson(v));
      });
    }
    if (json['OrderOthers'] != null) {
      orderOthers = <OrderOthers>[];
      json['OrderOthers'].forEach((v) {
        orderOthers!.add(OrderOthers.fromJson(v));
      });
    }
  }
}

class Items {
  dynamic expiredDate;
  int? gIQty;
  double? gRQty;
  String? grade;
  String? itemCode;
  String? itemDesc;
  String? itemStatus;
  String? lotCode;
  dynamic productionDate;
  double? qty;

  Items(
      {this.expiredDate,
      this.gIQty,
      this.gRQty,
      this.grade,
      this.itemCode,
      this.itemDesc,
      this.itemStatus,
      this.lotCode,
      this.productionDate,
      this.qty});

  Items.fromJson(Map<String, dynamic> json) {
    expiredDate = json['ExpiredDate'];
    gIQty = json['GIQty'];
    gRQty = json['GRQty'];
    grade = json['Grade'];
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    itemStatus = json['ItemStatus'];
    lotCode = json['LotCode'];
    productionDate = json['ProductionDate'];
    qty = json['Qty'];
  }
}

class OrderDetail {
  double? cODAmount;
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
  String? toDCCode;
  String? toOwnerShip;
  dynamic tripStatusName;
  dynamic truckType;
  dynamic updateDate;
  String? updateUser;
  String? waveGroup;

  OrderDetail(
      {this.cODAmount,
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
      this.toDCCode,
      this.toOwnerShip,
      this.tripStatusName,
      this.truckType,
      this.updateDate,
      this.updateUser,
      this.waveGroup});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    cODAmount = json['CODAmount'];
    clientRefNo = json['ClientRefNo'];
    contactCode = json['ContactCode'];
    createDate = json['CreateDate'];
    createUser = json['CreateUser'];
    deleteDate = json['DeleteDate'];
    deleteUser = json['DeleteUser'];
    isUse = json['IsUse'];
    ordStatus = json['OrdStatus'];
    ordStatusDesc = json['OrdStatusDesc'];
    ordeId = json['OrdeId'];
    orderNote = json['OrderNote'];
    orderType = json['OrderType'];
    orderTypeDesc = json['OrderTypeDesc'];
    ownerShip = json['OwnerShip'];
    receiptDate = json['ReceiptDate'];
    toDCCode = json['ToDCCode'];
    toOwnerShip = json['ToOwnerShip'];
    tripStatusName = json['TripStatusName'];
    truckType = json['TruckType'];
    updateDate = json['UpdateDate'];
    updateUser = json['UpdateUser'];
    waveGroup = json['WaveGroup'];
  }
}

class OrderDocuments {
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

  OrderDocuments(
      {this.createDate,
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
      this.updateUser});

  OrderDocuments.fromJson(Map<String, dynamic> json) {
    createDate = json['CreateDate'];
    createUser = json['CreateUser'];
    docNo = json['DocNo'];
    docRefType = json['DocRefType'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    fileSize = json['FileSize'];
    fileType = json['FileType'];
    refNoType = json['RefNoType'];
    refNoValue = json['RefNoValue'];
    updateDate = json['UpdateDate'];
    updateUser = json['UpdateUser'];
  }
}

class OrderDts {
  String? dateType;
  String? dateValue;
  String? dateValueString;
  int? itemNo;
  int? ordeId;

  OrderDts(
      {this.dateType,
      this.dateValue,
      this.dateValueString,
      this.itemNo,
      this.ordeId});

  OrderDts.fromJson(Map<String, dynamic> json) {
    dateType = json['DateType'];
    dateValue = json['DateValue'];
    dateValueString = json['DateValueString'];
    itemNo = json['ItemNo'];
    ordeId = json['OrdeId'];
  }
}

class OrderOthers {
  int? itemNo;
  int? ordeId;
  String? otherCode;
  String? otherValue;

  OrderOthers({this.itemNo, this.ordeId, this.otherCode, this.otherValue});

  OrderOthers.fromJson(Map<String, dynamic> json) {
    itemNo = json['ItemNo'];
    ordeId = json['OrdeId'];
    otherCode = json['OtherCode'];
    otherValue = json['OtherValue'];
  }
}
