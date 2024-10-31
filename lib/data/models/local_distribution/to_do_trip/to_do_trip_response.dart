class TodoResponse {
  List<TodoResult>? results;
  int? totalCount;
  int? totalPage;

  TodoResponse({
    this.results,
    this.totalCount,
    this.totalPage,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) => TodoResponse(
        results: json["Results"] == null
            ? []
            : List<TodoResult>.from(
                json["Results"]!.map((x) => TodoResult.fromJson(x))),
        totalCount: json["TotalCount"],
        totalPage: json["TotalPage"],
      );

  Map<String, dynamic> toJson() => {
        "Results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "TotalCount": totalCount,
        "TotalPage": totalPage,
      };
}

class TodoResult {
  dynamic atd;
  dynamic atp;
  dynamic completeTime;
  String? contactCode;
  dynamic ddcId;
  dynamic driverTripType;
  dynamic driverTripTypeDesc;
  String? eta;
  String? etp;
  String? picAddress;
  String? picCode;
  String? picName;
  String? shipToAddress;
  String? shipToCode;
  String? shipToName;
  int? totalOrder;
  dynamic tripMemo;
  String? tripNo;
  String? tripStatus;
  String? tripType;

  TodoResult({
    this.atd,
    this.atp,
    this.completeTime,
    this.contactCode,
    this.ddcId,
    this.driverTripType,
    this.driverTripTypeDesc,
    this.eta,
    this.etp,
    this.picAddress,
    this.picCode,
    this.picName,
    this.shipToAddress,
    this.shipToCode,
    this.shipToName,
    this.totalOrder,
    this.tripMemo,
    this.tripNo,
    this.tripStatus,
    this.tripType,
  });

  factory TodoResult.fromJson(Map<String, dynamic> json) => TodoResult(
        atd: json["ATD"],
        atp: json["ATP"],
        completeTime: json["CompleteTime"],
        contactCode: json["ContactCode"],
        ddcId: json["DDCId"],
        driverTripType: json["DriverTripType"],
        driverTripTypeDesc: json["DriverTripTypeDesc"],
        eta: json["ETA"],
        etp: json["ETP"],
        picAddress: json["PicAddress"],
        picCode: json["PicCode"],
        picName: json["PicName"],
        shipToAddress: json["ShipToAddress"],
        shipToCode: json["ShipToCode"],
        shipToName: json["ShipToName"],
        totalOrder: json["TotalOrder"],
        tripMemo: json["TripMemo"],
        tripNo: json["TripNo"],
        tripStatus: json["TripStatus"],
        tripType: json["TripType"],
      );

  Map<String, dynamic> toJson() => {
        "ATD": atd,
        "ATP": atp,
        "CompleteTime": completeTime,
        "ContactCode": contactCode,
        "DDCId": ddcId,
        "DriverTripType": driverTripType,
        "DriverTripTypeDesc": driverTripTypeDesc,
        "ETA": eta,
        "ETP": etp,
        "PicAddress": picAddress,
        "PicCode": picCode,
        "PicName": picName,
        "ShipToAddress": shipToAddress,
        "ShipToCode": shipToCode,
        "ShipToName": shipToName,
        "TotalOrder": totalOrder,
        "TripMemo": tripMemo,
        "TripNo": tripNo,
        "TripStatus": tripStatus,
        "TripType": tripType,
      };
  static String getStatusDescription(String status) {
    String statusDesc = "";
    switch (status) {
      case "PLAN":
        statusDesc = "Plan";
        break;
      case "CONFIRM":
        statusDesc = "Confirmed";
        break;
      case "PICKUP_ARRIVAL":
        statusDesc = "Pickup Arrival";
        break;
      case "START_DELIVERY":
        statusDesc = "Start Delivery";
        break;
      case "COMPLETED":
        statusDesc = "Completed";
        break;
    }
    return statusDesc;
  }

  static String getIconBasedOnStatus(String status) {
    String iconUrl = "";
    switch (status) {
      case "PLAN":
        iconUrl = "assets/icons/icon_confirm_status.webp";
        break;
      case "CONFIRM":
        iconUrl = "assets/icons/icon_confirm_status.webp";
        break;
      case "PICKUP_ARRIVAL":
        iconUrl = "assets/icons/icon_start_delivery_status.webp";
        break;
      case "START_DELIVERY":
        iconUrl = "assets/icons/icon_start_delivery_status.webp";
        break;
      case "COMPLETED":
        iconUrl = "assets/icons/icon_completed_status.webp";
        break;
    }
    return iconUrl;
  }
}


// class ToDoTripResponse {
//   ToDoTripResponse({
//     this.normalTrip,
//     this.simpleTrip,
//   });

//   List<NormalTrip>? normalTrip;
//   List<SimpleTrip>? simpleTrip;

//   ToDoTripResponse copyWith({
//     List<NormalTrip>? normalTrip,
//     List<SimpleTrip>? simpleTrip,
//   }) =>
//       ToDoTripResponse(
//         normalTrip: normalTrip ?? this.normalTrip,
//         simpleTrip: simpleTrip ?? this.simpleTrip,
//       );

//   factory ToDoTripResponse.fromMap(Map<String, dynamic> json) =>
//       ToDoTripResponse(
//         normalTrip: List<NormalTrip>.from(
//             json["NormalTrip"].map((x) => NormalTrip.fromMap(x))),
//         simpleTrip: List<SimpleTrip>.from(
//             json["SimpleTrip"].map((x) => SimpleTrip.fromMap(x))),
//       );
// }

// class NormalTrip {
//   NormalTrip({
//     this.contactCode,
//     this.driverTripType,
//     this.driverTripTypeDesc,
//     this.eta,
//     this.etp,
//     this.picAddress,
//     this.picCode,
//     this.picName,
//     this.shipToAddress,
//     this.shipToCode,
//     this.shipToName,
//     this.totalOrder,
//     this.tripNo,
//     this.tripStatus,
//   });

//   String? contactCode;
//   dynamic driverTripType;
//   dynamic driverTripTypeDesc;
//   String? eta;
//   String? etp;
//   String? picAddress;
//   String? picCode;
//   String? picName;
//   String? shipToAddress;
//   String? shipToCode;
//   String? shipToName;
//   int? totalOrder;
//   String? tripNo;
//   String? tripStatus;

//   factory NormalTrip.fromMap(Map<String, dynamic> json) => NormalTrip(
//         contactCode: json["ContactCode"],
//         driverTripType: json["DriverTripType"],
//         driverTripTypeDesc: json["DriverTripTypeDesc"],
//         eta: json["ETA"],
//         etp: json["ETP"],
//         picAddress: json["PicAddress"],
//         picCode: json["PicCode"],
//         picName: json["PicName"],
//         shipToAddress: json["ShipToAddress"],
//         shipToCode: json["ShipToCode"],
//         shipToName: json["ShipToName"],
//         totalOrder: json["TotalOrder"],
//         tripNo: json["TripNo"],
//         tripStatus: json["TripStatus"],
//       );

//   static String getStatusDescription(String status) {
//     String statusDesc = "";
//     switch (status) {
//       case "PLAN":
//         statusDesc = "Plan";
//         break;
//       case "CONFIRM":
//         statusDesc = "Confirmed";
//         break;
//       case "PICKUP_ARRIVAL":
//         statusDesc = "Pickup Arrival";
//         break;
//       case "START_DELIVERY":
//         statusDesc = "Start Delivery";
//         break;
//       case "COMPLETED":
//         statusDesc = "Completed";
//         break;
//     }
//     return statusDesc;
//   }

//   static String getIconBasedOnStatus(String status) {
//     String iconUrl = "";
//     switch (status) {
//       case "PLAN":
//         iconUrl = "assets/icons/icon_confirm_status.webp";
//         break;
//       case "CONFIRM":
//         iconUrl = "assets/icons/icon_confirm_status.webp";
//         break;
//       case "PICKUP_ARRIVAL":
//         iconUrl = "assets/icons/icon_start_delivery_status.webp";
//         break;
//       case "START_DELIVERY":
//         iconUrl = "assets/icons/icon_start_delivery_status.webp";
//         break;
//       case "COMPLETED":
//         iconUrl = "assets/icons/icon_completed_status.webp";
//         break;
//     }
//     return iconUrl;
//   }
// }

// class SimpleTrip {
//   SimpleTrip({
//     this.atd,
//     this.atp,
//     this.completeTime,
//     this.contactCode,
//     this.driverTripType,
//     this.driverTripTypeDesc,
//     this.eta,
//     this.etp,
//     this.tripMemo,
//     this.tripNo,
//     this.tripStatus,
//   });

//   String? atd;
//   String? atp;
//   String? completeTime;
//   String? contactCode;
//   String? driverTripType;
//   String? driverTripTypeDesc;
//   String? eta;
//   String? etp;
//   String? tripMemo;
//   String? tripNo;
//   String? tripStatus;

//   factory SimpleTrip.fromMap(Map<String, dynamic> json) => SimpleTrip(
//         atd: json["ATD"],
//         atp: json["ATP"],
//         completeTime: json["CompleteTime"],
//         contactCode: json["ContactCode"],
//         driverTripType: json["DriverTripType"],
//         driverTripTypeDesc: json["DriverTripTypeDesc"],
//         eta: json["ETA"],
//         etp: json["ETP"],
//         tripMemo: json["TripMemo"],
//         tripNo: json["TripNo"],
//         tripStatus: json["TripStatus"],
//       );

//   static String getIconBasedOnStatus(String status) {
//     String iconUrl = "";
//     switch (status) {
//       case "PLAN":
//         iconUrl = "assets/images/icon_confirm_status.png";
//         break;
//       case "CONFIRM":
//         iconUrl = "assets/images/icon_confirm_status.png";
//         break;
//       case "PICKUP_ARRIVAL":
//         iconUrl = "assets/images/icon_start_delivery_status.png";
//         break;
//       case "START_DELIVERY":
//         iconUrl = "assets/images/icon_start_delivery_status.png";
//         break;
//       case "COMPLETED":
//         iconUrl = "assets/images/icon_completed_status.png";
//         break;
//     }
//     return iconUrl;
//   }
// }
