import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';

import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/global/global_user.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:rxdart/rxdart.dart';

import '../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../data/services/firebase_cloud_message/fcm_services.dart';
import '../../../data/services/services.dart';

String tokenfcm = '';
var notifications = FlutterLocalNotificationsPlugin();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier _totalNotifications = ValueNotifier(0);

  late HomeBloc _bloc;
  late GeneralBloc generalBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<MessageNotification> messages = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  final FcmServices fcmService = FcmServices();

  String version = '';
  String driverName = '';
  String server = '';

  List<List<PageMenuPermissions>> listPermission = [];
  BehaviorSubject<List<AnnouncementResponse>> listAnnouncement =
      BehaviorSubject();
  List<PageMenuPermissions> listMenuQuick = [];
  @override
  void initState() {
    super.initState();
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<HomeBloc>(context);
    _bloc.add(HomeLoaded(lang: 'en', generalBloc: generalBloc));
    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    initFcmLocalNotifications();
    _firebaseMessaging.getToken().then((token) {
      if (token != "") {
        generalBloc.add(LoginToHub(token: token ?? ''));
      }
    });
  }

  initFcmLocalNotifications() {
    fcmService.iosPermission();
    fcmService.firebaseCloudMessagingListeners(
        _totalNotifications, generalBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
          canPop: false,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is LogOutSuccess) {
                _navigationService
                    .pushNamedAndRemoveUntil(routes.loginViewRoute);
              }
              if (state is HomeSuccess) {
                if (Platform.isAndroid) {
                  await PermissionHelper.requestLocation();
                  await PermissionHelper.requestCamera();
                  await PermissionHelper.requestStore();
                }

                if (Platform.isIOS) {
                  await PermissionHelper.requestLocation();
                  await PermissionHelper.requestCamera();
                  await PermissionHelper.requestMediaLibrary();
                }
              }
              if (state is HomeFailure) {
                if (state.errorCode == constants.errorNoPermissionMb) {
                  // ignore: use_build_context_synchronously
                  CustomDialog().error(context,
                      err: state.message,
                      btnMessage: '5039'.tr(),
                      btnOkOnPress: () => _navigationService
                          .pushNamedAndRemoveUntil(routes.loginViewRoute));
                  return;
                }
                // ignore: use_build_context_synchronously
                CustomDialog().error(context, err: state.message);
              }
              if (state is CountNotification) {
                _totalNotifications.value = state.countNoti;
              }
              if (state is HomeSuccess) {
                globalUser.setFullname = state.driverName;
                setState(() {
                  version = state.version;
                  driverName = state.driverName;
                  server = state.server;
                  listPermission = state.listMenuGroup;
                  listAnnouncement.add(state.listAnnouncement ?? []);
                  listMenuQuick = state.listMenuQuick;
                });
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              if (state is HomeLoading) {
                return const Scaffold(body: ItemLoading());
              }
              return DecoratedBox(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(assets.kImageBg2), fit: BoxFit.fill)),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  key: _scaffoldKey,
                  drawer: _buildMenu(
                      companyName:
                          generalBloc.subsidiaryRes?.subsidiaryName ?? '',
                      driverFullName: driverName,
                      version: version,
                      listPermission: listPermission),
                  body: SingleChildScrollView(
                    // padding: EdgeInsets.only(top: 60.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _header(context, server: server),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     _buildMPi(
                        //         text: 'Clock in out',
                        //         onPressed: () {
                        //           _navigationService
                        //               .pushNamed(routes.mpiClockInOutRoute);
                        //         }),
                        //     // ElevatedButton(
                        //     //     onPressed: () {
                        //     //       _navigationService
                        //     //           .pushNamed(routes.mpiClockInOutRoute);
                        //     //     },
                        //     //     child: Text('Clock in out')),
                        //     _buildMPi(
                        //         onPressed: () {
                        //           _navigationService
                        //               .pushNamed(routes.mpiTimesheetsRoute);
                        //         },
                        //         text: 'Timesheets'),
                        //     _buildMPi(
                        //         onPressed: () {
                        //           _navigationService.pushNamed(
                        //               routes.mpiLeaveRoute,
                        //               args: {key_params.isAddLeave: false});
                        //         },
                        //         text: 'Leave'),
                        //   ],
                        // ),
                        _announcement(context),
                        listMenuQuick.isNotEmpty
                            ? _buildTitle(title: '5040')
                            : const SizedBox(),
                        _buildQuickMenu()
                      ],
                    ),
                  ),
                ),
              );
            }),
          )),
    );
  }

  Widget _buildTitle({required String title}) {
    return Text(
      title.tr(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildQuickMenu() {
    return listMenuQuick.isNotEmpty
        ? GridView.count(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            children: List.generate(
                listMenuQuick.length,
                (i) => InkWell(
                      onTap: () {
                        voidCallBack(
                          context,
                          path: '${listMenuQuick[i].tagVariant}',
                          pageId: listMenuQuick[i].pageId!,
                          pageName: listMenuQuick[i].pageName!,
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(6.w),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: colors.defaultColor.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(4.r)),
                        borderOnForeground: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: getImage(
                                  listMenuQuick[i].tagVariant.toString()),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.h),
                              child: Text(
                                '${listMenuQuick[i].tId}'.tr(),
                                // getTitleMenuByMenuID(
                                //         menuId: listMenuQuick[i].menuId!)
                                //     .tr(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: colors.defaultColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))
        : const SizedBox();
  }

  Widget _buildMenu({
    required String driverFullName,
    required String version,
    required String companyName,
    required List<List<PageMenuPermissions>> listPermission,
  }) {
    final size = MediaQuery.sizeOf(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: colors.bgDrawerColor,
          height: size.height,
          child: ListView(
            shrinkWrap: true,
            children: [
              HeaderMenu(name: driverFullName, companyName: companyName),
              BodyMenu(listPermission: listPermission),
              btnLogOut(),
              _buildVersion(version: version),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnLogOut() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: textWhite,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      child: ListTile(
        onTap: () {
          generalBloc.add(GeneralLogout());
          _bloc.add(LogOut(generalBloc: generalBloc));
        },
        leading: const IconCustom(
          iConURL: assets.kLogOut,
          size: 25,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_sharp,
            color: Colors.blue, size: 20),
        title: Text(
          "244".tr(),
          style: const TextStyle(
            color: textDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildVersion({required String version}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
      child: Text(
        "${"5034".tr()} $version",
        style: styleBottom(),
      ),
    );
  }

  TextStyle styleBottom() {
    return const TextStyle(
      fontStyle: FontStyle.italic,
      color: defaultColor,
    );
  }

  Widget _header(BuildContext context, {required String server}) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.03, size.width * 0.05 + 60.h, size.width * 0.03, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const IconCustom(iConURL: assets.kMenu, size: 30)),
          Text(
              server != ServerMode.prod
                  ? "${constants.appName} $server"
                  : constants.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: server == ServerMode.prod
                    ? colors.defaultColor
                    : (server == ServerMode.dev
                        ? colors.textRed
                        : colors.textGreen),
              )),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: Colors.amber, size: 40),
                onPressed: () async {
                  final result = await _navigationService
                      .navigateAndDisplaySelection(routes.notificationRoute,
                          args: {
                        key_params.countNotification: _totalNotifications.value
                      });
                  if (result != null) {
                    _totalNotifications.value = result;
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: _totalNotifications,
                builder: (context, value, child) {
                  return value == null || value < 1
                      ? const SizedBox()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  globalApp.countNotification != null
                                      ? globalApp.countNotification! > 10
                                          ? 32.r
                                          : 4.r
                                      : 0),
                              color: colors.textRed,
                            ),
                            child: Text(
                              (value < 100) ? value.toString() : "99+",
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: colors.textWhite),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _announcement(context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 20.h),
      padding: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: colors.btnGreyDisable.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white),
      child: Column(
        children: [
          Text(
            '27'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Divider(height: 1, color: colors.btnGreyDisable),
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.white),
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white),
            height: 100.h,
            width: size.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: StreamBuilder(
                  stream: listAnnouncement.stream,
                  builder: (context, snapshot) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _bloc.add(
                            HomeAnnouncementLoaded(generalBloc: generalBloc));
                      },
                      child: snapshot.hasData
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: colors.textGreen,
                                height: 1,
                              ),
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () => _navigationService.pushNamed(
                                    routes.announcementDetailRoute,
                                    args: {
                                      key_params.annId:
                                          snapshot.data![index].annId
                                    }),
                                child: Row(
                                  children: [
                                    const Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.notifications,
                                          size: 20,
                                          color: colors.textAmber,
                                        )),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          snapshot.data![index].subject ?? ''),
                                    ),
                                    const Expanded(
                                        flex: 1,
                                        child: Icon(Icons.read_more,
                                            color: colors.textGreen)),
                                  ],
                                ),
                              ).paddingSymmetric(vertical: 12.h),
                            )
                          : const SizedBox(),
                    );
                  },
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
