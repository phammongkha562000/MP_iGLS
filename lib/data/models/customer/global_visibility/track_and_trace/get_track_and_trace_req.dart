class GetTrackAndTraceReq {
  final String blNo;
  final String bookingNo;
  final String cntrNo;
  final String contactCode;
  final String destination;
  final String etdF;
  final String etdT;
  final String mblNo;
  final String origin;
  final String transitStatusCode;
  final String vessel;

  GetTrackAndTraceReq(
      {required this.blNo,
      required this.bookingNo,
      required this.cntrNo,
      required this.contactCode,
      required this.destination,
      required this.etdF,
      required this.etdT,
      required this.mblNo,
      required this.origin,
      required this.transitStatusCode,
      required this.vessel});

  Map<String, dynamic> toJson() => {
        "BLNo": blNo,
        "BookingNo": bookingNo,
        "CNTRNo": cntrNo,
        "ContactCode": contactCode,
        "Destination": destination,
        "ETDF": etdF,
        "ETDT": etdT,
        "MBLNo": mblNo,
        "Origin": origin,
        "TransitStatusCode": transitStatusCode,
        "Vessel": vessel,
      };
}
