class GlobalApp {
  String? version;
  get getVersion => version;
  set setVersion(value) => version = value;

  String? versionBuild;
  String? get getVersionBuild => versionBuild;
  set setVersionBuild(String? value) => versionBuild = value;

  bool? isLogin;
  get getIsLogin => isLogin;
  set setIsLogin(value) => isLogin = value;

  String? serverHub;
  String? get getServerHub => serverHub;
  set setServerHub(String value) => serverHub = value;

  int? countNotification;
  int? get getCountNotification => countNotification;
  set setCountNotification(int? value) => countNotification = value;

  String? token;
  String? get getToken => token;
  set setToken(String value) => token = value;

  bool? isInitLang;
  bool? get getIsInitLang => isInitLang;
  set setIsInitLang(bool value) => isInitLang = value;

  bool? isAllowance;
  bool? get getIsAllowance => isAllowance;
  set setIsAllowance(bool value) => isAllowance = value;
  
}

GlobalApp globalApp = GlobalApp();
