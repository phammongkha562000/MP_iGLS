class PickingItemRequest {
  final int sBNo;
  final int sRItemNo;
  final double qty;
  final int oOrdNo;
  final int waveItemNo;
  final String pickDate;
  final String createUser;
  final String doneByStaff;
  final String waveNo;
  final String companyId;

  PickingItemRequest(
      {required this.sBNo,
      required this.sRItemNo,
      required this.qty,
      required this.oOrdNo,
      required this.waveItemNo,
      required this.pickDate,
      required this.createUser,
      required this.doneByStaff,
      required this.waveNo,
      required this.companyId});

  Map<String, dynamic> toJson() => {
        "SBNo": sBNo,
        "SRItemNo": sRItemNo,
        "Qty": qty,
        "CreateUser": createUser,
        "DoneByStaff": doneByStaff,
        "PickDate": pickDate,
        "OOrdNo": oOrdNo,
        "WaveNo": waveNo,
        "WaveItemNo": waveItemNo,
        "CompanyId": companyId,
      };
}
