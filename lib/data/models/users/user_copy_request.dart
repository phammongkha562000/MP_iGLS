class UserCopyRequest {
  final String userNameOld;
  final String createUser;
  final String userIdNew;
  final String userName;
  final String email;
  final String password;

  UserCopyRequest({
    required this.userNameOld,
    required this.createUser,
    required this.userIdNew,
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "UserNameOld": userNameOld,
        "CreateUser": createUser,
        "UserIdNew": userIdNew,
        "UserName": userName,
        "Email": email,
        "Password": password,
      };
}
