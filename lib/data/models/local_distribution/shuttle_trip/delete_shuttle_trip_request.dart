class DeleteShuttleTripRequest {
  DeleteShuttleTripRequest({
    required this.stId,
    required this.updateUser,
  });

  final int stId;
  final String updateUser;

  Map<String, dynamic> toJson() => {
        "STId": stId,
        "UpdateUser": updateUser,
      };
}
