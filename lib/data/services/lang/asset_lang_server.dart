import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';
import 'package:igls_new/data/global/global.dart';

import '../../../businesses_logics/config/serverconfig.dart';
import '../../shared/preference/share_pref_service.dart';
import '../services.dart';

class DioAssetLoader extends AssetLoader {
  const DioAssetLoader();

  @override
  Future<Map<String, dynamic>> load(
    String path,
    Locale locale,
  ) async {
    try {
      if (globalApp.isInitLang == false) {
        log("GET LANG BY ASSETS - init");
        var driverLanguage =
            await getDefaultLanguageFromAssets(locale.languageCode);
        return driverLanguage;
      }
      final sharedPref = await SharedPreferencesService.instance;
      final serverCode = sharedPref.serverCode ?? ServerMode.prod;
      if (serverCode != '') {
        ServerInfo serverInfo = ServerConfig.getAddressServerInfo(serverCode);
        final serverUrl = serverInfo.serverAddress;
        var url =
            "$serverUrl/MB2/MbSvc2.svc/GetUserLanguage?lang=${locale.languageCode.toUpperCase()}";
        BaseOptions options = BaseOptions(
          baseUrl: url,
          method: "GET",
        );

        Dio dio = Dio(options);

        var response = await dio.get(url);
        if (response.statusCode == 200) {
          String strData = response.data["payload"];

          var jsonData = jsonDecode(strData);
          log("GET LANG BY SERVER");

          return jsonData;
        } else {
          log("GET LANG BY ASSETS");
          var driverLanguage =
              await getDefaultLanguageFromAssets(locale.languageCode);
          return driverLanguage;
        }
      } else {
        log("GET LANG BY ASSETS");
        var driverLanguage =
            await getDefaultLanguageFromAssets(locale.languageCode);
        return driverLanguage;
      }
    } catch (e) {
      log("GET LANG BY ASSETS");
      var driverLanguage =
          await getDefaultLanguageFromAssets(locale.languageCode);
      return driverLanguage;
    }
  }

  Future getDefaultLanguageFromAssets(String locale) async {
    try {
      final assetPath = 'assets/lang/$locale.json';
      final languageString = await rootBundle.loadString(assetPath);
      var languageJson = jsonDecode(languageString);
      return languageJson;
    } catch (e) {
      log('Error loading default language asset: $e');
      return null;
    }
  }
}
