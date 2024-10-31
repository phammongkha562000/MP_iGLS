class ChangePassRequest {
  ChangePassRequest({
    required this.oldPassword,
    required this.password,
    required this.userId,
    required this.updateUser,
  });

  String oldPassword;
  String password;
  String userId;
  String updateUser;

  Map<String, dynamic> toMap() => {
        "OldPassword": oldPassword,
        "Password": password,
        "UserId": userId,
        "UpdateUser": updateUser,
      };
}
