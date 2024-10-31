import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/global/global.dart';
import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../businesses_logics/bloc/customer/customer_home/customer_home_bloc.dart';
import '../../../../data/models/customer/home/customer_permission_res.dart';
import '../../../../data/models/customer/home/os_get_today_respone.dart';
import '../../../../data/services/firebase_cloud_message/fcm_services.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'dart:math' as math;
import '../../../../data/services/services.dart';
import 'menu_custom.dart';
import 'report_board_widget.dart';

String tokenfcm = '';
var notifications = FlutterLocalNotificationsPlugin();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({
    super.key,
  });

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  late CustomerHomeBloc homeBloc;
  late CustomerBloc customerBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = getIt<NavigationService>();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<MessageNotification> messages = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  final FcmServices fcmService = FcmServices();
  final navigationService = getIt<NavigationService>();
  List<GetMenuResult> lstGroupName = [];
  List<List<GetMenuResult>> lstMenuGroupBy = [];

  List<FlSpot> dataOutBoundChart = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> dataInBoundChart = [
    const FlSpot(0, 0),
  ];
  List<PieChartSectionData> dataPieChart = [];

  OsTodayRes dataReport = OsTodayRes();
  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    homeBloc = BlocProvider.of<CustomerHomeBloc>(context);
    homeBloc.add(CustomerHomeLoaded(customerBloc: customerBloc));
    // firebaseMessaging.setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true,
    //   sound: true,
    // );
    // _firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // initFcmLocalNotifications();
    // _firebaseMessaging.getToken().then((token) {
    //   if (token != "") {
    //     generalBloc.add(LoginToHub(token: token ?? ''));
    //   }
    // });
  }

  // initFcmLocalNotifications() {
  //   fcmService.iosPermission();
  //   fcmService.firebaseCloudMessagingListeners(
  //       _totalNotifications, generalBloc);
  // }

  @override
  Widget build(BuildContext context) {
    final defaultLang =
        customerBloc.userLoginRes?.userInfo?.language?.toLowerCase() ?? "vi";

    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is LogoutState) {
              navigationService.pushNamedAndRemoveUntil(routes.loginViewRoute);
              return;
            }
          },
        ),
        BlocListener<CustomerHomeBloc, CustomerHomeState>(
          listener: (context, state) async {
            if (state is CustomerHomeSuccess) {
              await context.setLocale(Locale(defaultLang));
              /*   await PermissionHelper.requestLocation(); */ //hardcode important

              setState(() {
                dataReport = state.osTodayRes;
              });
              dataReport.oSGetTodayResult?.table8?.forEach((element) {
                dataOutBoundChart.add(FlSpot(double.parse(element.column ?? ''),
                    double.parse(element.max.toString())));
              });
              dataReport.oSGetTodayResult?.table7?.forEach((element) {
                dataInBoundChart.add(FlSpot(double.parse(element.column ?? ''),
                    double.parse(element.max.toString())));
              });
              dataReport.oSGetTodayResult?.table14?.forEach((element) {
                dataPieChart.add(
                  PieChartSectionData(
                      showTitle: element.pER == 0 ? true : false,
                      title: "",
                      value: double.parse(element.pER.toString()) == 0
                          ? 1
                          : double.parse(element.pER.toString()),
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                      radius: 100),
                );
              });
              lstGroupName = state.listGroupName;
              lstMenuGroupBy = state.lstMenuGroupBy;
              // if (listMenuQuick.isNotEmpty) {
              //   listMenuQuick
              //       .sort((a, b) => a.isGroup!.compareTo(b.isGroup!));
              // }
              // for (var element in state.premissionRes.getMenuResult ?? []) {
              //   if (element.isGroup == true && element.menuId != "W00001") {
              //     listItemIsGroup.add(element);
              //   }
              //   if (element.isGroup == false) {
              //     if (element.parentsMenu == "W10001") {
              //       listGroup1.add(element);
              //     }
              //     if (element.parentsMenu == "W20001") {
              //       listGroup2.add(element);
              //     }
              //     if (element.parentsMenu == "W30001") {
              //       listGroup3.add(element);
              //     }
              //     if (element.parentsMenu == "W40001") {
              //       listGroup4.add(element);
              //     }
              //   }
              // }

              return;
            }
            if (state is CustomerHomeFailure) {
              CustomDialog().error(context,
                  err: state.message,
                  btnMessage: '5039'.tr(),
                  btnOkOnPress: () => _navigationService
                      .pushNamedAndRemoveUntil(routes.loginViewRoute));
              return;
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Scaffold(
            key: _scaffoldKey,
            drawer: _buildMenu(
                fullName: customerBloc.userLoginRes?.userInfo?.userName ?? '',
                version: globalApp.version ?? '',
                companyName: customerBloc.subsidiaryRes?.subsidiaryName ?? ''),
            body: BlocBuilder<CustomerHomeBloc, CustomerHomeState>(
              builder: (context, state) {
                if (state is CustomerHomeSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: <Color>[
                              colors.defaultColor,
                              Colors.blue.shade100
                            ])),
                        padding: EdgeInsets.fromLTRB(
                            10.w,
                            MediaQuery.paddingOf(context).top + 10.h,
                            10.w,
                            10.h),
                        child: Row(children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                            ),
                          ),
                          CacheImageAvatar(
                            urlAvatar: customerBloc.userLoginRes?.userInfo
                                    ?.defaultClientSmallLogo ??
                                '',
                          ),
                          Expanded(
                              flex: 6,
                              child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  child: Wrap(
                                      spacing: 10,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          "5372".tr(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          '${customerBloc.userLoginRes?.userInfo?.userName} (${customerBloc.userLoginRes?.userInfo?.userId})',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]))),
                        ]),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16.w),
                          children: [
                            _title(title: '5376'),
                            ReportBoardWidget(dataReport: dataReport),
                            // IconButton(
                            //   icon: const Icon(Icons.map),
                            //   onPressed: () {
                            //     _navigationService
                            //         .pushNamed(routes.trackingViewRoute);
                            //   },
                            // ),
                            // IconButton(
                            //   icon: const Icon(Icons.history),
                            //   onPressed: () {
                            //     _navigationService
                            //         .pushNamed(routes.historyTrackingViewRoute);
                            //   },
                            // )
                            // _title(title: "${'5377'.tr()} (${'2494'.tr()})"),
                            // InBoundChartWidget(
                            //   dataInBoundChart: dataInBoundChart,
                            // ),
                            // _title(title: "${'5378'.tr()} (${'2494'.tr()})"),
                            // OutBoundChartWidget(dataOutBoundChart: dataOutBoundChart),
                            // _title(title: "5379".tr()),
                            // PieChartWidget(
                            //   dataPieChart: dataPieChart,
                            // )
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const ItemLoading();
              },
            )),
      ),
    );
  }

  Widget _title({required String title}) {
    return Text(title.tr(),
        style: const TextStyle(
          color: colors.defaultColor,
          fontWeight: FontWeight.bold,
        ));
  }

  goToServicePage(String url) {
    // switch (url) {
    //   case '/customer/ordertracking':
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => OrderTrackingPage()));
    //     break;
    //   case '/customer/loadstatus':
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => LoadStatusPage()));
    //     break;
    //   case '/customer/deliverystatus':
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => DeliveryStatusPage()));
    //     break;
    //   case '/customer/viewstock':
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => ViewStockPage()));
    //     break;
    //   case '/customer/viewgoodrecept':
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => ViewGoodReceptPage()));
    //     break;
    //   case '/customer/cntrtracking':
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => CNTRTrackingPage()));
    //     break;
    // }
  }
  Widget _buildMenu({
    required String fullName,
    required String companyName,
    required String version,
  }) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: colors.bgDrawerColor,
          height: MediaQuery.sizeOf(context).height,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              HeaderMenu(
                name: fullName,
                isCustomerMode: true,
                companyName: companyName,
              ),
              MenuCustom(
                lstMenuGroupBy: lstMenuGroupBy,
                userLang: customerBloc.userLoginRes?.userInfo?.language ?? '',
                listMenu: lstGroupName,
              ),
              btnDrawer(
                  title: "244".tr(),
                  icon: assets.kLogOut,
                  onTap: () {
                    customerBloc.add(LogoutEvent());
                  }),
              _buildVersion(version: version),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnDrawer(
      {required String title,
      required String icon,
      required Function() onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8.h),
      decoration: BoxDecoration(
        color: textWhite,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      child: ListTile(
        // contentPadding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
        onTap: onTap,
        leading: IconCustom(
          iConURL: icon,
          size: 25,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_sharp,
            color: Colors.blue, size: 25),
        title: Text(
          title,
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
      padding: EdgeInsets.only(bottom: 40.h, left: 8, right: 8),
      child: Center(
        child: Text("${"5034".tr()} $version",
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: defaultColor,
            )),
      ),
    );
  }
}
