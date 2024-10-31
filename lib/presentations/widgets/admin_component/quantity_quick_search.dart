import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityQuickSearchWidget extends StatefulWidget {
  const QuantityQuickSearchWidget({
    super.key,
    required this.quantity,
    required this.controller,
    this.onChanged,
  });
  final String quantity;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  @override
  State<QuantityQuickSearchWidget> createState() =>
      _QuantityQuickSearchMaterialState();
}

class _QuantityQuickSearchMaterialState
    extends State<QuantityQuickSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${'133'.tr()}: ${widget.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r)),
              child: TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search, color: Colors.red),
                  hintText: '5113'.tr(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.r)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.r)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.r)),
                ),
                controller: widget.controller,
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
