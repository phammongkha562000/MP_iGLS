import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_profile/customer_profile_bloc.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../data/models/customer/customer_profile/update_cus_profile_req.dart';
import '../../../../data/models/login/user.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../common/cache_image_avatar.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../../widgets/load/load_list.dart';

class CustomerSettingView extends StatefulWidget {
  const CustomerSettingView({super.key});

  @override
  State<CustomerSettingView> createState() => _CustomerSettingViewState();
}

class _CustomerSettingViewState extends State<CustomerSettingView> {
  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');

  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController userRolePositionCtrl = TextEditingController();
  List<Language> lstLang = [
    Language(name: "Vietnamese", code: "VI"),
    Language(name: "English", code: "EN")
  ];
  Language? langSelected;
  late CustomerBloc customerBloc;
  late CustomerProfileBloc cusProfileBloc;
  final _navigationService = getIt<NavigationService>();
  bool isUpdated = false;
  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cusProfileBloc = BlocProvider.of<CustomerProfileBloc>(context);
    userNameCtrl.text = customerBloc.userLoginRes?.userInfo?.userName ?? '';
    emailCtrl.text = customerBloc.userLoginRes?.userInfo?.email ?? '';
    userRolePositionCtrl.text =
        customerBloc.userLoginRes?.userInfo?.userRolePosition ?? '';
    langSelected = customerBloc.userLoginRes?.userInfo?.language == "VI"
        ? lstLang[0]
        : lstLang[1];
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale(
        customerBloc.userLoginRes?.userInfo?.language?.toLowerCase() ?? "vi"));
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarCustom(
            title: Text('21'.tr()),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  isUpdated == true
                      ? _navigationService
                          .pushNamedAndRemoveUntil(routes.customerHomeRoute)
                      : Navigator.pop(context);
                }),
          ),
          body: BlocConsumer<CustomerProfileBloc, CustomerProfileState>(
              listener: (context, state) {
            if (state is UpdateCusProfileSuccess) {
              CustomDialog().success(context);
              setState(() {
                isUpdated = true;
              });
            }
            if (state is UpdateCusProfileFail) {
              CustomDialog()
                  .error(context, err: state.message, btnOkOnPress: () {});
            }
          }, builder: (context, state) {
            if (state is ChangeProfileShowLoadingState) {
              return const Center(child: ItemLoading());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
              child: Column(children: [
                CacheImageAvatar(
                  urlAvatar: customerBloc
                          .userLoginRes?.userInfo?.defaultClientSmallLogo ??
                      '',
                ),
                ..._btnInfoProfile(),
                _buildBtnSave()
              ]),
            );
          })),
    );
  }

  List<Widget> _btnInfoProfile() => [
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: TextFormField(
            controller: userNameCtrl,
            decoration: InputDecoration(
              label: Text('13'.tr()),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: TextFormField(
            controller: emailCtrl,
            decoration: InputDecoration(
              label: Text('2415'.tr()),
            ),
          ),
        ),
        TextFormField(
          controller: userRolePositionCtrl,
          decoration: InputDecoration(
            label: Text('5413'.tr()),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: CustomerContactDropdown(
              lstContact:
                  customerBloc.contactList!.map((e) => e.clientId!).toList(),
              value: contactSelected,
              label: '1326',
              onChanged: (p0) {
                String contactCode = p0 as String;
                contactSelected = contactCode;
                _contactNotifier.value = contactCode;
              }),
        ),
        DropdownButtonFormField2(
          dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          )),
          value: customerBloc.userLoginRes?.userInfo?.language == "VI"
              ? lstLang[0]
              : lstLang[1],
          isExpanded: true,
          decoration: InputDecoration(
            label: Text('2414'.tr()),
          ),
          onChanged: (value) {
            langSelected = value as Language;
          },
          menuItemStyleData:
              MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
            return ColoredBox(
              color: colors.defaultColor.withOpacity(0.2),
              child: child,
            );
          }),
          selectedItemBuilder: (context) {
            return lstLang.map((e) {
              return Text(
                e.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
            }).toList();
          },
          items: lstLang.map<DropdownMenuItem<Language>>((Language value) {
            return DropdownMenuItem<Language>(
              value: value,
              child: Text(
                value.name.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
        )
      ];
  _buildBtnSave() => Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: ElevatedButtonWidget(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              UserInfo userInfo =
                  customerBloc.userLoginRes?.userInfo ?? UserInfo();
              cusProfileBloc.add(UpdateProfileCustomerEvent(
                  customerBloc: customerBloc,
                  model: UpdateCusProfileReq(
                      subsidiary:
                          customerBloc.userLoginRes!.userInfo!.subsidiaryId ??
                              '',
                      userId: userInfo.userId,
                      userName: userNameCtrl.text,
                      email: emailCtrl.text,
                      updateUser: userInfo.userName,
                      language: langSelected?.code ?? '',
                      defaultClient: contactSelected ?? '',
                      userRolePosition: userRolePositionCtrl.text)));
            },
            text: '37'),
      );
}

class Language {
  String? name;
  String? code;
  Language({this.name, this.code});
}
