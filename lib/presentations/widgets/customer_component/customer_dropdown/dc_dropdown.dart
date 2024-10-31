import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';

class CustomerDCDropdown extends StatefulWidget {
  const CustomerDCDropdown({
    super.key,
    required this.lstDC,
    required this.label,
    this.value,
    required this.onChanged,
  });
  final List<UserDCResult> lstDC;
  final String label;
  final UserDCResult? value;
  final Function(Object?) onChanged;
  @override
  State<CustomerDCDropdown> createState() => _CustomerDCDropdownState();
}

class _CustomerDCDropdownState extends State<CustomerDCDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      menuItemStyleData:
          MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
        return ColoredBox(
          color: colors.defaultColor.withOpacity(0.2),
          child: child,
        );
      }),
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
      decoration: InputDecoration(label: Text(widget.label.tr())),
      value: widget.value,
      selectedItemBuilder: (context) {
        return widget.lstDC.map((e) {
          return Text(
            e.dCDesc ?? '',
          );
        }).toList();
      },
      onChanged: (value) => widget.onChanged(value),
      items: widget.lstDC
          .map<DropdownMenuItem<UserDCResult>>((UserDCResult value) {
        return DropdownMenuItem<UserDCResult>(
          value: value,
          child: Text(
            value.dCDesc ?? "",
          ),
        );
      }).toList(),
    );
  }
}
