class UpdateTrailerRequest {
  final String woNo;
  final String woTaskId;
  final String trailerNo;
  final String updateUser;
  UpdateTrailerRequest({
    required this.woNo,
    required this.woTaskId,
    required this.trailerNo,
    required this.updateUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'WONo': woNo,
      'WOTaskId': woTaskId,
      'TrailerNo': trailerNo,
      'UpdateUser': updateUser,
    };
  }
}

class WorkTaskUpdateNoteRequest {
  final String woTaskId;
  final String driverMemo;
  final String userId;

  WorkTaskUpdateNoteRequest({
    required this.woTaskId,
    required this.driverMemo,
    required this.userId,
  });
  Map<String, dynamic> toMap() {
    return {
      'WOTaskId': woTaskId,
      'DriverMemo': driverMemo,
      'UserId': userId,
    };
  }
}
