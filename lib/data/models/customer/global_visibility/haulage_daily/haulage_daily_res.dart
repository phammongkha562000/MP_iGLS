class CustomerHaulageDailyRes {
  List<HaulageDailyDetail>? details;
  List<HaulageDailySumary>? sumary;

  CustomerHaulageDailyRes({
    this.details,
    this.sumary,
  });

  factory CustomerHaulageDailyRes.fromJson(Map<String, dynamic> json) =>
      CustomerHaulageDailyRes(
        details: json["Details"] == null
            ? []
            : List<HaulageDailyDetail>.from(
                json["Details"]!.map((x) => HaulageDailyDetail.fromJson(x))),
        sumary: json["Sumary"] == null
            ? []
            : List<HaulageDailySumary>.from(
                json["Sumary"]!.map((x) => HaulageDailySumary.fromJson(x))),
      );

 
}

class HaulageDailyDetail {
  dynamic actualEnd;
  dynamic actualStart;
  String? blNo;
  String? cntrNo;
  String? carrierBcNo;
  String? contactCode;
  dynamic gpsVendor;
  String? mode;
  dynamic tractor;
  String? updateByMb;
  dynamic updateUser;
  int? woItemNo;
  String? woNo;
  String? staffMobileNo;
  String? staffName;

  HaulageDailyDetail(
      {this.actualEnd,
      this.actualStart,
      this.blNo,
      this.cntrNo,
      this.carrierBcNo,
      this.contactCode,
      this.gpsVendor,
      this.mode,
      this.tractor,
      this.updateByMb,
      this.updateUser,
      this.woItemNo,
      this.woNo,
      this.staffMobileNo,
      this.staffName});

  factory HaulageDailyDetail.fromJson(Map<String, dynamic> json) =>
      HaulageDailyDetail(
        actualEnd: json["ActualEnd"],
        actualStart: json["ActualStart"],
        blNo: json["BLNo"],
        cntrNo: json["CNTRNo"],
        carrierBcNo: json["CarrierBCNo"],
        contactCode: json["ContactCode"],
        gpsVendor: json["GPSVendor"],
        mode: json["Mode"],
        tractor: json["Tractor"],
        updateByMb: json["UpdateByMB"],
        updateUser: json["UpdateUser"],
        woItemNo: json["WOItemNo"],
        woNo: json["WONo"],
        staffMobileNo: json["StaffMobileNo"],
        staffName: json["StaffName"],
      );

 
}

class  HaulageDailySumary {
  String? contactCode;
  int? done;
  int? progress;
  int? rate;
  int? trips;

  HaulageDailySumary({
    this.contactCode,
    this.done,
    this.progress,
    this.rate,
    this.trips,
  });

  factory HaulageDailySumary.fromJson(Map<String, dynamic> json) =>
      HaulageDailySumary(
        contactCode: json["ContactCode"],
        done: json["Done"],
        progress: json["Progress"],
        rate: json["Rate"],
        trips: json["Trips"],
      );

  
}
