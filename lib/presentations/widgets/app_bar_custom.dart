import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/theme.dart';

class AppBarCustom extends AppBar {
  AppBarCustom(
      {super.title, super.leading, super.actions, super.key, super.centerTitle})
      : super(flexibleSpace: appBarGradientColor());
}
