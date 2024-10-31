class AnnouncementResponse {
  AnnouncementResponse({
    this.agreedDate,
    this.annId,
    this.annType,
    this.annTypeDesc,
    this.comment,
    this.contents,
    this.createDate,
    this.createUser,
    this.expireDate,
    this.requestforDriverAgreement,
    this.subject,
    this.updateUser,
  });

  String? agreedDate;
  int? annId;
  String? annType;
  String? annTypeDesc;
  String? comment;
  String? contents;
  String? createDate;
  String? createUser;
  String? expireDate;
  String? requestforDriverAgreement;
  String? subject;
  String? updateUser;

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) =>
      AnnouncementResponse(
        agreedDate: json["AgreedDate"],
        annId: json["AnnId"],
        annType: json["AnnType"],
        annTypeDesc: json["AnnTypeDesc"],
        comment: json["Comment"],
        contents: json["Contents"],
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        expireDate: json["ExpireDate"],
        requestforDriverAgreement: json["RequestforDriverAgreement"],
        subject: json["Subject"],
        updateUser: json["UpdateUser"],
      );
}
