import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  final _navigationService = getIt<NavigationService>();
  late CustomerBloc customerBloc;
  String userName = "";
  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    userName = customerBloc.userLoginRes?.userInfo?.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        title: Text('2428'.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
        child: Column(children: [
          CacheImageAvatar(
            urlAvatar:
                customerBloc.userLoginRes?.userInfo?.defaultClientSmallLogo ??
                    '',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              userName,
              style: const TextStyle(
                color: textDarkBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: const Offset(
                    0.0,
                    2.0,
                  ),
                ),
              ],
            ),
            child: Column(children: [
              profileOption("21", routes.customerSettingRoute),
              profileOption("2423", routes.customerChangePassRoute),
              profileOption("5411", routes.customerTimeLineRoute),
              // profileOption("Config Dashboard", ""),
            ]),
          )
        ]),
      ),
    );
  }

  profileOption(String title, String route) => ListTile(
        onTap: () {
          _navigationService.pushNamed(route);
        },
        contentPadding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
        horizontalTitleGap: 1,
        trailing: const Icon(Icons.keyboard_arrow_right_sharp,
            color: Colors.blue, size: 25),
        title: Text(
          title.tr(),
          style: const TextStyle(
            color: textDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
