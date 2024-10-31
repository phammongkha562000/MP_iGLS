import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerModalBottomSheetSearch extends StatefulWidget {
  const CustomerModalBottomSheetSearch({
    super.key,
    required this.lstFieldSearch,
  });
  final List<Widget> lstFieldSearch;

  @override
  State<CustomerModalBottomSheetSearch> createState() =>
      _CustomerModalBottomSheetSearchState();
}

class _CustomerModalBottomSheetSearchState
    extends State<CustomerModalBottomSheetSearch> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.black),
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          builder: (buildContext) {
            return SizedBox(
              height: double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                        child: Text('36'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    Expanded(
                        child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shrinkWrap: true,
                            children: widget.lstFieldSearch)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
