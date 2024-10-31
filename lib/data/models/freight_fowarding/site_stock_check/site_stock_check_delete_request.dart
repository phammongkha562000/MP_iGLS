class SiteStockCheckDeleteRequest {
  final int trsId;
  final String updateUser;

  SiteStockCheckDeleteRequest({
    required this.trsId,
    required this.updateUser,
  });



  Map<String, dynamic> toJson() => {
        "TRSId": trsId,
        "UpdateUser": updateUser,
      };
}
