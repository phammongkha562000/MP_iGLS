import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/ware_house/inventory/inventory_detail/inventory_detail_bloc.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';

import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class InventoryDetailView extends StatefulWidget {
  const InventoryDetailView({
    super.key,
    required this.sbNo,
    required this.dcCode,
    required this.contactCode,
  });
  final int sbNo;
  final String dcCode;
  final String contactCode;

  @override
  State<InventoryDetailView> createState() => _InventoryDetailViewState();
}

class _InventoryDetailViewState extends State<InventoryDetailView> {
  late InventoryDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<InventoryDetailBloc>(context);
    _bloc.add(InventoryDetailLoaded(
      generalBloc: generalBloc,
      sbNo: widget.sbNo,
      dcCode: widget.dcCode,
      contactCode: widget.contactCode,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<InventoryDetailBloc, InventoryDetailState>(
      listener: (context, state) {
        if (state is InventoryDetailFailure) {
          CustomDialog().error(context, err: state.message);
        }
      },
      builder: (context, state) {
        if (state is InventoryDetailSuccess) {
          final String grDate;
          final String prodDate;
          final String expDate;
          state.inventory.grDate == null
              ? grDate = ""
              : grDate = FileUtils.converFromDateTimeToStringddMMyyyyHHmm(
                  state.inventory.grDate.toString());
          state.inventory.productionDate == null
              ? prodDate = ""
              : prodDate = FileUtils.converFromDateTimeToStringddMMyyyy(
                  state.inventory.productionDate.toString());

          state.inventory.expiredDate == null
              ? expDate = ""
              : expDate = FileUtils.converFromDateTimeToStringddMMyyyy(
                  state.inventory.expiredDate.toString());

          double qtyPallet = state.inventory.qtyOfPallet == null
              ? 0
              : double.parse(state.inventory.qtyOfPallet.toString());
          double availabileQty = state.inventory.availabileQty == null
              ? 0
              : double.parse(state.inventory.availabileQty.toString());
          double paletQty = (availabileQty / qtyPallet);
          paletQty.toStringAsFixed(3);

          double availabile =
              double.parse(state.inventory.availabileQty.toString());
          double base = double.parse(state.inventory.baseQty.toString());
          double expectedSku = 0;
          expectedSku = availabile / base == 0 ? 1 : base;
          log(expectedSku.toString());
          return Scaffold(
            appBar: AppBarCustom(
              title: Text(
                  "${state.inventory.itemCode} / ${state.inventory.locCode}"),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardCustom(
                    child: Column(
                      children: [
                        itemRow(
                            title: (state.inventory.itemCode ?? ""),
                            content: "${state.inventory.itemDesc}"),
                        itemRow(
                            title: "178",
                            content: NumberFormatter.numberFormatTotalQty(
                                state.inventory.grQty!)),
                        itemRow(
                            title: "180",
                            content: NumberFormatter.numberFormatTotalQty(
                                state.inventory.balance!)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "194".tr(),
                                  style: styleTextTitle,
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                    NumberFormatter.numberFormatTotalQty(
                                        state.inventory.reservedQty!),
                                    style: const TextStyle(
                                      color: colors.textRed,
                                      fontSize: sizeTextDefault,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        itemRow(
                            title: "195",
                            content: NumberFormatter.numberFormatTotalQty(
                                state.inventory.availabileQty!)),
                        itemRow(title: "171", content: grDate),
                        itemRow(title: "167", content: prodDate),
                        itemRow(title: "166", content: expDate),
                        itemRow(
                            title: "122",
                            content: "${state.inventory.clientRefNo}")
                      ],
                    ),
                  ),
                  CardCustom(
                    child: Column(
                      children: [
                        itemRow(
                            title: "1279",
                            content: "${state.inventory.itemStatus}"),
                        itemRow(
                            title: "132", content: "${state.inventory.grade}"),
                        itemRow(
                            title: "148",
                            content: state.inventory.lotCode ?? ''),
                      ],
                    ),
                  ),
                  CardCustom(
                    child: Column(
                      children: [
                        itemRow(
                            title: "238",
                            content: "${state.inventory.skuDesc}"),
                        itemRow(
                          title: "5162",
                          content:
                              NumberFormatter.numberFormatTotalQty(expectedSku),
                        ),
                        itemRow(
                            title: "3550",
                            content:
                                "${state.inventory.capacity.toString().split(".").first}"
                                " PLT"),
                      ],
                    ),
                  ),
                  CardCustom(
                    child: Column(
                      children: [
                        itemRow(
                            title: "5163",
                            content: state.inventory.qtyOfPallet != null &&
                                    state.inventory.qtyOfPallet != ''
                                ? state.inventory.qtyOfPallet
                                    .toString()
                                    .split(".")
                                    .first
                                : ''),
                        itemRow(
                          title: "5164",
                          content: qtyPallet == 0 || availabileQty == 0
                              ? ''
                              : NumberFormatter.numberFormatTotalQty(paletQty),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.03,
                    ),
                    child: Text("5165".tr(), style: styleTextTitle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: state.listReserved.isEmpty
                        ? buildTableNodata(context)
                        : _buildTable(state),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is InventoryDetailFailure) {
          return Scaffold(
            appBar: AppBarCustom(
              title: const Text("System Failure"),
            ),
            body: const Center(
              child: Text(
                "That's a system failure! ",
                style: styleTextDefault,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBarCustom(),
          body: const ItemLoading(),
        );
      },
    );
  }

  Widget _buildTable(InventoryDetailSuccess state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          showCheckboxColumn: false,
          decoration: const BoxDecoration(color: Colors.white),
          border: TableBorder.all(
            color: colors.defaultColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          headingRowColor: MaterialStateProperty.all(colors.defaultColor),
          columns: const <DataColumn>[
            DataColumn(
                label: Expanded(child: HeaderTableWidget(headerText: '5586'))),
            DataColumn(
                label: Expanded(child: HeaderTableWidget(headerText: '122'))),
            DataColumn(
                numeric: true,
                label: Expanded(child: HeaderTableWidget(headerText: '133'))),
            DataColumn(
                label: Expanded(child: HeaderTableWidget(headerText: '2468'))),
          ],
          rows: List.generate(
            state.listReserved.length,
            (i) {
              final item = state.listReserved[i];
              final etp = item.etp != null
                  ? FormatDateConstants.getYYYYMMDDHHMMSStoMMDDYYYY(
                      item.etp ?? '')
                  : '';
              return DataRow(cells: <DataCell>[
                DataCell(Text(etp)),
                DataCell(
                  Text(
                    item.orderNo.toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
                DataCell(Text(
                  NumberFormatter.numberFormatTotalQty(item.qty!),
                  style: styleTextError,
                  textAlign: TextAlign.right,
                )),
                DataCell(Text(item.tripNo ?? '')),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget itemInTable({required String item}) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Text(
        item,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget itemRow({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title.tr(),
              style: styleTextTitle,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(content, style: styleTextDefault),
          ),
        ],
      ),
    );
  }

  Widget buildTableNodata(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.defaultColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HeaderTableWidget(headerText: "5586"),
              HeaderTableWidget(headerText: '122'),
              HeaderTableWidget(headerText: "133"),
              HeaderTableWidget(headerText: '2468')
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r)),
            border: Border.all(color: colors.defaultColor),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
              child: const EmptyWidget()),
        ),
      ],
    );
  }
}
