class SaveLoadingStatusRequest {
  final String loadingMemo;
  final String dcCode;
  final String tripNo;
  final dynamic loadingStart;
  final dynamic loadingEnd;

  SaveLoadingStatusRequest({
    required this.loadingMemo,
    required this.dcCode,
    required this.tripNo,
    required this.loadingStart,
    required this.loadingEnd,
  });

  Map<String, dynamic> toJson() => {
        "LoadingMemo": loadingMemo,
        "DCCode": dcCode,
        "TripNo": tripNo,
        "LoadingStart": loadingStart,
        "LoadingEnd": loadingEnd,
      };
}
