class CustomerLoginReq {
  final String ip;
  final String passWord;
  final String systemId;
  final String userName;

  CustomerLoginReq({
    required this.ip,
    required this.passWord,
    required this.systemId,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
        "IP": ip,
        "PassWord": passWord,
        "SystemId": systemId,
        "UserName": userName,
      };
}
