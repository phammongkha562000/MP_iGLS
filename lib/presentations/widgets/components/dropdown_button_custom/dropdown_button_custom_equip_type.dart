import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_type_response.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;
import 'package:igls_new/presentations/common/assets.dart' as assets;

class DropDownButtonFormField2EquipTypeWidget extends StatefulWidget {
  const DropDownButtonFormField2EquipTypeWidget(
      {super.key,
      this.value,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.bgColor,
      required this.label,
      this.isRequired});
  final EquipmentTypeResponse? value;
  final String hintText;
  final String label;
  final Function(Object?) onChanged;
  final List<EquipmentTypeResponse> list;
  final Color? bgColor;
  final bool? isRequired;

  @override
  State<DropDownButtonFormField2EquipTypeWidget> createState() =>
      _DropDownButtonFormField2EquipTypeMaterialState();
}

class _DropDownButtonFormField2EquipTypeMaterialState
    extends State<DropDownButtonFormField2EquipTypeWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonFormField2<EquipmentTypeResponse>(
        decoration: InputDecoration(
            label: widget.isRequired ?? true
                ? TextRichRequired(label: widget.label.tr())
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
            EquipmentTypeResponse itemNew = item.value as EquipmentTypeResponse;
            return (itemNew.equipTypeDesc
                    .toString()
                    .toUpperCase()
                    .contains(searchValue.toUpperCase())) ||
                (itemNew.equipTypeNo
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
              e.equipTypeDesc ?? '',
              textAlign: TextAlign.left,
            );
          }).toList();
        },
      ),
    );
  }

  DropdownMenuItem<EquipmentTypeResponse> dropDownMenu(
      {required EquipmentTypeResponse item}) {
    return DropdownMenuItem<EquipmentTypeResponse>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.icTrucks,
        children: [
          Text(
            item.equipTypeDesc ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.equipTypeNo ?? "",
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
