import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/std_code/std_code_2_response.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;

class DropDownButtonFormField2StdCode2Widget extends StatefulWidget {
  const DropDownButtonFormField2StdCode2Widget(
      {super.key,
      this.value,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.bgColor,
      required this.label,
      this.isRequired,
      required this.assetIcon});
  final StdCode2Response? value;
  final String hintText;
  final String label;
  final Function(Object?) onChanged;
  final List<StdCode2Response> list;
  final Color? bgColor;
  final bool? isRequired;
  final String assetIcon;
  @override
  State<DropDownButtonFormField2StdCode2Widget> createState() =>
      _DropDownButtonFormField2StdCode2MaterialState();
}

class _DropDownButtonFormField2StdCode2MaterialState
    extends State<DropDownButtonFormField2StdCode2Widget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8.r)),
      child: DropdownButtonFormField2<StdCode2Response>(
        decoration: InputDecoration(
            label: widget.isRequired ?? true
                ? TextRichRequired(label: widget.label)
                : Text(widget.label.tr()),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        barrierColor: dropdown_custom.bgDrawerColor(),
        validator: (value) => value == null ? '5067'.tr() : null,
        isExpanded: true,
        value: widget.value,
        hint: Text(widget.hintText.tr()),
        items: widget.list.map((item) => dropDownMenu(item: item)).toList(),
        buttonStyleData: const ButtonStyleData(height: 50),
        menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
        dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
        onChanged: (value) => widget.onChanged(value),
        dropdownSearchData: DropdownSearchData(
          searchInnerWidgetHeight: 50,
          searchController: searchLocController,
          searchInnerWidget: buildSearch(context),
          searchMatchFn: (item, searchValue) {
            StdCode2Response itemNew = item.value as StdCode2Response;
            return (itemNew.codeDesc
                    .toString()
                    .toUpperCase()
                    .contains(searchValue.toUpperCase())) ||
                (itemNew.code
                    .toString()
                    .toUpperCase()
                    .contains(searchValue.toUpperCase()));
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchLocController.clear();
          }
        },
        selectedItemBuilder: (context) {
          return widget.list.map((e) {
            return Text(
              e.codeDesc ?? '',
              textAlign: TextAlign.left,
            );
          }).toList();
        },
      ),
    );
  }

  DropdownMenuItem<StdCode2Response> dropDownMenu(
      {required StdCode2Response item}) {
    return DropdownMenuItem<StdCode2Response>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: widget.assetIcon,
        children: [
          Text(
            item.codeDesc ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.codeDesc ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget buildSearch(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
      child: TextFormField(
        controller: searchLocController,
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
    );
  }
}
