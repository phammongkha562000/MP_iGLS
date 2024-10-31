// import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:igls_new/app.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/global/global.dart';
import 'package:igls_new/data/services/data_clean/data_helper.dart';

import 'package:igls_new/data/services/firebase_cloud_message/fcm_services.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/lang/asset_lang_server.dart';
import 'package:igls_new/data/services/location/location_helper.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'businesses_logics/bloc/general/general_bloc.dart';

GlobalKey globalKeyMain = GlobalKey();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  RemoteNotification? notification = message?.notification;
  if (notification != null &&
      notification.title != null &&
      notification.title!.contains("[VERSION]")) {
    final sharedPref = await SharedPreferencesService.instance;
    sharedPref.setIsCheckVersion(true);
  }
  log("Handling a background message ${message?.messageId}");
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  configureInjection();
  try {
    await DataHelper.cleanAll();
  } catch (e) {
    log(e.toString());
  }

  var check = await LocationHelper.checkServiceLocation();
  if (check == false) {
    await LocationHelper.settingServiceLocation();
  }
  globalApp.setIsInitLang = false;

  FcmServices().configLocalNoti();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('vi'),
        ],
        assetLoader: const DioAssetLoader(),
        fallbackLocale: const Locale('vi'),
        startLocale: const Locale('vi'),
        path: "assets/lang",
        errorWidget: (message) {
          return ColoredBox(
            color: colors.bgDrawerColor,
            child: Center(
              child: Text(
                message.toString(),
              ),
            ),
          );
        },
        child: MultiBlocProvider(providers: [
          BlocProvider<GeneralBloc>(
            create: (BuildContext context) => GeneralBloc(),
          ),
          BlocProvider<CustomerBloc>(
            create: (BuildContext context) => CustomerBloc(),
          ),
        ], child: const IGLS())),
  );
  FlutterNativeSplash.remove();   
}
