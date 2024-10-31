class LoadingStatusSaveRequest {
  final String loadingMemo;
  final String dcCode;
  final String tripNo;
  final String loadingStart;
  final String loadingEnd;
  final String userID;

  LoadingStatusSaveRequest({
    required this.loadingMemo,
    required this.dcCode,
    required this.tripNo,
    required this.loadingStart,
    required this.loadingEnd,
    required this.userID,
  });

  Map<String, dynamic> toJson() => {
        "LoadingMemo": loadingMemo,
        "DCCode": dcCode,
        "TripNo": tripNo,
        "LoadingStart": loadingStart,
        "LoadingEnd": loadingEnd,
        "UserID": userID,
      };
}
