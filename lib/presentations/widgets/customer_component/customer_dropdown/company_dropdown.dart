import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import 'package:tiengviet/tiengviet.dart';

class CustomerCompanyDropdown extends StatefulWidget {
  const CustomerCompanyDropdown({
    super.key,
    required this.listCompany,
    required this.label,
    this.value,
    required this.onChanged,
  });
  final List<CustomerCompanyRes> listCompany;
  final String label;
  final CustomerCompanyRes? value;
  final Function(Object?) onChanged;
  @override
  State<CustomerCompanyDropdown> createState() =>
      _CustomerCompanyDropdownState();
}

class _CustomerCompanyDropdownState extends State<CustomerCompanyDropdown> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
      decoration: InputDecoration(label: Text(widget.label.tr())),
      value: widget.value,
      selectedItemBuilder: (context) {
        return widget.listCompany.map((e) {
          return Text(
            e.companyName ?? '',
          );
        }).toList();
      },
      onChanged: (value) => widget.onChanged(value),
      items: widget.listCompany.map<DropdownMenuItem<CustomerCompanyRes>>(
          (CustomerCompanyRes value) {
        return DropdownMenuItem<CustomerCompanyRes>(
          value: value,
          child: dropdown_custom.cardItemDropdown(
            assetIcon: assets.locationStock,
            children: [
              Text(value.companyName ?? ""),
            ],
          ),
        );
      }).toList(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchController,
        searchInnerWidget: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              hintText: '36'.tr(),
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: colors.defaultColor,
              ),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          CustomerCompanyRes company = item.value as CustomerCompanyRes;
          return (company.companyName
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (TiengViet.parse(company.companyName.toString())
                  .toUpperCase()
                  .contains(TiengViet.parse(searchValue).toUpperCase()));
        },
      ),
    );
  }
}
