class TimeLinePayload {
  List<TimeLine>? lstTimeLine;
  TimeLinePayload({
    this.lstTimeLine,
  });

  factory TimeLinePayload.fromJson(Map<String, dynamic> json) =>
      TimeLinePayload(
        lstTimeLine: json["Table"] == null
            ? []
            : List<TimeLine>.from(
                json["Table"]!.map((x) => TimeLine.fromJson(x))),
      );
}

class TimeLine {
  final int wplId;
  final String userId;
  final String lDate;
  final String ipAddress;

  TimeLine({
    required this.wplId,
    required this.userId,
    required this.lDate,
    required this.ipAddress,
  });

  factory TimeLine.fromJson(Map<String, dynamic> json) => TimeLine(
        wplId: json["WPLID"],
        userId: json["UserId"],
        lDate: json["LDate"],
        ipAddress: json["IPAddress"],
      );
}
