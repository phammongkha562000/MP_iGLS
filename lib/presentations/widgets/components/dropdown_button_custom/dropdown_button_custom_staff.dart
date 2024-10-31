import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:tiengviet/tiengviet.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import '../../../../data/models/models.dart';

class DropDownButtonFormField2StaffsWidget extends StatefulWidget {
  const DropDownButtonFormField2StaffsWidget(
      {super.key,
      this.value,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.bgColor,
      required this.label,
      this.isRequired});
  final StaffsResponse? value;
  final String hintText;
  final String label;
  final Function(Object?) onChanged;
  final List<StaffsResponse> list;
  final Color? bgColor;
  final bool? isRequired;

  @override
  State<DropDownButtonFormField2StaffsWidget> createState() =>
      _DropDownButtonFormField2StaffsMaterialState();
}

class _DropDownButtonFormField2StaffsMaterialState
    extends State<DropDownButtonFormField2StaffsWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8.r)),
      child: DropdownButtonFormField2<StaffsResponse>(
        decoration: InputDecoration(
            label: widget.isRequired ?? true
                ? TextRichRequired(label: widget.label.tr())
                : Text(widget.label.tr()),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        barrierColor: dropdown_custom.bgDrawerColor(),
        validator: (value) => value == null ? widget.hintText.tr() : null,
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
            StaffsResponse itemNew = item.value as StaffsResponse;
            return (TiengViet.parse(itemNew.staffUserId.toString())
                    .toUpperCase()
                    .contains(TiengViet.parse(searchValue).toUpperCase())) ||
                (TiengViet.parse(itemNew.staffName.toString())
                    .toUpperCase()
                    .contains(TiengViet.parse(searchValue).toUpperCase()));
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
              e.staffName ?? '',
              textAlign: TextAlign.left,
            );
          }).toList();
        },
      ),
    );
  }

  DropdownMenuItem<StaffsResponse> dropDownMenu(
      {required StaffsResponse item}) {
    return DropdownMenuItem<StaffsResponse>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.avtUser,
        children: [
          Text(
            item.staffUserId ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.staffName ?? "",
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
