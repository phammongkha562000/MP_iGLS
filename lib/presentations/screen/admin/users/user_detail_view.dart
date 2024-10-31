import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/admin/users/user_detail/user_detail_bloc.dart';
import 'package:igls_new/data/models/std_code/std_code_2_response.dart';
import 'package:igls_new/presentations/widgets/admin_component/text_form_field_admin.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_std_code_2.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/assets.dart' as assets;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/users/user_detail_response.dart';
import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _empCodeController = TextEditingController();
  final ValueNotifier<StdCode2Response> _langNotifier =
      ValueNotifier<StdCode2Response>(StdCode2Response());
  StdCode2Response? langSelected;

  final ValueNotifier<StdCode2Response> _userRoleNotifier =
      ValueNotifier<StdCode2Response>(StdCode2Response());

  final _formkey = GlobalKey<FormState>();
  bool isUpdate = false;
  StdCode2Response? userRoleSelected;
  late UserDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<UserDetailBloc>(context);
    _bloc.add(
        UserDetailViewLoaded(userId: widget.userId, generalBloc: generalBloc));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.usersRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Form(
        key: _formkey,
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text('5119'.tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, isUpdate),
            ),
          ),
          body: BlocConsumer<UserDetailBloc, UserDetailState>(
            listener: (context, state) {
              if (state is UserDetailUpdadateSuccessfully) {
                isUpdate = true;
                CustomDialog().success(context).whenComplete(
                      () => _bloc.add(UserDetailViewLoaded(
                          userId: widget.userId, generalBloc: generalBloc)),
                    );
              }
              if (state is UserDetailFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  CustomDialog().error(
                    btnMessage: '5038'.tr(),
                    context,
                    err: state.message,
                    btnOkOnPress: () => _bloc.add(UserDetailViewLoaded(
                        userId: widget.userId, generalBloc: generalBloc)),
                  );
                  return;
                }
                CustomDialog().error(context, err: state.message);
              }
            },
            builder: (context, state) {
              if (state is UserDetailSuccess) {
                UserGetDetail detail = state.userDetailResponse.getDetail![0];
                UserGetDetail1 detail1 =
                    state.userDetailResponse.getDetail1![0];
                _userIDController.text = detail.userId ?? '';
                _userNameController.text = detail.userName ?? '';
                _emailController.text = detail.email ?? '';
                _phoneController.text = detail.mobileNo ?? '';
                _empCodeController.text = detail.empCode ?? '';
                if (detail1.lang != null && detail1.lang != '') {
                  _langNotifier.value = state.langList
                      .firstWhere((element) => element.code == detail1.lang);
                  langSelected = state.langList
                      .firstWhere((element) => element.code == detail1.lang);
                }
                if (detail.userRole != null && detail.userRole != '') {
                  _userRoleNotifier.value = state.userRoleList
                      .firstWhere((element) => element.code == detail.userRole);
                  userRoleSelected = state.userRoleList
                      .firstWhere((element) => element.code == detail.userRole);
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(children: [
                    TextFormFieldAdmin(
                        readOnly: true,
                        controller: _userIDController,
                        label: '2459',
                        isRequired: true),
                    TextFormFieldAdmin(
                        validator: (value) {
                          if (value == '') {
                            return '5067'.tr();
                          }
                          return null;
                        },
                        controller: _userNameController,
                        label: '13',
                        isRequired: true),
                    TextFormFieldAdmin(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != '') {
                            // using regular expression
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                              return "2427".tr();
                            }
                            return null;
                          }
                          return null;
                        },
                        controller: _emailController,
                        label: '2415'),
                    TextFormFieldAdmin(
                        keyboardType: TextInputType.number,
                        inputFormats: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _phoneController,
                        label: '2416'),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ValueListenableBuilder(
                        valueListenable: _langNotifier,
                        builder: (context, value, child) =>
                            DropDownButtonFormField2StdCode2Widget(
                                assetIcon: assets.icMultiLang,
                                isRequired: false,
                                onChanged: (value) {
                                  _langNotifier.value =
                                      value as StdCode2Response;
                                  langSelected = value;
                                },
                                value: langSelected,
                                label: '2414',
                                hintText: '2414',
                                list: state.langList),
                      ),
                    ),
                    TextFormFieldAdmin(
                        validator: (value) {
                          if (value == '') {
                            return '5067'.tr();
                          }
                          return null;
                        },
                        controller: _empCodeController,
                        label: '3506',
                        isRequired: true),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ValueListenableBuilder(
                        valueListenable: _userRoleNotifier,
                        builder: (context, value, child) =>
                            DropDownButtonFormField2StdCode2Widget(
                                assetIcon: assets.icStd,
                                isRequired: true,
                                onChanged: (value) {
                                  _userRoleNotifier.value =
                                      value as StdCode2Response;
                                  userRoleSelected = value;
                                },
                                value: userRoleSelected,
                                label: '3508',
                                hintText: '3508',
                                list: state.userRoleList),
                      ),
                    ),
                  ]),
                );
              }
              return const ItemLoading();
            },
          ),
          bottomNavigationBar: ElevatedButtonWidget(
            isPaddingBottom: true,
            text: '5589',
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                _bloc.add(UserDetailUpdate(
                    generalBloc: generalBloc,
                    userId: _userIDController.text,
                    userName: _userNameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    lang: _langNotifier.value.code!,
                    empCode: _empCodeController.text,
                    userRole: _userRoleNotifier.value.code!));
              }
            },
          ),
        ),
      ),
    );
  }
}
