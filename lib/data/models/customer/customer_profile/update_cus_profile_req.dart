class UpdateCusProfileReq {
  String? userId;
  String? userName;
  String? email;
  String? updateUser;
  String? language;
  dynamic userRolePosition;
  String? defaultClient;
  String? subsidiary;

  UpdateCusProfileReq(
      {this.userId,
      this.userName,
      this.email,
      this.updateUser,
      this.language,
      this.userRolePosition,
      this.defaultClient,
      this.subsidiary});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['Email'] = email;
    data['UpdateUser'] = updateUser;
    data['Language'] = language;
    data['UserRolePosition'] = userRolePosition;
    data['DefaultClient'] = defaultClient;
    data['Subsidiary'] = subsidiary;
    return data;
  }
}
