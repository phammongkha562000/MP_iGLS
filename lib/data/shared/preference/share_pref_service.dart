import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String serverCode = 'server_code';
  static const String notificationServerName = 'notification_server_name';
  static const String serverAddress = 'server_address';
  static const String serverWcf = 'server_wcf';
  static const String serverHub = 'server_hub';
  static const String systemId = 'server_id';
  static const String token = 'token';
  static const String userName = 'user_name';
  static const String equipmentNo = 'equipment_no';
  static const String phoneNumber = 'phone_number';
  static const String password = 'password';
  static const String remember = 'remember';
  static const String cySite = 'cy_site';
  static const String formatN = "format_n";
  static const String notification = "notification";
  // *10/03/2023
  static const String serverSalary = "";
//15/05/2023
  static const String timeResume = "timeResume";
  //23/05/2023
  static const String isAllowBiometrics = "is_allow_biometrics";
  static const String isBiometrics = "is_biometrics";
//01/06/2024
  static const String isCheckVersion = "is_check_version";

  //10/10/2024
  static const String serverMPi = 'server_mpi';
  static const String deviceId = 'device_id';

//13/11/2023 - No delete
  static const String stdTripModeFreq = "std_trip_mode_freq";
  static const String mode = "mode";
  static List<String> listKey = [
    notificationServerName,
    token,
    cySite,
    formatN,
    notification,
    isCheckVersion
  ];
}

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _instance ??= SharedPreferencesService._internal();
  }

  static Future<void> reload() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.reload();
  }

  Future<void> setServerCode(String serverCode) async =>
      await _preferences!.setString(SharedPrefKeys.serverCode, serverCode);

  String? get serverCode => _preferences!.getString(SharedPrefKeys.serverCode);

  Future<void> setNotificationServerName(String notificationServerName) async =>
      await _preferences!.setString(
          SharedPrefKeys.notificationServerName, notificationServerName);

  String? get notificationServerName =>
      _preferences!.getString(SharedPrefKeys.notificationServerName);

  Future<void> setServerAddress(String serverAddress) async =>
      await _preferences!
          .setString(SharedPrefKeys.serverAddress, serverAddress);

  String? get serverAddress =>
      _preferences!.getString(SharedPrefKeys.serverAddress);
  Future<void> setServerWcf(String serverWcf) async =>
      await _preferences!.setString(SharedPrefKeys.serverWcf, serverWcf);

  String? get serverWcf => _preferences!.getString(SharedPrefKeys.serverWcf);

  Future<void> setServerHub(String serverHub) async =>
      await _preferences!.setString(SharedPrefKeys.serverHub, serverHub);

  String? get serverHub => _preferences!.getString(SharedPrefKeys.serverHub);

  Future<void> setServerMPi(String serverMPi) async =>
      await _preferences!.setString(SharedPrefKeys.serverMPi, serverMPi);

  String? get serverMPi => _preferences!.getString(SharedPrefKeys.serverMPi);

  Future<void> setSystemId(String systemId) async =>
      await _preferences!.setString(SharedPrefKeys.systemId, systemId);

  String? get systemId => _preferences!.getString(SharedPrefKeys.systemId);

  Future<void> setToken(String token) async =>
      await _preferences!.setString(SharedPrefKeys.token, token);

  String? get token => _preferences!.getString(SharedPrefKeys.token);

  Future<void> setUserName(String userName) async =>
      await _preferences!.setString(SharedPrefKeys.userName, userName);
  String? get userName => _preferences!.getString(SharedPrefKeys.userName);

  Future<void> setEquipmentNo(String equipmentNo) async =>
      await _preferences!.setString(SharedPrefKeys.equipmentNo, equipmentNo);

  String? get equipmentNo =>
      _preferences!.getString(SharedPrefKeys.equipmentNo);

  Future<void> setPassword(String password) async =>
      await _preferences!.setString(SharedPrefKeys.password, password);

  String? get password => _preferences!.getString(SharedPrefKeys.password);

  Future<void> setRemember(bool remember) async =>
      await _preferences!.setBool(SharedPrefKeys.remember, remember);

  bool? get remember => _preferences!.getBool(SharedPrefKeys.remember);

  Future<void> setCySite(String cySite) async =>
      await _preferences!.setString(SharedPrefKeys.cySite, cySite);

  String? get cySite => _preferences!.getString(SharedPrefKeys.cySite);

  Future<void> setFormatWithContact(String formatN) async =>
      await _preferences!.setString(SharedPrefKeys.formatN, formatN);
  String? get formatN => _preferences!.getString(SharedPrefKeys.formatN);

  Future<void> setNotification(bool notification) async =>
      await _preferences!.setBool(SharedPrefKeys.notification, notification);
  bool? get notification => _preferences!.getBool(SharedPrefKeys.notification);
  // *10/03/2023
  Future<void> setServerSalary(String serverSalary) async =>
      await _preferences!.setString(SharedPrefKeys.serverSalary, serverSalary);

  String? get serverSalary =>
      _preferences!.getString(SharedPrefKeys.serverSalary);

  //15/5/2023
  Future<void> setTimeResume(String timeResume) async =>
      await _preferences!.setString(SharedPrefKeys.timeResume, timeResume);
  String? get timeResume => _preferences!.getString(SharedPrefKeys.timeResume);
  //23/05/2023
  Future<void> setIsAllowBiometrics(bool isAllowBiometrics) async =>
      await _preferences!
          .setBool(SharedPrefKeys.isAllowBiometrics, isAllowBiometrics);
  bool? get isAllowBiometrics =>
      _preferences!.getBool(SharedPrefKeys.isAllowBiometrics);

  Future<void> setIsBiometrics(bool isBiometrics) async =>
      await _preferences!.setBool(SharedPrefKeys.isBiometrics, isBiometrics);
  bool? get isBiometrics => _preferences!.getBool(SharedPrefKeys.isBiometrics);

//13/11/2023
  Future<void> setStdTripModeFreq(String stdTripModeFreq) async =>
      await _preferences!
          .setString(SharedPrefKeys.stdTripModeFreq, stdTripModeFreq);
  String? get stdTripModeFreq =>
      _preferences!.getString(SharedPrefKeys.stdTripModeFreq);
  //remove key
  Future<void> remove(String key) async => await _preferences!.remove(key);

  Future<void> setMode(String serverCode) async =>
      await _preferences!.setString(SharedPrefKeys.mode, serverCode);

  String? get mode => _preferences!.getString(SharedPrefKeys.mode);

  //01/06/2024
  Future<void> setIsCheckVersion(bool isCheckVersion) async =>
      await _preferences!
          .setBool(SharedPrefKeys.isCheckVersion, isCheckVersion);
  bool? get isCheckVersion =>
      _preferences!.getBool(SharedPrefKeys.isCheckVersion);

  //10/10/2024
  Future<void> setDeviceId(String deviceId) async =>
      await _preferences!.setString(SharedPrefKeys.deviceId, deviceId);
  String? get deviceId => _preferences!.getString(SharedPrefKeys.deviceId);
}
