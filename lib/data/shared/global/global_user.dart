class GlobalUser {
  String? fullname;
  String? phoneNo;
  String? password;
  bool? notification;


  String? get getPassword => password;
  set setPassword(String? value) => password = value;

  String? get getPhoneNo => phoneNo;
  set setPhoneNo(String? value) => phoneNo = value;

  String? get getFullname => fullname;
  set setFullname(String value) => fullname = value;

  bool? get getNotification => notification;
  set setNotification(bool value) => notification = value;
  bool? isNotification;
  bool? get getIsNotification => isNotification;
  set setIsNotification(bool? value) => isNotification = value;
}

GlobalUser globalUser = GlobalUser();
