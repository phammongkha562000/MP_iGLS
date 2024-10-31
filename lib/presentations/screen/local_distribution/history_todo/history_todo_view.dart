import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:rxdart/subjects.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class HistoryTodoView extends StatefulWidget {
  const HistoryTodoView({super.key});

  @override
  State<HistoryTodoView> createState() => _HistoryTodoViewState();
}

class _HistoryTodoViewState extends State<HistoryTodoView> {
  final _navigationService = getIt<NavigationService>();
  late HistoryTodoBloc _bloc;
  late GeneralBloc generalBloc;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ValueNotifier<DateTime> _dateNotifier = ValueNotifier(DateTime.now());
  BehaviorSubject<List<HistoryTrip>> historyList = BehaviorSubject();
  int quantity = 0;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<HistoryTodoBloc>(context);
    _bloc
        .add(HistoryTodoLoaded(date: DateTime.now(), generalBloc: generalBloc));
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(HistoryTodoPaging(
            generalBloc: generalBloc, date: _dateNotifier.value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text(
          "4090".tr(),
        ),
      ),
      body: BlocConsumer<HistoryTodoBloc, HistoryTodoState>(
        listener: (context, state) {
          if (state is HistoryTodoFailure) {
            if (state.errorCode == constants.errorNullEquipDriverId) {
              CustomDialog().error(context,
                  err: state.message,
                  btnOkOnPress: () => Navigator.of(context).pop());

              return;
            }
            CustomDialog().error(context, err: state.message);
          }
          if (state is HistoryTodoSuccess) {
            historyList.add(state.historyList ?? []);
            setState(() {
              quantity = state.quantity;
            });
          }
        },
        builder: (context, state) {
          return ValueListenableBuilder(
            valueListenable: _dateNotifier,
            builder: (context, value, child) {
              return PickDatePreviousNextWidget(
                  isMonth: true,
                  onTapPrevious: () {
                    _bloc.add(HistoryTodoLoaded(
                        date: DateTime(_dateNotifier.value.year,
                            _dateNotifier.value.month - 1, 15),
                        generalBloc: generalBloc));
                    _dateNotifier.value = DateTime(_dateNotifier.value.year,
                        _dateNotifier.value.month - 1, 15);
                  },
                  onTapNext: () {
                    _bloc.add(HistoryTodoLoaded(
                        date: DateTime(_dateNotifier.value.year,
                            _dateNotifier.value.month + 1, 15),
                        generalBloc: generalBloc));
                    _dateNotifier.value = DateTime(_dateNotifier.value.year,
                        _dateNotifier.value.month + 1, 15);
                  },
                  onTapPick: (selectDate) {
                    _dateNotifier.value = selectDate;
                    _bloc.add(HistoryTodoLoaded(
                        date: selectDate, generalBloc: generalBloc));
                  },
                  stateDate: _dateNotifier.value,
                  quantityText: "$quantity",
                  lstChild: (state is HistoryTodoLoading)
                      ? [const SpinKitLoading()]
                      : [
                          _buildTable(state: state),
                          state is HistoryTodoPagingLoading
                              ? const Center(child: PagingLoading())
                              : const SizedBox(),
                        ]);
            },
          );
        },
      ),
    );
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '5586', width: 50),
      HeaderTable2Widget(label: '5588', width: 80),
      HeaderTable2Widget(label: '3597', width: 120),
      HeaderTable2Widget(label: '2482', width: 300),
      HeaderTable2Widget(label: '1279', width: 110),
      HeaderTable2Widget(label: '4519', width: 300)
    ];
  }

  Widget _buildTable({required HistoryTodoState state}) {
    return StreamBuilder(
      stream: historyList.stream,
      builder: (context, snapshot) {
        return TableDataWidget(
            verticalScrollController: _scrollController,
            horizontalScrollController: _horizontalScrollController,
            listTableRowHeader: _headerTable(),
            listTableRowContent: (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty ||
                    snapshot.data == [])
                ? [const CellTableNoDataWidget(width: 960)]
                : List.generate(
                    snapshot.data!.length,
                    (index) {
                      final HistoryTrip item = snapshot.data![index];
                      return ColoredBox(
                        color: colorRowTable(index: index),
                        child: InkWell(
                          onTap: item.tripNo!.startsWith('S')
                              ? () async {
                                  _navigationService.pushNamed(
                                      routes.historyTodoSimpleRoute,
                                      args: {
                                        key_params.tripHistory: item,
                                      });
                                }
                              : () async {
                                  _navigationService.pushNamed(
                                      routes.historyTodoNormalRoute,
                                      args: {
                                        key_params.tripHistory: item,
                                      });
                                },
                          child: Row(
                            children: [
                              CellTableWidget(
                                  width: 50, content: (index + 1).toString()),
                              CellTableWidget(
                                  width: 80,
                                  content: FormatDateConstants.convertddMM(
                                      item.etp ?? '')),
                              CellTableWidget(
                                  width: 120, content: item.contactCode ?? ''),
                              CellTableWidget(
                                  width: 300,
                                  isAlignLeft: true,
                                  content: item.shipToName ?? ''),
                              CellTableWidget(
                                  width: 110, content: item.tripStatus ?? ''),
                              CellTableWidget(
                                  width: 300,
                                  content: item.driverTripTypeDesc ?? '')
                            ],
                          ),
                        ),
                      );
                    },
                  ));
      },
    );
  }
}
