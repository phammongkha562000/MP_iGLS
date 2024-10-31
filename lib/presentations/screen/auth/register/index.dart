import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/screen/auth/register/register_form.dart';

import '../../../widgets/app_bar_custom.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register_screen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
          title: Text("register".tr()),
        ),
        // body: const Center(
        //   child: Text("UPDATE"),
        // ),
        body: const FormRegister()
        // body: FormRegister(
        //   _loginController,
        // ),
        );
  }
}
