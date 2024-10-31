class UserResetPwdRequest {
  final String userId;
  final String password;
  final String updateUser;

  UserResetPwdRequest({
    required this.userId,
    required this.password,
    required this.updateUser,
  });

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Password": password,
        "UpdateUser": updateUser,
      };
}
