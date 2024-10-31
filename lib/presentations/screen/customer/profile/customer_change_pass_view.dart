import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_profile/customer_profile_bloc.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/components/validate_password.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/shared.dart';
import '../../../widgets/app_bar_custom.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

class CusChangePassView extends StatefulWidget {
  const CusChangePassView({super.key});

  @override
  State<CusChangePassView> createState() => _CusChangePassViewState();
}

class _CusChangePassViewState extends State<CusChangePassView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  ValueNotifier<String> currentPass = ValueNotifier<String>("");
  late CustomerProfileBloc cusProfileBloc;
  late CustomerBloc customerBloc;
  final _navigationService = getIt<NavigationService>();

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cusProfileBloc = BlocProvider.of<CustomerProfileBloc>(context)
      ..add(ChangePassCustomerLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: _formKey,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBarCustom(
                title: Text('2423'.tr()),
              ),
              bottomNavigationBar: ElevatedButtonWidget(
                isPaddingBottom: true,
                text: "2423",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cusProfileBloc.add(CusChangePasswordEvent(
                        customerBloc: customerBloc,
                        password: _newPasswordController.text));
                  }
                },
              ),
              body: BlocConsumer<CustomerProfileBloc, CustomerProfileState>(
                  listener: (context, state) {
                if (state is ChangePassCustomerLoaded) {
                  currentPass.value = state.currentPass;
                }
                if (state is ChangePassFail) {
                  CustomDialog()
                      .error(context, err: state.message, btnOkOnPress: () {});
                }
                if (state is ChangePassSuccess) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    showToastWidget(
                      const SuccessToast(),
                      position: StyledToastPosition.top,
                      animation: StyledToastAnimation.slideFromRightFade,
                      context: context,
                    );
                  });
                  showDialogLogOut(context).show().whenComplete(
                    () async {
                      final sharedPref =
                          await SharedPreferencesService.instance;

                      sharedPref
                          .setPassword(state.currentPassword ?? '')
                          .whenComplete(
                            () => _navigationService
                                .pushNamedAndRemoveUntil(routes.loginViewRoute),
                          );
                    },
                  );
                }
              }, builder: (context, state) {
                if (state is ShowLoadingState) {
                  return const Center(child: ItemLoading());
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildTextField(
                          title: "5098",
                          tff: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            controller: _currentPasswordController,
                            obscureText: _obscureCurrent,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '5067';
                              } else if (_currentPasswordController.text !=
                                  currentPass.value) {
                                return strings.erPassNotMatch.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureCurrent = !_obscureCurrent;
                                  });
                                },
                                icon: Icon(
                                  _obscureCurrent
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: colors.defaultColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ..._buildTextField(
                          title: "4584",
                          tff: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            controller: _newPasswordController,
                            textInputAction: TextInputAction.next,
                            obscureText: _obscureNew,
                            validator: (value) {
                              if (value!.isEmpty) {
                                validate = false;
                                return '5067'.tr();
                              } else if (value.length < 6) {
                                validate = false;
                                return strings.erPasswordShort.tr();
                              } else if (value !=
                                  _confirmPasswordController.text) {
                                return strings.erPassNotMatch.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureNew = !_obscureNew;
                                  });
                                },
                                icon: Icon(
                                  _obscureNew
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: colors.defaultColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ..._buildTextField(
                          title: "2424",
                          tff: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '5067'.tr();
                              } else if (value.length < 6) {
                                return strings.erPasswordShort.tr();
                              } else if (value != _newPasswordController.text) {
                                return strings.erPassNotMatch.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: colors.defaultColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ValidatePasswordWidget(
                          controller: _newPasswordController,
                          minCharacter: 6,
                        ),
                      ],
                    ),
                  ),
                );
              })),
        ));
  }

  List<Widget> _buildTextField({required String title, required Widget tff}) {
    return [
      TextRichRequired(
          label: title, colorText: colors.defaultColor, isBold: true),
      Padding(padding: EdgeInsets.fromLTRB(0, 4.h, 0, 8.w), child: tff),
    ];
  }

  AwesomeDialog showDialogLogOut(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      btnOkColor: colors.textGreen,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      autoHide: const Duration(seconds: 5),
      btnOkText: "244".tr(),
      btnOkOnPress: () async {
        final sharedPref = await SharedPreferencesService.instance;
        sharedPref.setPassword('').whenComplete(
              () => _navigationService
                  .pushNamedAndRemoveUntil(routes.loginViewRoute),
            );
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeightSpacer(height: 0.01),
          Text(
            "5099".tr(),
            style: const TextStyle(
              color: colors.defaultColor,
              fontWeight: FontWeight.bold,
              fontSize: sizeTextDefault,
            ),
            textAlign: TextAlign.center,
          ),
          const HeightSpacer(height: 0.01)
        ],
      ),
    );
  }
}
