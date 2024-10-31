class ShuttleTripRequest {
  String? isPosted;
  final String dTF;
  final String dTT;
  final String contactCode;
  final String dCCode;
  String? from;
  String? to;
  final String? driverID;
  ShuttleTripRequest(
      {this.isPosted,
      required this.dTF,
      required this.dTT,
      required this.contactCode,
      required this.dCCode,
      this.from,
      this.to,
      required this.driverID});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'IsPosted': isPosted,
      'DTF': dTF,
      'DTT': dTT,
      'ContactCode': contactCode,
      'DCCode': dCCode,
      'From': from,
      'To': to,
      'DriverID': driverID
    };
  }
}
