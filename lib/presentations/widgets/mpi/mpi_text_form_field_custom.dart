import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/mpi/mpi_text_rich__required.dart';

class InputTextFieldNew extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final double? height;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool? isRequired;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String? text)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final bool? enabled;
  final bool? readOnly;
  final TextInputAction? textInputAction;

  const InputTextFieldNew(
      {super.key,
      required this.labelText,
      this.hintText,
      this.height,
      this.suffixIcon,
      this.obscureText,
      this.controller,
      this.inputFormatters,
      this.onSubmitted,
      this.focusNode,
      this.type,
      this.isRequired,
      this.prefixIcon,
      this.validator,
      this.readOnly,
      this.textInputAction,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
            child: isRequired ?? false
                ? TextRichRequired(label: labelText.tr())
                : Text(
                    labelText.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
          ),
          TextFormField(
            readOnly: readOnly ?? false,
            keyboardType: type ?? TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.next,
            minLines: 1,
            maxLines: 5,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: inputFormatters,
            controller: controller,
            validator: validator,
            enabled: enabled ?? true,
            decoration: InputDecoration(
                contentPadding: suffixIcon != null
                    ? const EdgeInsets.only(
                        left: 32, top: 16, bottom: 16, right: 8)
                    : prefixIcon != null
                        ? const EdgeInsets.only(
                            left: 8, top: 16, bottom: 16, right: 32)
                        : const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                hintText: hintText != null ? hintText!.tr() : labelText.tr(),
                hintStyle: TextStyle(
                    fontSize: 14, color: colors.outerSpace.withOpacity(0.5)),
                // fillColor: MyColor.colorInput,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                isDense: false),
          ),
        ],
      ),
    );
  }
}
