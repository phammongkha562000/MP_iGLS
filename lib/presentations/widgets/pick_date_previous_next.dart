import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as date_picker_plus;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/export_common.dart';
import 'package:igls_new/presentations/helps/custom_pick_date.dart';

class PickDatePreviousNextWidget extends StatefulWidget {
  const PickDatePreviousNextWidget(
      {super.key,
      required this.onTapPrevious,
      required this.onTapNext,
      required this.onTapPick,
      required this.stateDate,
      this.child,
      this.lstChild,
      this.quantityText,
      this.isMonth,
      this.childFilter});
  final VoidCallback onTapPrevious;
  final VoidCallback onTapNext;
  final dynamic onTapPick;
  final DateTime stateDate;
  final Widget? child;
  final List<Widget>? lstChild;
  final Widget? childFilter;
  final String? quantityText;
  final bool? isMonth;
  @override
  State<PickDatePreviousNextWidget> createState() =>
      _PickDatePreviousNextMaterialState();
}

class _PickDatePreviousNextMaterialState
    extends State<PickDatePreviousNextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconButton(
                iconData: Icons.arrow_left,
                onTap: widget.onTapPrevious,
              ),
              _iconButton(
                onTap: () => pickDate(
                    context: context,
                    isMonth: widget.isMonth,
                    date: widget.stateDate,
                    function: (selectedDate) => widget.onTapPick(selectedDate)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: colors.defaultColor)),
                    child: Text(
                      DateFormat(widget.isMonth ?? false
                              ? 'MM/yyyy'
                              : 'dd/MM/yyyy')
                          .format(widget.stateDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.defaultColor),
                    ),
                  ),
                ),
              ),
              _iconButton(
                iconData: Icons.arrow_right,
                onTap: widget.onTapNext,
              )
            ],
          ),
        ),
        Divider(
          color: colors.btnGreyDisable,
          thickness: 1,
          height: widget.child == null ? 0 : null,
        ),
        widget.childFilter ?? const SizedBox(),
        widget.quantityText != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Text(
                  '${'133'.tr()}: ${widget.quantityText}',
                  style: styleTextDefault,
                ),
              )
            : const SizedBox(),
        widget.child ?? const SizedBox(),
        ...widget.lstChild ?? []
      ],
    );
  }
}

TextStyle textStyle({Color? color, FontWeight? fontWeight}) => TextStyle(
    color: color ?? Colors.white, fontWeight: fontWeight ?? FontWeight.bold);
Widget _iconButton(
    {required VoidCallback onTap, IconData? iconData, Widget? child}) {
  return InkWell(
    onTap: onTap,
    child: iconData != null
        ? Icon(
            iconData,
            size: 48,
            color: colors.defaultColor,
          )
        : child,
  );
}

Future pickDate(
    {required BuildContext context,
    required DateTime date,
    bool? isMonth,
    required function,
    DateTime? firstDate,
    DateTime? lastDate}) async {
  String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
  date_picker_plus.LocaleType localeType = defaultLang == 'vi'
      ? date_picker_plus.LocaleType.vi
      : date_picker_plus.LocaleType.en;
  final DateTime? selectedDate = isMonth ?? false
      ? await date_picker_plus.DatePicker.showPicker(
          // ignore: use_build_context_synchronously
          context,
          locale: localeType,
          pickerModel: CustomMonthPicker(
              minTime: firstDate ?? DateTime(DateTime.now().year - 10, 12),
              maxTime: lastDate ?? DateTime(DateTime.now().year + 10, 12),
              currentTime: date,
              locale: localeType),
          theme: const date_picker_plus.DatePickerTheme(
            cancelStyle: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            doneStyle: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            headerColor: colors.defaultColor,
            itemStyle: TextStyle(
                fontSize: 16,
                color: colors.defaultColor,
                fontWeight: FontWeight.w500),
          ),
        )
      : await showDatePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialDate: date,
          currentDate: DateTime.now(),
          firstDate: firstDate ?? DateTime(DateTime.now().year - 5),
          lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
          builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      const ColorScheme.light(primary: colors.defaultColor)),
              child: child!),
        );
  if (selectedDate != null) {
    function(selectedDate);
  }
}

Future pickTime(
    {required BuildContext context,
    required function,
    required String? initTime}) async {
  TimeOfDay initTimeTOD = TimeOfDay(
      hour: int.parse(initTime!.split(":")[0]),
      minute: int.parse(initTime.split(":")[1]));
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: initTimeTOD,
    builder: (context, child) {
      return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: colors.defaultColor,
            ),
          ),
          child: child ?? Container());
    },
  );
  if (selectedTime != null) {
    function(selectedTime);
  }
}
