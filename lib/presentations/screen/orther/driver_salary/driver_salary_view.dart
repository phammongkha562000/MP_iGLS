import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/other/driver_salary/driver_salary_bloc.dart';

import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class DriverSalaryView extends StatefulWidget {
  const DriverSalaryView({super.key});

  @override
  State<DriverSalaryView> createState() => _DriverSalaryViewState();
}

class _DriverSalaryViewState extends State<DriverSalaryView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isObscureNotifier = ValueNotifier<bool>(true);
  final FocusNode focusPassword = FocusNode();
  String? password;
  final _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(
          title: Text("4891".tr()),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(assets.kImageBg2),
            fit: BoxFit.fill,
          )),
          child: BlocListener<DriverSalaryBloc, DriverSalaryState>(
            listener: (context, state) {
              if (state is DriverSalaryFailure) {
                if (state.errorCode == constants.errorDefaultPass) {
                  CustomDialog().warning(
                    context,
                    message: state.message,
                    ok: () {
                      _navigationService.pushNamed(routes.changPasswordRoute);
                    },
                    cancel: () {
                      BlocProvider.of<DriverSalaryBloc>(context)
                          .add(const DriverSalaryLoaded());
                    },
                  );
                } else if (state.errorCode == constants.errorOldPass) {
                  CustomDialog().error(
                    context,
                    err: state.message,
                    btnOkOnPress: () {},
                  );
                } else if (state.errorCode == constants.errorCheckPass) {
                  CustomDialog().warning(context,
                      message: state.message, isOk: true, ok: () {
                    _navigationService.pushNamed(routes.changPasswordRoute);
                  });
                } else {
                  CustomDialog().error(
                    context,
                    err: state.message,
                    btnOkOnPress: () {
                      BlocProvider.of<DriverSalaryBloc>(context)
                          .add(const DriverSalaryLoaded());
                    },
                  );
                }
              }
              if (state is DriverSalaryCheckPassSuccess) {
                // * Qua details
                _navigationService.pushNamed(routes.driverSalaryDetailRoute);
              }
            },
            child: BlocBuilder<DriverSalaryBloc, DriverSalaryState>(
              builder: (context, state) {
                if (state is DriverSalarySuccess) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "5094".tr(),
                            style: const TextStyle(
                              fontSize: 25,
                              color: colors.textBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const HeightSpacer(height: 0.01),
                          Text(
                            "5095".tr(),
                            style: styleTextDefault,
                          ),
                          buildPassword(controller: _passwordController),
                          ElevatedButtonWidget(
                            text: "4376",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<DriverSalaryBloc>(context).add(
                                    DriverSalaryCheckPass(
                                        password: _passwordController.text));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Loading();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPassword({required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 32.h),
      child: ValueListenableBuilder(
        valueListenable: _isObscureNotifier,
        builder: (context, value, child) => TextFormField(
          focusNode: focusPassword,
          onSaved: (newValue) => password = newValue,
          obscureText: _isObscureNotifier.value,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value!.isEmpty) {
              return '8'.tr();
            }
            return null;
          },
          onFieldSubmitted: (value) {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<DriverSalaryBloc>(context).add(
                  DriverSalaryCheckPass(password: _passwordController.text));
            }
          },
          decoration: InputDecoration(
            labelStyle: styleLabelInput,
            hintStyle: styleHintInput,
            labelText: "14".tr(),
            hintText: "14".tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                _isObscureNotifier.value = !_isObscureNotifier.value;
              },
              icon: Icon(
                _isObscureNotifier.value
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
