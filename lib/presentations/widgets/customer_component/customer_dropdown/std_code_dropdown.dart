import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';

class CustomerSTDCodeDropdown extends StatefulWidget {
  const CustomerSTDCodeDropdown({
    super.key,
    required this.listSTD,
    required this.label,
    this.value,
    required this.onChanged,
  });
  final List<GetStdCodeRes> listSTD;
  final String label;
  final GetStdCodeRes? value;
  final Function(Object?) onChanged;
  @override
  State<CustomerSTDCodeDropdown> createState() =>
      _CustomerSTDCodeDropdownState();
}

class _CustomerSTDCodeDropdownState extends State<CustomerSTDCodeDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
      decoration: InputDecoration(label: Text(widget.label.tr())),
      value: widget.value,
      selectedItemBuilder: (context) {
        return widget.listSTD.map((e) {
          return Text(
            e.codeDesc ?? '',
          );
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
      items: widget.listSTD
          .map<DropdownMenuItem<GetStdCodeRes>>((GetStdCodeRes value) {
        return DropdownMenuItem<GetStdCodeRes>(
          value: value,
          child: Text(
            value.codeDesc ?? "",
          ),
        );
      }).toList(),
    );
  }
}
