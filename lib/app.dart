import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/login/login_bloc.dart';
import 'package:igls_new/data/base/life_cycle_state.dart';
import 'package:igls_new/data/global/global.dart';
import 'package:igls_new/data/models/models.dart';
import 'package:igls_new/data/services/firebase_cloud_message/fcm_services.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/generate_route.dart' as router;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import 'businesses_logics/bloc/general/general_bloc.dart';
import 'data/repository/repository.dart';
import 'data/shared/shared.dart';
import 'presentations/screen/auth/login/login_view.dart';

class IGLS extends StatefulWidget {
  const IGLS({super.key});

  @override
  State<IGLS> createState() => _IGLSState();
}

class _IGLSState extends LifecycleState<IGLS> {
  final _repoLogin = getIt<LoginRepository>();

  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, child!),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: const ColoredBox(color: Color(0xFFF5F5F5)),
            ),
          ),
          home: BlocProvider(
            create: (context) => LoginBloc()..add(LoginViewLoaded()),
            child: const LoginView(),
          ),
          navigatorKey: getIt<NavigationService>().navigatorKey,
          onGenerateRoute: router.generateRoute,
        ));
  }

  @override
  void onDetached() {
    log('onDetached');
  }

  @override
  void onInactive() {
    log('onInactive');
  }

  @override
  void onPaused() {
    log('onPaused');
  }

  @override
  Future<void> onResumed() async {
    log('onResumed - isLogin: ${globalApp.isLogin}');
    final sharedPref = await SharedPreferencesService.instance;
    SharedPreferencesService.reload().then((value) {
      if (sharedPref.isCheckVersion == true) {
        sharedPref.setIsCheckVersion(false);
        log('onResumed - isCheckVersion: ${sharedPref.isCheckVersion}');
        FcmServices().dialogToLogin();
      }
    });

    if (globalApp.isLogin == true && sharedPref.mode == constants.modeDriver) {
      if (sharedPref.timeResume == null || sharedPref.timeResume == '') {
        final String timeResume =
            DateTime.now().add(const Duration(minutes: 5)).toString();
        log('timeResume: $timeResume');
        sharedPref.setTimeResume(timeResume);
      } else {
        DateTime timeResume = DateTime.parse(sharedPref.timeResume ?? '');

        if (timeResume.isBefore(DateTime.now())) {
          if (sharedPref.userName == null || sharedPref.userName == '') {
            log('no get equipment');
          } else {
            final UserInfo userInfo = generalBloc.generalUserInfo ?? UserInfo();
            final apiResult = await _repoLogin.getStaffDetail(
              empCode: userInfo.empCode ?? "",
              subsidiaryId: userInfo.subsidiaryId ?? '',
            );
            if (apiResult.isFailure) {
              log(apiResult.getErrorMessage());
              return;
            }
            StaffResponse staffResponse = apiResult.data;
            final equipmentCode = staffResponse.defaultEquipment;
            log('get equipment: $equipmentCode');
            //Save default equipment No
            final sharedPref = await SharedPreferencesService.instance;

            sharedPref.setEquipmentNo(equipmentCode ?? "");
            sharedPref.setTimeResume(
                DateTime.now().add(const Duration(minutes: 5)).toString());
          }
        } else {
          log('no get equipment');
        }
      }
    }
  }

  @override
  void onHidden() {
    log('onHidden');
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
