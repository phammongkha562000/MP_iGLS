import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/setting/setting_bloc.dart';
import 'package:igls_new/data/shared/global/global_user.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/avt_custom.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier<bool> _isBiometricNotifier = ValueNotifier<bool>(false);

  bool selectedVi = false;
  bool selectedEn = false;

  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("21".tr()),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _navigationService
                .pushNamedAndRemoveUntil(routes.homePageRoute)),
      ),
      body: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingLogOutSuccess) {
            _navigationService.pushNamedAndRemoveUntil(routes.loginViewRoute);
          }
        },
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state is SettingSuccess) {
              if (defaultLang == "en") {
                selectedVi = false;
                selectedEn = true;
              } else if (defaultLang == "vi") {
                selectedVi = true;
                selectedEn = false;
              }
              _isBiometricNotifier.value = state.isAllowBiometric;
              return ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  _buildEditUserProfile(),
                  CardCustom(
                    margin: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 0),
                    radius: 32,
                    color: Colors.white,
                    elevation: 3,
                    child: Column(
                      children: [
                        buildItem(
                            asset: assets.company,
                            onTap: () {
                              _navigationService.pushNamed(routes.contactRoute,
                                  args: {
                                    key_params.subsidiaryOb:
                                        generalBloc.subsidiaryRes
                                  });
                            },
                            title: '5400'),
                        Divider(
                          thickness: 1,
                          height: 0,
                          indent: 8.w,
                          endIndent: 8.w,
                        ),
                        buildChangeLang(),
                        Divider(
                          thickness: 1,
                          height: 0,
                          indent: 8.w,
                          endIndent: 8.w,
                        ),
                        buildItem(
                            onTap: () {
                              _navigationService
                                  .pushNamed(routes.changPasswordRoute);
                            },
                            asset: assets.changepass,
                            title: '2423'),
                        ...state.isBiometric
                            ? [
                                Divider(
                                  thickness: 1,
                                  height: 0,
                                  indent: 8.w,
                                  endIndent: 8.w,
                                ),
                                buildBiometrics(),
                              ]
                            : [],
                      ],
                    ),
                  ),
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      log((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Widget buildChangeLang() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: IconCustom(
              iConURL: assets.changelang,
              size: 30,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2414".tr(),
                    style: const TextStyle(
                      color: colors.textBlack,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            context.setLocale(const Locale("vi"));
                            selectedVi = true;
                            selectedEn = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.w, 0, 10.w, 0),
                          decoration: BoxDecoration(
                            gradient: selectedVi
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: <Color>[
                                        colors.defaultColor,
                                        Colors.blue.shade100
                                      ])
                                : null,
                            border: selectedVi
                                ? Border.all(
                                    color: Colors.transparent,
                                  )
                                : Border.all(
                                    color: Colors.grey,
                                  ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                          ),
                          child: Image.asset(
                            assets.vi,
                            height: 35,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            context.setLocale(const Locale("en"));
                            selectedEn = true;
                            selectedVi = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10.w, 0, 15.w, 0),
                          decoration: BoxDecoration(
                            gradient: selectedEn
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: <Color>[
                                        colors.defaultColor,
                                        Colors.blue.shade100
                                      ])
                                : null,
                            border: selectedEn
                                ? Border.all(
                                    color: Colors.transparent,
                                  )
                                : Border.all(
                                    color: Colors.grey,
                                  ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Image.asset(
                            assets.en,
                            height: 35,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(
      {required Function()? onTap,
      required String asset,
      required String title}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconCustom(
                iConURL: asset,
                size: 30,
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        title.tr(),
                        style: const TextStyle(
                          color: colors.textBlack,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Expanded(
                        child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: colors.defaultColor,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // *20/07/2023
  Widget buildBiometrics() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: IconCustom(
              iConURL: assets.icBiometrics,
              size: 30,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      "5261".tr(),
                      style: const TextStyle(
                        color: colors.textBlack,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Switch(
                          activeColor: colors.defaultColor,
                          value: _isBiometricNotifier.value,
                          onChanged: (value) {
                            _onBiometrics(isAllowBiometric: value);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onBiometrics({required bool isAllowBiometric}) {
    BlocProvider.of<SettingBloc>(context)
        .add(BiometricChanged(isAllowBiometric: isAllowBiometric));
  }

  Widget _buildEditUserProfile() {
    return CardCustom(
      padding: EdgeInsets.zero,
      radius: 32,
      margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 6.h),
      color: Colors.white,
      elevation: 3,
      child: InkWell(
        onTap: () {
          _navigationService.pushNamed(routes.userProfileRoute);
        },
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: AvtCustom(
                  size: 36,
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        globalUser.getFullname ?? "",
                        style: const TextStyle(
                          color: colors.textBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const HeightSpacer(height: 0.01),
                      Text(generalBloc.subsidiaryRes?.subsidiaryName
                              ?.toUpperCase() ??
                          ''),
                    ],
                  ),
                ),
              ),
              const Expanded(
                  flex: 0,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: colors.defaultColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
