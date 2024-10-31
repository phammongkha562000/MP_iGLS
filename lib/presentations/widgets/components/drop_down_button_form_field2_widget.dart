import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_by_type_response.dart';
import 'package:igls_new/data/models/std_code/std_code_response.dart';
import 'package:igls_new/data/models/setting/setting.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:tiengviet/tiengviet.dart';

import '../dropdown_custom/dropdown_custom.dart' as dropdown_custom;

// ignore: must_be_immutable
class DropDownButtonFormField2Widget extends StatefulWidget {
  DropDownButtonFormField2Widget(
      {super.key,
      required this.selected,
      required this.label,
      required this.hintText,
      required this.listString,
      required this.onChanged,
      this.isLabel});
  final dynamic selected;
  final String label;
  final String hintText;
  Function(Object?) onChanged;
  final List<String> listString;
  final bool? isLabel;

  @override
  State<DropDownButtonFormField2Widget> createState() =>
      _DropDownButtonFormField2MaterialState();
}

class _DropDownButtonFormField2MaterialState
    extends State<DropDownButtonFormField2Widget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: widget.selected,
      decoration: widget.isLabel ?? true
          ? InputDecoration(
              label: Text(widget.label.tr()),
            )
          : null,
      hint: Text(widget.hintText.tr()),
      buttonStyleData: const ButtonStyleData(height: 50),
      menuItemStyleData: const MenuItemStyleData(
        height: 50,
      ),
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32))),
      onChanged: (value) => widget.onChanged(value),
      items: widget.listString.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) => value == null ? widget.hintText.tr() : null,
    );
  }
}

//company

class DropDownButtonFormField2CompanyWidget extends StatefulWidget {
  const DropDownButtonFormField2CompanyWidget(
      {super.key,
      this.value,
      required this.hintText,
      required this.label,
      required this.list,
      required this.onChanged});
  final CompanyResponse? value;
  final String hintText;
  final String label;
  final Function(Object?) onChanged;
  final List<CompanyResponse> list;

  @override
  State<DropDownButtonFormField2CompanyWidget> createState() =>
      _DropDownButtonFormField2CompanyMaterialState();
}

class _DropDownButtonFormField2CompanyMaterialState
    extends State<DropDownButtonFormField2CompanyWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<CompanyResponse>(
      decoration: InputDecoration(label: TextRichRequired(label: widget.label)),
      hint: Text(widget.hintText.tr()),
      barrierColor: dropdown_custom.bgDrawerColor(),
      validator: (value) => value == null ? '5067'.tr() : null,
      isExpanded: true,
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      value: widget.value,
      items:
          widget.list.map((item) => dropDownMenuCompany(item: item)).toList(),
      onChanged: (value) => widget.onChanged(value),
      selectedItemBuilder: (context) {
        return widget.list.map((e) {
          return Text(
            e.companyName ?? '',
            textAlign: TextAlign.left,
          );
        }).toList();
      },
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchLocController,
        searchInnerWidget: buildSearchCompany(context),
        searchMatchFn: (item, searchValue) {
          CompanyResponse itemNew = item.value as CompanyResponse;
          return (itemNew.companyName
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (itemNew.companyId
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
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      errorStyle: const TextStyle(
        height: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  BoxDecoration decorationButton() {
    return BoxDecoration(
      color: colors.textWhite,
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
    );
  }

  DropdownMenuItem<CompanyResponse> dropDownMenuCompany(
      {required CompanyResponse item}) {
    return DropdownMenuItem<CompanyResponse>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.kCompanyUser,
        children: [
          Text(
            item.companyName ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.companyId ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget buildSearchCompany(BuildContext context) {
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
          ),
        ),
      ),
    );
  }
}

//***************************************** */
//contact local
// ignore: must_be_immutable
class DropDownButtonFormField2ContactLocalWidget extends StatefulWidget {
  DropDownButtonFormField2ContactLocalWidget(
      {super.key,
      this.value,
      required this.label,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.isLabel,
      this.bgColor,
      this.isGrey});
  final ContactLocal? value;
  final Widget label;
  final String hintText;
  Function(Object?) onChanged;
  final List<ContactLocal> list;
  final bool? isLabel;
  final Color? bgColor;
  final bool? isGrey;

  @override
  State<DropDownButtonFormField2ContactLocalWidget> createState() =>
      _DropDownButtonFormField2ContactLocalMaterialState();
}

class _DropDownButtonFormField2ContactLocalMaterialState
    extends State<DropDownButtonFormField2ContactLocalWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<ContactLocal>(
      barrierColor: dropdown_custom.bgDrawerColor(),
      validator: (value) => value == null ? '5067'.tr() : null,
      decoration: InputDecoration(label: widget.label),
      isExpanded: true,
      value: widget.value,
      hint: Text(widget.hintText.tr()),
      items: widget.list
          .map((item) =>
              dropDownMenuContactLocal(item: item, isGrey: widget.isGrey))
          .toList(),
      onChanged: (value) => widget.onChanged(value),
      buttonStyleData: dropdown_custom.customButtonStyleData(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      selectedItemBuilder: (context) {
        return widget.list.map((e) {
          return Text(
            e.contactName ?? '',
            textAlign: TextAlign.left,
          );
        }).toList();
      },
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchLocController,
        searchInnerWidget: buildSearchContactLocal(context),
        searchMatchFn: (item, searchValue) {
          ContactLocal itemNew = item.value as ContactLocal;
          return (itemNew.contactCode
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (itemNew.contactName
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
    );
  }

  DropdownMenuItem<ContactLocal> dropDownMenuContactLocal(
      {required ContactLocal item, bool? isGrey}) {
    return DropdownMenuItem<ContactLocal>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.kCompanyUser,
        children: [
          Text(
            item.contactName ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.contactCode ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget buildSearchContactLocal(BuildContext context) {
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

// ignore: must_be_immutable
class DropDownButtonFormField2CYSiteWidget extends StatefulWidget {
  DropDownButtonFormField2CYSiteWidget(
      {super.key,
      this.value,
      required this.label,
      required this.hintText,
      required this.list,
      this.isRequired,
      required this.onChanged,
      this.isLabel,
      this.bgColor});
  final CySiteResponse? value;
  final String label;
  final bool? isRequired;
  final String hintText;
  Function(Object?) onChanged;
  final List<CySiteResponse> list;
  final bool? isLabel;
  final Color? bgColor;

  @override
  State<DropDownButtonFormField2CYSiteWidget> createState() =>
      _DropDownButtonFormField2CYSiteMaterialState();
}

class _DropDownButtonFormField2CYSiteMaterialState
    extends State<DropDownButtonFormField2CYSiteWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<CySiteResponse>(
      barrierColor: dropdown_custom.bgDrawerColor(),
      validator: (value) => value == null ? widget.hintText.tr() : null,
      decoration: InputDecoration(
        label: widget.isRequired ?? true
            ? Text.rich(TextSpan(children: [
                TextSpan(text: widget.label.tr()),
                const TextSpan(
                    text: ' *', style: TextStyle(color: colors.textRed)),
              ]))
            : Text(widget.label.tr()),
      ),
      isExpanded: true,
      value: widget.value,
      hint: Text(widget.hintText.tr()),
      items: widget.list.map((item) => dropDownMenuCYSite(item: item)).toList(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      onChanged: (value) => widget.onChanged(value),
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchLocController,
        searchInnerWidget:
            buildSearch(context: context, controller: searchLocController),
        searchMatchFn: (item, searchValue) {
          CySiteResponse cySite = item.value as CySiteResponse;
          return (cySite.cyName
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (TiengViet.parse(cySite.cyName.toString())
                  .toUpperCase()
                  .contains(TiengViet.parse(searchValue).toUpperCase()));
        },
      ),
      selectedItemBuilder: (context) {
        return widget.list.map((e) {
          return Text(
            e.cyName ?? '',
            textAlign: TextAlign.left,
          );
        }).toList();
      },
    );
  }

  DropdownMenuItem<CySiteResponse> dropDownMenuCYSite(
      {required CySiteResponse item}) {
    return DropdownMenuItem<CySiteResponse>(
      value: item,
      child: dropdown_custom
          .cardItemDropdown(assetIcon: assets.kCompanyUser, children: [
        Text(
          item.cyName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.defaultColor,
          ),
        )
      ]),
    );
  }
}

// ignore: must_be_immutable
class DropDownButtonFormField2TripModeWidget extends StatefulWidget {
  DropDownButtonFormField2TripModeWidget(
      {super.key,
      this.value,
      required this.hintText,
      required this.list,
      required this.onChanged,
      this.bgColor,
      required this.label});
  final StdCode? value;
  final String hintText;
  final String label;
  Function(Object?) onChanged;
  final List<StdCode> list;
  final Color? bgColor;

  @override
  State<DropDownButtonFormField2TripModeWidget> createState() =>
      _DropDownButtonFormField2TripModeMaterialState();
}

class _DropDownButtonFormField2TripModeMaterialState
    extends State<DropDownButtonFormField2TripModeWidget> {
  final searchLocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<StdCode>(
      decoration: InputDecoration(
          label: TextRichRequired(label: widget.label),
          floatingLabelBehavior: FloatingLabelBehavior.auto),
      barrierColor: dropdown_custom.bgDrawerColor(),
      validator: (value) => value == null ? '5067'.tr() : null,
      isExpanded: true,
      value: widget.value,
      hint: Text(widget.hintText.tr()),
      items:
          widget.list.map((item) => dropDownMenuTripMode(item: item)).toList(),
      buttonStyleData: const ButtonStyleData(height: 50),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      onChanged: (value) => widget.onChanged(value),
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchLocController,
        searchInnerWidget:
            buildSearch(context: context, controller: searchLocController),
        searchMatchFn: (item, searchValue) {
          StdCode itemNew = item.value as StdCode;
          return (itemNew.codeDesc
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (itemNew.codeId
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
    );
  }

  DropdownMenuItem<StdCode> dropDownMenuTripMode({required StdCode item}) {
    return DropdownMenuItem<StdCode>(
      value: item,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.icStd,
        children: [
          Text(
            item.codeDesc != null
                ? (item.codeId == "FinishedGoods"
                    ? '5204'.tr()
                    : item.codeId == "RawMaterial"
                        ? '5205'.tr()
                        : item.codeId == 'ReturnGoods'.tr()
                            ? '5206'.tr()
                            : item.codeDesc ?? '')
                : '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.defaultColor,
            ),
          ),
          Text(item.codeId ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

Widget buildSearch(
    {required BuildContext context,
    required TextEditingController controller}) {
  return Padding(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
    child: TextFormField(
      controller: controller,
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
        ),
      ),
    ),
  );
}
