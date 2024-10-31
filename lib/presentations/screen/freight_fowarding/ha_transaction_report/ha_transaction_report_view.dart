import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/transaction_report/transaction_report/transaction_report_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/ha_transaction_report/transaction_response.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/empty.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/widgets/pick_date_previous_next.dart';
import 'package:igls_new/presentations/widgets/table_widget/cell_table_view.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class TransactionReportView extends StatefulWidget {
  const TransactionReportView({super.key});

  @override
  State<TransactionReportView> createState() => _TransactionReportViewState();
}

class _TransactionReportViewState extends State<TransactionReportView> {
  late TransactionReportBloc _bloc;
  late GeneralBloc generalBloc;

  DateTime date = DateTime.now();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TransactionReportBloc>(context);
    _bloc.add(TransactionReportViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4705'.tr()),
      ),
      body: BlocConsumer<TransactionReportBloc, TransactionReportState>(
        listener: (context, state) {
          if (state is TransactionReportFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is TransactionReportSuccess) {
            return PickDatePreviousNextWidget(
                isMonth: true,
                onTapPrevious: () {
                  _bloc.add(TransactionReportViewLoaded(
                      generalBloc: generalBloc,
                      dateTime: DateTime(state.dateTime.year,
                          state.dateTime.month - 1, state.dateTime.day)));
                },
                onTapNext: () {
                  _bloc.add(TransactionReportViewLoaded(
                      generalBloc: generalBloc,
                      dateTime: DateTime(state.dateTime.year,
                          state.dateTime.month + 1, state.dateTime.day)));
                },
                onTapPick: (selectDate) {
                  setState(() {
                    date = selectDate;
                  });
                  _bloc.add(TransactionReportViewLoaded(
                      generalBloc: generalBloc, dateTime: date));
                },
                stateDate: state.dateTime,
                lstChild: _buildTable(report: state.report));
          }
          return const ItemLoading();
        },
      ),
    );
  }

  List<Widget> _buildTable({required TransactionReportResponse report}) {
    double totalCashIn = 0;
    double totalCashOut = 0;
    for (GetTransactionDetail element in report.getTransactionDetail ?? []) {
      totalCashIn += element.inAmount ?? 0;
      totalCashOut += element.outAmount ?? 0;
    }
    return [
      _buildCardBalance(
          isOpen: true, text: report.getTransactionDetails?.openBalance ?? 0),
      Expanded(
        child: report.getTransactionDetail!.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: colors.defaultColor),
                    defaultColumnWidth: report.getTransactionDetail!.isEmpty
                        ? const FlexColumnWidth()
                        : const IntrinsicColumnWidth(),
                    children: [
                      TableRow(
                          children: List.generate(
                              _headerTable.length,
                              (index) => HeaderTableWidget(
                                    headerText: _headerTable[index],
                                  ))),
                      ...List.generate(report.getTransactionDetail!.length,
                          (index) {
                        final item = report.getTransactionDetail![index];
                        return TableRow(
                            decoration: BoxDecoration(
                                color: colorRowTable(index: index)),
                            children: [
                              CellTableView(
                                  text: FileUtils.converFromDateTimeToStringdd(
                                      item.transactionDate.toString())),
                              CellTableView(
                                  text: NumberFormatter.numberFormatTotalQty(
                                      item.inAmount ?? 0)),
                              CellTableView(
                                  text: NumberFormatter.numberFormatTotalQty(
                                      item.outAmount ?? 0)),
                              CellTableView(
                                  text: NumberFormatter.numberFormatTotalQty(
                                      item.balance ?? 0)),
                              CellTableView(text: item.memo ?? ''),
                            ]);
                      }),
                      TableRow(
                          decoration: const BoxDecoration(color: colors.amber),
                          children: [
                            const CellTableView(text: ''),
                            CellTableView(
                              text: '1284'.tr(),
                              isBold: true,
                            ),
                            CellTableView(
                              text: NumberFormatter.numberFormatTotalQty(
                                  totalCashIn),
                              isBold: true,
                            ),
                            CellTableView(
                              text: NumberFormatter.numberFormatTotalQty(
                                  totalCashOut),
                              isBold: true,
                            ),
                            const CellTableView(text: ''),
                          ])
                    ],
                  ),
                ),
              )
            : const EmptyWidget(),
      ),
      Expanded(
        flex: -1,
        child: _buildCardBalance(
            isOpen: false,
            text: report.getTransactionDetails?.closeBalance ?? 0),
      ),
    ];
  }

  final List<String> _headerTable = [
    '239',
    '5565',
    '5566',
    '3595',
    '5564',
  ];

  Widget _buildCardBalance({required bool isOpen, required double text}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(color: colors.defaultColor.withOpacity(0.2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${isOpen ? '5567'.tr() : '5568'.tr()}: ',
                    style: const TextStyle(
                        color: colors.defaultColor, fontSize: 16)),
                TextSpan(
                    text: NumberFormatter.numberFormatTotalQty(text),
                    style: TextStyle(
                        color: isOpen ? Colors.black : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ]),
            ),
          ],
        ));
  }
}
