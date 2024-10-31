import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import '../../../widgets/app_bar_custom.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  List<Language> listLang = [
    Language(lang: "English", langCode: "en", icon: assets.en),
    Language(lang: "Tiếng Việt", langCode: "vi", icon: assets.vi),
  ];

  Language? selectedLang;

  @override
  Widget build(BuildContext context) {
    String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
    if (defaultLang == "en") {
      selectedLang = listLang[0];
    } else if (defaultLang == "vi") {
      selectedLang = listLang[1];
    }
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("language".tr()),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "language".tr(),
              style: styleTextTitle,
            ),
            const HeightSpacer(height: 0.01),
            DropdownButtonFormField2(
              items: listLang
                  .map((item) => DropdownMenuItem<Language>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.lang),
                              IconCustom(iConURL: item.icon, size: 30)
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              menuItemStyleData: MenuItemStyleData(
                // height: 100,
                selectedMenuItemBuilder: (context, child) {
                  return Container(
                    color: colors.defaultColor.withOpacity(0.2),
                    child: child,
                  );
                },
              ),
              selectedItemBuilder: (context) {
                return listLang
                    .map(
                      (item) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.lang),
                          IconCustom(iConURL: item.icon, size: 25)
                        ],
                      ),
                    )
                    .toList();
              },
              value: selectedLang,
              onChanged: (value) {
                value as Language;
                context.setLocale(Locale(value.langCode));
              },
              barrierColor: dropdown_custom.bgDrawerColor(),
              buttonStyleData: const ButtonStyleData(
                  height: 50, padding: EdgeInsets.symmetric(horizontal: 16)),
              decoration: customInputDecoration(),
              isExpanded: true,
              dropdownStyleData:
                  dropdown_custom.customDropdownStyleData(context),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      errorStyle: const TextStyle(
        height: 0,
      ), //Dù,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  BoxDecoration decorationButton() {
    return BoxDecoration(
      color: colors.textWhite,
      border: Border.all(),
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class Language {
  final String lang;
  final String langCode;
  final String icon;
  Language({
    required this.lang,
    required this.langCode,
    required this.icon,
  });
}
