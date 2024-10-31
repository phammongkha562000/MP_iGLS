import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TextFormFieldReadOnly extends StatelessWidget {
  const TextFormFieldReadOnly({
    super.key,
    required this.controller,
    required this.label,
  });
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 3,
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
          label: Text(
            label.tr(),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 28)),
    );
  }
}
