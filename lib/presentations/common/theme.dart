import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/styles.dart' as styles;

ThemeData theme() {
  return ThemeData(
      //Font chữ cho toàn bộ source
      fontFamily: "Lato",
      appBarTheme: appBarTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      // textTheme: textTheme(),

      primaryColor: colors.defaultColor,
      dividerTheme: const DividerThemeData(color: Colors.grey),
      colorScheme: const ColorScheme.light(
        surface: Colors.white,
        primary: colors.defaultColor,
      ),
      iconTheme: const IconThemeData(color: colors.defaultColor, size: 24),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: Colors.white),
      bottomNavigationBarTheme: bottomNavigationBarThemeData(),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colors.defaultColor;
            }
            return Colors.transparent;
          },
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colors.defaultColor;
            }
            return Colors.grey;
          },
        ),
      ),
      dataTableTheme: DataTableThemeData(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber),
        ),
      ),
      cardTheme: const CardTheme(surfaceTintColor: Colors.white));
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      backgroundColor: colors.defaultColor,
      elevation: 0,
      titleTextStyle: textStyleAppBar(),
      actionsIconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white));
}

TextStyle textStyleAppBar() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

BottomNavigationBarThemeData bottomNavigationBarThemeData() {
  return BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: colors.defaultColor,
    showUnselectedLabels: false,
    selectedIconTheme: const IconThemeData(color: colors.defaultColor),
    selectedLabelStyle: selectedLabelStyle(),
  );
}

TextStyle selectedLabelStyle() {
  return const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
}

InputDecorationTheme inputDecorationTheme() {
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: const BorderSide(color: Colors.black54),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    prefixIconColor: colors.defaultColor,
    suffixIconColor: colors.defaultColor,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    enabledBorder: outlineInputBorder,
    disabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Colors.red),
    ),
    labelStyle: styles.styleLabelInput,
    errorStyle: const TextStyle(
      height: 0,
    ), //Dùng để khi eror nhưng vẫn giữ nguyên layout
  );
}

TextTheme textTheme() {
  return const TextTheme(
      titleSmall: TextStyle(fontSize: 10),
      titleMedium: TextStyle(fontSize: 10),
      bodySmall: TextStyle(fontSize: 10),
      bodyLarge: TextStyle(fontSize: 10),
      bodyMedium: TextStyle(fontSize: 14));
}

Widget appBarGradientColor() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: <Color>[colors.defaultColor, Colors.blue.shade100])),
  );
}

Widget gradientColorDecoration({required Widget child}) {
  return DecoratedBox(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: <Color>[colors.defaultColor, Colors.blue.shade100])),
    child: child,
  );
}

Widget appBarCustomerGradientColor() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: <Color>[colors.darkLiver, Colors.grey.shade100])),
  );
}
