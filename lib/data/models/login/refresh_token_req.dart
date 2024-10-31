class RefreshTokenReq {
  final String userName;
  final String systemId;
  final String accessToken;
  final String refreshToken;

  RefreshTokenReq({
    required this.userName,
    required this.systemId,
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "SystemId": systemId,
        "AccessToken": accessToken,
        "RefreshToken": refreshToken,
      };
}
