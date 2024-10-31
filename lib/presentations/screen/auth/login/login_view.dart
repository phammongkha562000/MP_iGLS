import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/local_auth/biometrics_helper.dart';
import 'package:igls_new/data/shared/mixin/alert.dart';
import 'package:igls_new/presentations/enum/language.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import '../../../../data/services/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with Alert {
  final _navigationService = getIt<NavigationService>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusPassword = FocusNode();

  String? serverSelected;
  bool isRemember = false;
  final ValueNotifier _tabNotifier = ValueNotifier<int>(1);
  final ValueNotifier<bool> _isObscureNotifier = ValueNotifier<bool>(true);

  final List<String?> errors = [];
  String? userName;
  String? password;
  int count = 0;
  String defaultLang = "";
  bool isBiometric = false;
  String biometrics = "";
  final listServer = [ServerMode.prod, ServerMode.dev, ServerMode.qa];
  late GeneralBloc generalBloc;
  late LoginBloc loginBloc;
  late CustomerBloc customerBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
    return Form(
      key: _formKey,
      child: PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) async {
              if (state is CustomerLoginSuccess) {
                customerBloc.add(CustomerAddIntercepter());
                _navigationService.pushNamed(routes.customerHomeRoute);
                return;
              }
              if (state is LoginSuccess) {
                if (state.isDefaultPass == true) {
                  final result = await _navigationService
                      .navigateAndDisplaySelection(routes.changPasswordRoute);
                  if (result != null) {
                    loginBloc.add(LoginViewLoaded());
                  }
                  return;
                }
                generalBloc.add(AddInterceptor());
                _navigationService.pushNamed(routes.homePageRoute);
                if (defaultLang == 'vi') {
                  context.setLocale(const Locale('en'));
                  context.setLocale(const Locale('vi'));
                } else {
                  context.setLocale(const Locale('vi'));
                  context.setLocale(const Locale('en'));
                }
              }

              if (state is LoginFailure) {
                if (state.errorCode == constants.errorNotExits) {
                  CustomDialog().error(context, err: state.message);
                  return;
                } else if (state.errorCode == constants.errCodeInitLogin) {
                  CustomDialog().error(context, err: state.message);
                  return;
                } else if (state.errorCode ==
                    constants.errCodeNotAllowBiometrics) {
                  CustomDialog().error(context, err: state.message);
                  return;
                } else {
                  CustomDialog()
                      .error(context, err: state.message)
                      .whenComplete(() => loginBloc.add(LoginViewLoaded()));
                  return;
                }
              }

              if (state is LoginVersionOld) {
                _showUpdateVersion(context);
              }
            }, builder: (context, state) {
              if (state is LoginLoadSuccess) {
                state.mode == constants.modeCustomer
                    ? _tabNotifier.value = 2
                    : _tabNotifier.value = 1;
                isBiometric = state.isBiometric ?? false;
                _usernameController.text = state.userName ?? '';
                _passwordController.text = state.password ?? '';
                biometrics = state.biometrics ?? '';
                serverSelected = state.serverMode ?? ServerMode.prod;
                isRemember = state.isRemember ?? true;
                return DecoratedBox(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(assets.kImageBg),
                    fit: BoxFit.fill,
                  )),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLogo(context),
                      ),
                      Expanded(
                        flex: 4,
                        child:
                            _buildForm(isRemember: state.isRemember ?? false),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "${"5034".tr()} ${serverSelected == ServerMode.prod ? 'P' : serverSelected == ServerMode.dev ? 'D' : 'QA'} ${globalApp.version}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: defaultColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is LoginLoading) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(assets.kImageBg),
                    fit: BoxFit.fill,
                  )),
                  child: Loading(),
                );
              }
              return const SizedBox();
            }),
          )),
    );
  }

  Widget _buildForm({required bool isRemember}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: colors.bgDrawerColor.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTab(),
                _buildUserName(controller: _usernameController),
                _buildPassword(controller: _passwordController),
                _buildRememberAndChangeLang(
                    defaultLang: defaultLang,
                    context: context,
                    isRemember: isRemember),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: InkWell(
                    onTap: () {
                      _navigationService
                          .pushNamed(routes.webViewForgotPasswordRoute, args: {
                        key_params.usernameForgotPassword:
                            _usernameController.text,
                        key_params.tabMode: _tabNotifier.value
                      });
                    },
                    child: Text('${'5450'.tr()}?',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ElevatedButtonWidget(
                        isPadding: false,
                        isShadow: false,
                        backgroundColor: colors.defaultColor,
                        text: "17",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _tabNotifier.value == 1
                                ? _onPressedLogin()
                                : _onPressedCustomerLogin();
                          }
                        },
                      ),
                    ),
                    isBiometric
                        ? Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () {
                                  loginBloc.add(AuthLocalEvent(
                                      mode: _tabNotifier.value,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      serverMode:
                                          serverSelected ?? ServerMode.prod,
                                      remember: isRemember,
                                      generalBloc: generalBloc));
                                },
                                icon: Image.asset(
                                  biometrics == BiometricsHelper.faceId
                                      ? assets.icFaceId
                                      : assets.icFingerprint,
                                )))
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return ValueListenableBuilder(
        valueListenable: _tabNotifier,
        builder: (context, value, child) {
          return PreferredSize(
            preferredSize: Size(double.infinity, 48.w),
            child: CustomSlidingSegmentedControl<int>(
              fixedWidth: MediaQuery.sizeOf(context).width / 2.5,
              height: MediaQuery.sizeOf(context).height * 0.05,
              initialValue: _tabNotifier.value,
              children: {
                1: Text(
                  '5271'.tr(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _tabNotifier.value == 2
                          ? Colors.white
                          : Colors.black),
                ),
                2: Text(
                  '5272'.tr(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _tabNotifier.value == 1
                          ? Colors.white
                          : Colors.black),
                )
              },
              decoration: BoxDecoration(
                color: colors.defaultColor,
                borderRadius: BorderRadius.circular(32.r),
              ),
              innerPadding: EdgeInsets.all(4.w),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInToLinear,
              onValueChanged: (v) {
                _tabNotifier.value = v;
              },
            ),
          );
        }).paddingOnly(bottom: 16.h);
  }

  Row _buildRememberAndChangeLang(
      {required String defaultLang,
      required BuildContext context,
      required bool isRemember}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CheckboxListTile(
            enabled: false,
            controlAffinity: ListTileControlAffinity.leading,
            visualDensity: const VisualDensity(horizontal: -4),
            title: Text('5033'.tr()),
            value: isRemember,
            onChanged: (newValue) {
              _onRemember();
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildChangeLang(defaultLang: defaultLang, context: context),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
        onTap: () {
          count == 6
              ? {
                  _showDialogVersion(context),
                  count = 0,
                }
              : count++;
        },
        child: _buildIconNameApp());
  }

  IconButton _buildChangeLang(
      {required String defaultLang, required BuildContext context}) {
    return IconButton(
        onPressed: () {
          loginBloc.add(LoginLanguage(
              mode: _tabNotifier.value,
              username: _usernameController.text,
              password: _passwordController.text,
              serverMode: serverSelected ?? ServerMode.prod,
              remember: isRemember));

          context.setLocale(Locale(defaultLang == Languages.vi.languageCode
              ? Languages.en.languageCode
              : Languages.vi.languageCode));
        },
        icon: IconCustom(
            iConURL: defaultLang == Languages.en.languageCode
                ? Languages.en.languageFlag
                : Languages.vi.languageFlag,
            size: 30));
  }

  Widget _buildIconNameApp() => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconCustom(iConURL: assets.kImageLogo, size: 80),
          WidthSpacer(width: 0.05),
          Text(
            strings.nameApp,
            style: TextStyle(
              color: defaultColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
  Widget _buildUserName({required TextEditingController controller}) {
    return TextFormField(
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(focusPassword),
      onSaved: (newValue) => userName = newValue,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelStyle: styleLabelInput,
          hintStyle: styleHintInput,
          labelText: "13".tr(),
          hintText: "13".tr(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: const Icon(Icons.person, color: defaultColor)),
    ).paddingSymmetric(vertical: 12.h);
  }

  Widget _buildPassword({required TextEditingController controller}) {
    return ValueListenableBuilder(
      valueListenable: _isObscureNotifier,
      builder: (context, value, child) => TextFormField(
        focusNode: focusPassword,
        onSaved: (newValue) => password = newValue,
        obscureText: _isObscureNotifier.value,
        controller: controller,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            _tabNotifier.value == 1
                ? _onPressedLogin()
                : _onPressedCustomerLogin();
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
    ).paddingSymmetric(vertical: 12.h);
  }

  _showDialogVersion(BuildContext buildContext) {
    AwesomeDialog(
      padding: EdgeInsets.all(24.w),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      body: Column(
        children: [
          Text(
            "5035".tr(),
            style: styleTextTitle,
          ),
          const HeightSpacer(height: 0.02),
          DropDownButtonFormField2Widget(
              selected: serverSelected,
              label: '',
              hintText: '5035',
              listString: listServer.map((e) => e.toString()).toList(),
              onChanged: (p0) {
                serverSelected = p0.toString();
                loginBloc.add(LoginChangeServer(
                    mode: _tabNotifier.value,
                    serverMode: p0.toString(),
                    username: _usernameController.text,
                    password: _passwordController.text,
                    remember: isRemember));
                Navigator.of(context).pop();
              }),
        ],
      ),
    ).show();
  }

  _showUpdateVersion(BuildContext buildContext) {
    AwesomeDialog(
        padding: EdgeInsets.all(24.w),
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        dismissOnTouchOutside: false,
        btnOkText: '5589'.tr(),
        title: '5037'.tr(),
        body: Column(
          children: [
            Text(
              "5037".tr(),
              style: styleTextTitle,
            ),
            const HeightSpacer(height: 0.02),
          ],
        ),
        btnOkOnPress: () => goUpdateApp()).show();
  }

  _onRemember() => loginBloc.add(LoginRemember(
      mode: _tabNotifier.value,
      username: _usernameController.text,
      password: _passwordController.text,
      serverMode: serverSelected ?? ServerMode.prod,
      remember: isRemember));
  _onPressedLogin() => loginBloc.add(LoginPressed(
      mode: _tabNotifier.value,
      username: _usernameController.text,
      password: _passwordController.text,
      serverMode: serverSelected ?? ServerMode.prod,
      remember: isRemember,
      generalBloc: generalBloc));
  _onPressedCustomerLogin() => loginBloc.add(CustomerLoginPressed(
      mode: _tabNotifier.value,
      username: _usernameController.text,
      password: _passwordController.text,
      serverMode: serverSelected ?? ServerMode.prod,
      remember: isRemember,
      customerBloc: customerBloc));

  void goUpdateApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? constants.androidAppId : constants.iOSAppId;
      final url = Uri.parse(
        Platform.isAndroid ? "$urlGooglePlay$appId" : "$urlAppStore$appId",
      );
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
