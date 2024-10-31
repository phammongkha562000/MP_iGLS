class CustomerBookingRes {
  int? blcount;
  dynamic blNo;
  String? bookingNo;
  String? carrier;
  String? carriername;
  int? cntrcount;
  String? cargoMode;
  String? carrierBcNo;
  String? createDate;
  String? createUser;
  String? destination;
  String? etd;
  String? finalDestination;
  String? origin;
  String? placename;
  dynamic vesselorFlight;
  String? voyage;

  CustomerBookingRes({
    this.blcount,
    this.blNo,
    this.bookingNo,
    this.carrier,
    this.carriername,
    this.cntrcount,
    this.cargoMode,
    this.carrierBcNo,
    this.createDate,
    this.createUser,
    this.destination,
    this.etd,
    this.finalDestination,
    this.origin,
    this.placename,
    this.vesselorFlight,
    this.voyage,
  });

  factory CustomerBookingRes.fromJson(Map<String, dynamic> json) =>
      CustomerBookingRes(
        blcount: json["BLCOUNT"],
        blNo: json["BLNo"],
        bookingNo: json["BookingNo"],
        carrier: json["CARRIER"],
        carriername: json["CARRIERNAME"],
        cntrcount: json["CNTRCOUNT"],
        cargoMode: json["CargoMode"],
        carrierBcNo: json["CarrierBCNo"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        destination: json["Destination"],
        etd: json["ETD"],
        finalDestination: json["FinalDestination"],
        origin: json["Origin"],
        placename: json["PLACENAME"],
        vesselorFlight: json["VesselorFlight"],
        voyage: json["Voyage"],
      );
}
