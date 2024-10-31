import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:tiengviet/tiengviet.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;

import '../../../../data/models/models.dart';
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;

class DropDownButtonFormField2EquipmentWidget extends StatefulWidget {
  const DropDownButtonFormField2EquipmentWidget(
      {super.key,
      this.value,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.bgColor,
      required this.label,
      this.isRequired});
  final EquipmentResponse? value;
  final String hintText;
  final String label;
  final Function(Object?) onChanged;
  final List<EquipmentResponse> list;
  final Color? bgColor;
  final bool? isRequired;

  @override
  State<DropDownButtonFormField2EquipmentWidget> createState() =>
      _DropDownButtonFormField2EquipmentMaterialState();
}

class _DropDownButtonFormField2EquipmentMaterialState
    extends State<DropDownButtonFormField2EquipmentWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonFormField2<EquipmentResponse>(
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
        menuItemStyleData: MenuItemStyleData(
          height: 80,
          selectedMenuItemBuilder: (context, child) {
            return ColoredBox(
              color: colors.defaultColor,
              child: child,
            );
          },
        ),
        dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
        onChanged: (value) => widget.onChanged(value),
        dropdownSearchData: DropdownSearchData(
          searchInnerWidgetHeight: 50,
          searchController: searchLocController,
          searchInnerWidget: buildSearch(context),
          searchMatchFn: (item, searchValue) {
            EquipmentResponse itemNew = item.value as EquipmentResponse;
            return (TiengViet.parse(itemNew.equipmentDesc.toString())
                    .toUpperCase()
                    .contains(TiengViet.parse(searchValue).toUpperCase())) ||
                (TiengViet.parse(itemNew.equipmentCode.toString())
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
              e.equipmentDesc ?? '',
              textAlign: TextAlign.left,
            );
          }).toList();
        },
      ),
    );
  }

  DropdownMenuItem<EquipmentResponse> dropDownMenu(
      {required EquipmentResponse item}) {
    return DropdownMenuItem<EquipmentResponse>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.equipment,
        children: [
          Text(
            item.equipmentDesc ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.equipmentCode ?? "",
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
