import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class TextFormFieldAdmin extends StatefulWidget {
  const TextFormFieldAdmin(
      {super.key,
      required this.controller,
      this.validator,
      required this.label,
      this.readOnly,
      this.maxLength,
      this.keyboardType,
      this.inputFormats,
      this.isRequired,
      this.onChanged,
      this.padding,
      this.colorLabel,
      this.maxLines,
      this.contentPadding,
      this.textInputAction,
      this.obscureText});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final bool? readOnly;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormats;
  final bool? isRequired;
  final void Function(String)? onChanged;
  final EdgeInsets? padding;
  final Color? colorLabel;
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  @override
  State<TextFormFieldAdmin> createState() => _TextFormFieldAdminState();
}

class _TextFormFieldAdminState extends State<TextFormFieldAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(8.w),
      child: TextFormField(
        minLines: widget.maxLines == null ? 1 : null,
        maxLines: widget.maxLines ?? 5,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly ?? false,
        validator: widget.validator,
        controller: widget.controller,
        inputFormatters: widget.inputFormats,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText ?? false,
        style: TextStyle(
            color: widget.readOnly ?? false
                ? colors.btnGreyDisable
                : colors.textBlack),
        decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            counterText: '',
            label: widget.isRequired ?? false
                ? TextRichRequired(
                    label: widget.label,
                    isBold: true,
                    colorText: widget.colorLabel,
                  )
                : Text(widget.label.tr()),
            hintText: widget.label.tr()),
      ),
    );
  }
}
