import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

import '../card_custom/card_custom.dart';
import '../widgets.dart';

ButtonStyleData customButtonStyleData() {
  return const ButtonStyleData(
    height: 50,
  );
}

MenuItemStyleData customMenuItemStyleData() {
  return MenuItemStyleData(
    height: 80,
    selectedMenuItemBuilder: (context, child) {
      return ColoredBox(
        color: colors.defaultColor,
        child: child,
      );
    },
  );
}

InputDecoration customInputDecoration({Color? color}) {
  return InputDecoration(
    errorStyle: const TextStyle(
      height: 0,
    ),
    fillColor: color,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.r),
    ),
  );
}

Widget iconItemDropdown({required String iconAsset, Color? colorIcon}) {
  return IconCustom(
    iConURL: iconAsset,
    color: colorIcon,
    size: 36,
  );
}

DropdownStyleData customDropdownStyleData(context) {
  return DropdownStyleData(
      padding: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      maxHeight: MediaQuery.sizeOf(context).height * 0.8);
}

Widget cardItemDropdown(
    {String? assetIcon, Color? colorIcon, required List<Widget> children}) {
  return CardItemDropdownWidget(
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: assetIcon != null
              ? iconItemDropdown(iconAsset: assetIcon, colorIcon: colorIcon)
              : const SizedBox(),
        ),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children),
        ),
      ],
    ),
  );
}

Color bgDrawerColor() => colors.bgDrawerColor;

Widget buildSearch(BuildContext context,
    {required TextEditingController controller,
    required void Function()? onPressed}) {
  return Padding(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
          hintText: '36'.tr(),
          hintStyle: const TextStyle(fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: colors.defaultColor,
          ),
          suffixIcon: IconButton(
              onPressed: onPressed,
              icon: const IconCustom(iConURL: assets.barCode, size: 40))),
    ),
  );
}

ButtonStyleData buttonStyleData = const ButtonStyleData(height: 48);

MenuItemStyleData menuItemStyleData =
    MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
  return ColoredBox(
    color: Theme.of(context).primaryColor.withOpacity(0.2),
    child: child,
  );
});

DropdownStyleData dropdownStyleData = DropdownStyleData(
  elevation: 8,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
  ),
  scrollbarTheme: ScrollbarThemeData(
    radius: const Radius.circular(50),
    thickness: MaterialStateProperty.all(6),
    thumbVisibility: MaterialStateProperty.all(true),
  ),
  maxHeight: 300,
);
