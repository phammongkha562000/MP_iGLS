import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../businesses_logics/bloc/customer/customer_profile/customer_profile_bloc.dart';
import '../../../../data/models/customer/customer_profile/time_line_payload.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../../widgets/load/load_list.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CustomerTimeLineView extends StatefulWidget {
  const CustomerTimeLineView({super.key});

  @override
  State<CustomerTimeLineView> createState() => _CustomerTimeLineViewState();
}

class _CustomerTimeLineViewState extends State<CustomerTimeLineView> {
  late CustomerProfileBloc cusProfileBloc;
  late CustomerBloc customerBloc;
  BehaviorSubject<List<TimeLine>> lstTimeLine =
      BehaviorSubject<List<TimeLine>>();
  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cusProfileBloc = BlocProvider.of<CustomerProfileBloc>(context)
      ..add(GetTimeLineEvent(customerBloc: customerBloc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        title: Text("5411".tr()),
      ),
      body: BlocConsumer<CustomerProfileBloc, CustomerProfileState>(
          listener: (context, state) {
        if (state is GetTimeLineSuccess) {
          lstTimeLine.add(state.lstTimeLine);
        }
        if (state is GetTimeLineFail) {
          CustomDialog().error(context, err: state.message, btnOkOnPress: () {
            Navigator.pop(context);
          });
        }
      }, builder: (context, state) {
        if (state is ChangeProfileShowLoadingState) {
          return const ItemLoading();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 8.w),
          child: StreamBuilder<List<TimeLine>>(
              stream: lstTimeLine.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    return TableView(
                      columnWidths: <int, TableColumnWidth>{
                        0: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) * 0.2),
                        1: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) * 0.4),
                        2: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) * 0.4),
                      },
                      headerChildren: const ['13', '4082', '239'],
                      rowChildren:
                          List.generate(snapshot.data!.length, (index) {
                        final item = snapshot.data![index];
                        return TableRow(children: [
                          _buildText(
                            text: item.userId,
                          ),
                          _buildText(
                            text: item.ipAddress,
                          ),
                          _buildText(
                            text: DateFormat('MM/dd/yyyy hh:mm a')
                                .format(DateTime.parse(item.lDate)),
                          ),
                        ]);
                      }),
                    );
                    /* TableDataWidget(
                        listTableRowHeader: _headerTable(),
                        listTableRowContent:
                            List.generate(snapshot.data!.length, (index) {
                          final item = snapshot.data![index];
                          return ColoredBox(
                            color: colorRowTable(index: index),
                            child: Row(children: [
                              CellTableWidget(
                                width: 150,
                                content: item.userId,
                              ),
                              CellTableWidget(
                                width: 210,
                                content: item.ipAddress,
                              ),
                              CellTableWidget(
                                width: 210,
                                content: DateFormat('MM/dd/yyyy hh:mm a')
                                    .format(DateTime.parse(item.lDate)),
                              ),
                            ]),
                          );
                        })); */
                  }
                  return const SizedBox();
                }
                return const SizedBox();
                /*  return Expanded(
                    child: Column(
                      children: [
                        TableDataWidget(
                            listTableRowHeader: _headerTable(),
                            listTableRowContent: const []),
                        Expanded(
                          child: Text(
                            "5058".tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return TableDataWidget(
                    listTableRowHeader: _headerTable(),
                    listTableRowContent: const []); */
              }),
        );
      }),
    );
  }

  // List<Widget> _headerTable() {
  //   return [
  //     const HeaderTable2Widget(label: '13', width: 150),
  //     const HeaderTable2Widget(label: '4082', width: 210),
  //     const HeaderTable2Widget(label: '239', width: 210),
  //   ];
  // }

  Widget _buildText(
      {required String text,
      bool? isShipTo,
      bool? isNoData,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: text.length > 50 ? 200 : null,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
            child: Text(text,
                maxLines: 2,
                textAlign:
                    isShipTo ?? false ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                  fontStyle:
                      onTap != null ? FontStyle.italic : FontStyle.normal,
                  color: isNoData ?? false
                      ? colors.btnGreyDisable
                      : onTap != null
                          ? colors.defaultColor
                          : Colors.black,
                ))),
      ),
    );
  }
}
