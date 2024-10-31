import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CustomerContactDropdown extends StatefulWidget {
  const CustomerContactDropdown({
    super.key,
    required this.lstContact,
    required this.label,
    this.value,
    required this.onChanged,
  });
  final List<String> lstContact;
  final String label;
  final String? value;
  final Function(Object?) onChanged;
  @override
  State<CustomerContactDropdown> createState() =>
      _CustomerContactDropdownState();
}

class _CustomerContactDropdownState extends State<CustomerContactDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      )),
      decoration: InputDecoration(label: Text(widget.label.tr())),
      value: widget.value,
      selectedItemBuilder: (context) {
        return widget.lstContact.map((e) {
          return Text(e);
        }).toList();
      },
      menuItemStyleData:
          MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
        return ColoredBox(
          color: colors.defaultColor.withOpacity(0.2),
          child: child,
        );
      }),
      onChanged: (value) => widget.onChanged(value),
      items: widget.lstContact.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }
}
