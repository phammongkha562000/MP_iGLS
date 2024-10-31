class CustomerHaulageDailyReq {
  final String blNo;
  final String brachCode;
  final String cntrNo;
  final String company;
  final String contactCode;
  final String date;

  CustomerHaulageDailyReq({
    required this.blNo,
    required this.brachCode,
    required this.cntrNo,
    required this.company,
    required this.contactCode,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "BLNo": blNo,
        "BrachCode": brachCode,
        "CNTRNo": cntrNo,
        "Company": company,
        "ContactCode": contactCode,
        "Date": date,
      };
}
