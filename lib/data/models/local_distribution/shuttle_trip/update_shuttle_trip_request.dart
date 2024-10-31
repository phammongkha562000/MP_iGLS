class SaveShuttleTripRequest {
  int? sTId;
  final String dCCode;
  final String contactCode;
  final String startLoc;
  final String? startTime;
  final String invoiceNo;
  final double? qty;
  final String shipmentNo;
  final String? itemNote;
  final String tripMode;
  final String endLoc;
  final String? endTime;
  final String? createUser;
  final String? isPosted;
  final String? postedDate;
  final String? postUser;
  final String? tripNo;
  final String? updateDate;
  final String? updateUser;
  final String equipmentCode;
  String? sLat;
  String? sLon;
  String? eLat;
  String? eLon;

  SaveShuttleTripRequest(
      {this.sTId,
      required this.dCCode,
      required this.contactCode,
      required this.startLoc,
      this.startTime,
      required this.invoiceNo,
      this.qty,
      required this.shipmentNo,
      this.itemNote,
      required this.tripMode,
      required this.endLoc,
      this.endTime,
      this.createUser,
      this.isPosted,
      this.postedDate,
      this.postUser,
      this.tripNo,
      this.updateDate,
      this.updateUser,
      required this.equipmentCode,
      this.eLat,
      this.eLon,
      this.sLat,
      this.sLon});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'STId': sTId,
      'DCCode': dCCode,
      'ContactCode': contactCode,
      'StartLoc': startLoc,
      'StartTime': startTime,
      'InvoiceNo': invoiceNo,
      'Qty': qty,
      'ShipmentNo': shipmentNo,
      'ItemNote': itemNote,
      'TripMode': tripMode,
      'EndLoc': endLoc,
      'EndTime': endTime,
      'CreateUser': createUser,
      'IsPosted': isPosted,
      'PostedDate': postedDate,
      'PostUser': postUser,
      'TripNo': tripNo,
      'UpdateDate': updateDate,
      'UpdateUser': updateUser,
      'EquipmentCode': equipmentCode,
      'ELat': eLat,
      'ELon': eLon,
      'SLat': sLat,
      'SLon': sLon,
    };
  }
}
