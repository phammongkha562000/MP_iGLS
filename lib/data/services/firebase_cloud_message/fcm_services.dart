import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:url_launcher/url_launcher.dart';

import '../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../global/global_app.dart';
import '../result/api_result.dart';

class FcmServices {
  late AndroidNotificationChannel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _repoLogin = getIt<LoginRepository>();

  void firebaseCloudMessagingListeners(
      ValueNotifier totalNotifications, GeneralBloc generalBloc) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('A new onMessage event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      totalNotifications.value++;
      globalApp.setCountNotification = totalNotifications.value;
      if (notification != null &&
          notification.body != null &&
          notification.body!.contains("NTF01")) {
        getStaffDetail(generalBloc);
      }
      if (notification != null &&
          notification.title != null &&
          notification.title!.contains("[VERSION]")) {
        dialogToLogin();
      }
      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          await notificationDetails(),
          payload: 'item x',
        );
      }
    });
  }

  dialogToLogin() async {
    final navigationService = getIt<NavigationService>();
    BlocProvider.of<GeneralBloc>(
      navigationService.navigatorKey.currentContext!,
    ).add(GeneralLogout());
    return CustomDialog().warning(
      navigationService.navigatorKey.currentContext!,
      message:
          'Bạn hiện đang sử dụng phiên bản cũ, vui lòng cập nhật phiên bản mới, cảm ơn !',
      isCancel: false,
      ok: () {
        goUpdateApp();
      },
    );
  }

  getStaffDetail(GeneralBloc generalBloc) async {
    final sharedPref = await SharedPreferencesService.instance;

    ApiResult apiResultStaff = await _repoLogin.getStaffDetail(
      empCode: generalBloc.generalUserInfo?.empCode ?? '',
      subsidiaryId: generalBloc.generalUserInfo?.subsidiaryId ?? '',
    );
    if (apiResultStaff.isSuccess) {
      String equipmentCode = apiResultStaff.data.defaultEquipment;
      sharedPref.setEquipmentNo(equipmentCode);
      return;
    }
  }

  notificationDetails() {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentSound: true, presentAlert: true, presentBadge: true);
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    return NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  void iosPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
  }

  Future<void> configLocalNoti() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestAlertPermission: true,
            requestBadgePermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  void goUpdateApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? constants.androidAppId : constants.iOSAppId;
      final url = Uri.parse(
        Platform.isAndroid
            ? "${constants.urlGooglePlay}$appId"
            : "${constants.urlAppStore}$appId",
      );

      launchUrl(url, mode: LaunchMode.externalApplication)
          .whenComplete(() => exit(0));
    }
  }
}
