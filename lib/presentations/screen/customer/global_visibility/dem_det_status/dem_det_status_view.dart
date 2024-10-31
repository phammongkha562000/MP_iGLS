import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../../data/shared/utils/file_utils.dart';

class DemDetStatusView extends StatefulWidget {
  const DemDetStatusView({super.key});

  @override
  State<DemDetStatusView> createState() => _DemDetStatusViewState();
}

class _DemDetStatusViewState extends State<DemDetStatusView> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: const Text('DEM DET Status'),
        actions: [_iconSearch()],
      ),
    );
  }

  Widget _iconSearch() {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.black),
      onPressed: () async {
        await showModalBottomSheet(
            context: context,
            builder: (buildContext) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        '36'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    _buildFromToDate()
                  ],
                ),
              );
            });
      },
    );
  }

  Widget _buildFromToDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              pickDate(
                  date: fromDate,
                  context: context,
                  function: (selectDate) {
                    _fromDateController.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    fromDate = selectDate;
                    log(_fromDateController.text);
                  });
            },
            child: TextFormField(
              controller: _fromDateController,
              enabled: false,
              decoration: InputDecoration(
                  label: Text('5273'.tr()),
                  suffixIcon: const Icon(Icons.calendar_month,
                      color: colors.defaultColor)),
            ),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              pickDate(
                  date: toDate,
                  context: context,
                  function: (selectDate) {
                    _toDateController.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    toDate = selectDate;
                    log(_toDateController.text);
                  });
            },
            child: TextFormField(
              controller: _toDateController,
              enabled: false,
              decoration: InputDecoration(
                  label: Text('5274'.tr()),
                  suffixIcon: const Icon(Icons.calendar_month,
                      color: colors.defaultColor)),
            ),
          )),
        ],
      ),
    );
  }

  // Widget _buildTradeMode({
  //   required List<String> listTradeMode,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: CustomerDCDropdown(
  //         value: dcSelected,
  //         onChanged: (p0) {
  //           dcSelected = p0 as UserDCResult;
  //         },
  //         label: '1297',
  //         lstDC: lstDC),
  //   );
  // }
}
