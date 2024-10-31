import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/presentations.dart';

final isValidateNewPassword = ValueNotifier<bool>(false);

class ValidatePasswordWidget extends StatefulWidget {
  const ValidatePasswordWidget({
    super.key,
    required this.controller,
    this.minCharacter,
  });

  final TextEditingController controller;
  final int? minCharacter;

  @override
  State<ValidatePasswordWidget> createState() =>
      _ValidatePasswordMaterialState();
}

class _ValidatePasswordMaterialState extends State<ValidatePasswordWidget> {
  int strength = 0;
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final password = widget.controller.text;
    final maxLength = widget.minCharacter ?? 6;
    setState(() {
      strength = calculatePasswordStrength(
        password: password,
        minCharacter: maxLength,
      );

      if (strength == 5) {
        isValidateNewPassword.value = true;
      } else {
        isValidateNewPassword.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String inputText = widget.controller.text;
    String minCharacter =
        widget.minCharacter == null ? "6" : widget.minCharacter.toString();

    Color checkInputValidity(
        {required String inputText, required String pattern}) {
      final hasMatch = RegExp(pattern).hasMatch(inputText);
      return hasMatch ? colors.textGreen : colors.textGrey;
    }

    Color check1 = checkInputValidity(
        inputText: inputText, pattern: '^[^\\s]{$minCharacter,}\$');
    Color check2 = checkInputValidity(inputText: inputText, pattern: r'[A-Z]');
    Color check3 = checkInputValidity(inputText: inputText, pattern: r'[a-z]');
    Color check4 = checkInputValidity(inputText: inputText, pattern: r'\d');
    Color check5 = checkInputValidity(
        inputText: inputText, pattern: r'[!@#\$&*~%^()|,.;:?/<>]');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeightSpacer(height: 0.01),
        LinearProgressIndicator(
          value: strength / 5,
          backgroundColor: Colors.grey[200],
          valueColor: strength < 2
              ? const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 17, 0))
              : strength < 3
                  ? const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 255, 153, 0))
                  : strength < 4
                      ? const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 230, 209, 27))
                      : const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            '5262'.tr(),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        textCheck(
          text:
              "${"5100".tr()} ${widget.minCharacter ?? 6} ${"5101".tr()} (a2b4c6)",
          check: check1,
        ),
        textCheck(
          text: "${"5102".tr()} (A,B,...)",
          check: check2,
        ),
        textCheck(
          text: "${"5105".tr()} (a,b,...)",
          check: check3,
        ),
        textCheck(
          text: "${"5103".tr()} (1,2,...)",
          check: check4,
        ),
        textCheck(
          text: "${"5104".tr()} (!@#\$&*~%^()|,.;:?/<>)",
          check: check5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            '${'5260'.tr()}: Mp@123456',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget textCheck({
    required String text,
    required Color check,
  }) {
    return Row(
      children: [
        Icon(
          Icons.task_alt,
          color: check,
        ),
        const WidthSpacer(width: 0.01),
        Text(
          text,
          style: TextStyle(color: check),
        )
      ],
    );
  }

  int calculatePasswordStrength({
    required String password,
    int? minCharacter,
  }) {
    int strength = 0;

    if (password.contains(RegExp('^[^\\s]{$minCharacter,}\$'))) {
      strength++;
    }

    if (password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'\d'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[!@#\$&*~%^()|,.;:?/<>]'))) {
      strength++;
    }

    return strength;
  }
}
