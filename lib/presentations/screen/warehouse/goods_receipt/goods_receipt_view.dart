import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/ware_house/goods_receipt/goods_receipt_bloc.dart';
import 'package:igls_new/data/models/ware_house/goods_receipt/good_receipt_order_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/common/styles.dart';

import 'package:igls_new/presentations/widgets/widgets.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;

class GoodsReceiptView extends StatefulWidget {
  const GoodsReceiptView({super.key});

  @override
  State<GoodsReceiptView> createState() => _GoodsReceiptViewState();
}

class _GoodsReceiptViewState extends State<GoodsReceiptView> {
  final _dateController = TextEditingController();
  final ValueNotifier<String?> _orderNotifer = ValueNotifier<String>('');
  late GoodsReceiptBloc _bloc;
  late GeneralBloc generalBloc;
  final _navigationService = getIt<NavigationService>();
  @override
  void initState() {
    _bloc = BlocProvider.of<GoodsReceiptBloc>(context);
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc.add(
        GoodsReceiptViewLoaded(generalBloc: generalBloc, date: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('162'.tr()),
      ),
      body: BlocConsumer<GoodsReceiptBloc, GoodsReceiptState>(
        listener: (context, state) {
          if (state is GoodsReceiptFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is GoodsReceiptSuccess) {
            _dateController.text =
                DateFormat(constants.formatddMMyyyy).format(state.date);
            _orderNotifer.value = state.orderNo ?? '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardCustom(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 3, child: Text('5090'.tr())),
                        const WidthSpacer(width: 0.01),
                        Expanded(
                            flex: 7,
                            child: TextField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () => pickDate(
                                      context: context,
                                      date: state.date,
                                      function: (selectedDate) {
                                        _bloc.add(GoodsReceiptPickDate(
                                            generalBloc: generalBloc,
                                            date: selectedDate));
                                      }),
                                  icon: const Icon(Icons.calendar_month),
                                ),
                              ),
                            )),
                      ],
                    ),
                    const HeightSpacer(height: 0.01),
                    Row(
                      children: [
                        Expanded(flex: 3, child: Text('122'.tr())),
                        const WidthSpacer(width: 0.01),
                        Expanded(
                          flex: 6,
                          child: DropdownButtonFormField2(
                            decoration: customInputDecoration(),
                            barrierColor: dropdown_custom.bgDrawerColor(),
                            items: state.orderList
                                .map((e) => e.orderNo!)
                                .toList()
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            buttonStyleData:
                                dropdown_custom.customButtonStyleData(),
                            menuItemStyleData: MenuItemStyleData(
                              selectedMenuItemBuilder: (context, child) {
                                return ColoredBox(
                                    color: colors.defaultColor.withOpacity(0.2),
                                    child: child);
                              },
                            ),
                            value: state.orderNo,
                            onChanged: (value) {
                              _orderNotifer.value = value as String;
                              _bloc
                                  .add(GoodsReceiptPickOrderNo(orderNo: value));
                              _bloc.add(GoodsReceiptSearch(
                                  generalBloc: generalBloc,
                                  orderNo: _orderNotifer.value ?? ''));
                            },
                            isExpanded: true,
                            dropdownStyleData: dropdown_custom
                                .customDropdownStyleData(context),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                _bloc.add(GoodsReceiptSearch(
                                    generalBloc: generalBloc,
                                    orderNo: _orderNotifer.value ?? ''));
                              },
                              icon: const Icon(Icons.search_rounded)),
                        )
                      ],
                    )
                  ],
                )),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: Text(
                    state.goodsReceipt == null
                        ? '${'133'.tr()}: '
                        : '${'133'.tr()}: ${state.goodsReceipt!.returnModel!.length}',
                    style: styleTextDefault,
                  ),
                ),
                _buildTable(
                    goodsReceipt: state.goodsReceipt ?? GoodsReceiptResponse())
              ],
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      fillColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(
        height: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.r),
      ),
    );
  }

  Widget _buildTable({required GoodsReceiptResponse goodsReceipt}) {
    return (goodsReceipt.returnModel != null) &&
            (goodsReceipt.returnModel!.isNotEmpty)
        ? TableDataWidget(
            listTableRowHeader: const [
                HeaderTable2Widget(label: '5586', width: 50),
                HeaderTable2Widget(label: '128', width: 200),
                HeaderTable2Widget(label: '131', width: 300),
                HeaderTable2Widget(label: '133', width: 100),
                HeaderTable2Widget(label: '178', width: 100),
              ],
            listTableRowContent: List.generate(
              goodsReceipt.returnModel!.length,
              (i) {
                final item = goodsReceipt.returnModel![i];

                return InkWell(
                  onTap: () async {
                    final result = await _navigationService
                        .navigateAndDisplaySelection(
                            routes.goodsReceiptDetailRoute,
                            args: {key_params.goodsReceipt: item});
                    if (result != null) {
                      final item2 = result as GoodReceiptOrderResponse;
                      _bloc.add(GoodsReceiptSearch(
                          orderNo: item2.clientRefNo!,
                          generalBloc: generalBloc));
                    }
                  },
                  child: ColoredBox(
                    color: colorRowTable(index: i),
                    child: Row(
                      children: [
                        CellTableWidget(content: (i + 1).toString(), width: 50),
                        CellTableWidget(
                            content: item.itemCode ?? '', width: 200),
                        CellTableWidget(
                            content: item.itemDesc ?? '', width: 300),
                        CellTableWidget(
                            content: NumberFormatter.numberFormatTotalQty(
                                item.qty ?? 0),
                            width: 100),
                        CellTableWidget(
                            content: NumberFormatter.numberFormatTotalQty(
                                item.grQty ?? 0),
                            width: 100),
                      ],
                    ),
                  ),
                );
              },
            ))
        : TableView(
            tableColumnWidth:
                FixedColumnWidth((MediaQuery.sizeOf(context).width - 16.w) / 5),
            headerChildren: _headerStrTable,
            rowChildren: const []);
  }

  final List<String> _headerStrTable = [
    '5586',
    '128',
    '131',
    '133',
    '178',
  ];
}
