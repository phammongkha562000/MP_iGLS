class UpdateWorkOrderRequest {
  UpdateWorkOrderRequest(
      {required this.woTaskId,
      required this.dataValue,
      required this.dataType,
      required this.updateUser,
      required this.sealNo});

  int woTaskId;
  String dataValue;
  int dataType;
  String updateUser;
  String sealNo;

  Map<String, dynamic> toMap() => {
        "WOTaskId": woTaskId,
        "DataValue": dataValue,
        "DataType": dataType,
        "UpdateUser": updateUser,
        "SealNo": sealNo,
      };
}
