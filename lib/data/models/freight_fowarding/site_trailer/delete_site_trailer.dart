class DeleteSiteTrailerReq {
  final int trlId;
  final String updateUser;

  DeleteSiteTrailerReq({
    required this.trlId,
    required this.updateUser,
  });

  Map<String, dynamic> toJson() => {
        "TRLId": trlId,
        "UpdateUser": updateUser,
      };
}
