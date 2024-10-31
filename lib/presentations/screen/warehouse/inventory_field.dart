import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/row/row_4_6.dart';

class InventoryField extends StatelessWidget {
  const InventoryField({super.key, required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: RowFlex4and6(
          child4: Text(title.tr()),
          child6: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
