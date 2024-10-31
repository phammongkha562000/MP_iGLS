class CustomerBookingReq {
  final String bookingNo;
  final String carrierBcNo;
  final String contactCode;
  final String destination;
  final String etdf;
  final String etdt;
  final String vessel;

  CustomerBookingReq({
    required this.bookingNo,
    required this.carrierBcNo,
    required this.contactCode,
    required this.destination,
    required this.etdf,
    required this.etdt,
    required this.vessel,
  });

  Map<String, dynamic> toJson() => {
        "BookingNo": bookingNo,
        "CarrierBCNo": carrierBcNo,
        "ContactCode": contactCode,
        "Destination": destination,
        "ETDF": etdf,
        "ETDT": etdt,
        "Vessel": vessel,
      };
}
