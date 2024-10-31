import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/change_password/change_password_bloc.dart';
import 'package:igls_new/presentations/presentations.dart';

import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/components/validate_password.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _navigationService = getIt<NavigationService>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigator.pop(context, 1);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text("2423".tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, 1),
            ),
          ),
          body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                if (state.changePassSuccess == true) {
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
                          .setPassword(state.currentPasword ?? '')
                          .whenComplete(
                            () => _navigationService
                                .pushNamedAndRemoveUntil(routes.loginViewRoute),
                          );
                    },
                  );
                }
              }

              if (state is ChangePasswordFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  CustomDialog().error(
                    btnMessage: '5038'.tr(),
                    context,
                    err: state.message,
                    btnOkOnPress: () =>
                        BlocProvider.of<ChangePasswordBloc>(context)
                            .add(const ChangePasswordLoaded()),
                  );

                  return;
                }
                CustomDialog().error(context, err: state.message);
              }
            },
            builder: (context, state) {
              if (state is ChangePasswordSuccess) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
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
                                state.currentPasword) {
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
                );
              }
              return const ItemLoading();
            },
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: isValidateNewPassword,
              builder: (context, value, child) {
                return ElevatedButtonWidget(
                  isPaddingBottom: true,
                  text: "2423",
                  backgroundColor: value == false ? colors.textGrey : null,
                  onPressed: value == false
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<ChangePasswordBloc>(context).add(
                              UpdatePassword(
                                generalBloc: generalBloc,
                                currentPasword: _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                              ),
                            );
                          }
                        },
                );
              }),
        ),
      ),
    );
  }

  List<Widget> _buildTextField({required String title, required Widget tff}) {
    return [
      TextRichRequired(
        label: title,
        isBold: true,
        colorText: colors.defaultColor,
      ),
      Padding(padding: EdgeInsets.fromLTRB(0, 4.h, 0, 8.h), child: tff),
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
