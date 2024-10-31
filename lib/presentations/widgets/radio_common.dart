import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RadioCommon extends StatelessWidget {
  const RadioCommon(
      {super.key,
      required this.title,
      required this.value,
      required this.groupValue,
      required this.onChanged});
  final String title;
  final String value;
  final String groupValue;
  final void Function(String?) onChanged;
  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(title.tr()),
      value: value,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      groupValue: groupValue,
      onChanged: (value) => onChanged(value),
    );
  }
}
