import 'package:flutter/material.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/shared.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class LoadingStatusView extends StatefulWidget {
  const LoadingStatusView({
    super.key,
    required this.etp,
  });
  final DateTime etp;

  @override
  State<LoadingStatusView> createState() => _LoadingStatusViewState();
}

class _LoadingStatusViewState extends State<LoadingStatusView> {
  final _navigationService = getIt<NavigationService>();
  DateTime dateTime = DateTime.now();
  late LoadingStatusBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<LoadingStatusBloc>(context);
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc.add(
        LoadingStatusViewLoaded(generalBloc: generalBloc, etp: widget.etp));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.homePageRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),

      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Scaffold(
          appBar: AppBarCustom(title: Text('4213'.tr())),
          body: BlocListener<LoadingStatusBloc, LoadingStatusState>(
            listener: (context, state) {
              if (state is LoadingStatusFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  CustomDialog().error(
                    context,
                    btnMessage: '5038'.tr(),
                    err: state.message,
                    btnOkOnPress: () => _bloc
                        .add(LoadingStatusViewLoaded(generalBloc: generalBloc)),
                  );
                  return;
                }
                CustomDialog().error(context, err: state.message);
              }
            },
            child: BlocBuilder<LoadingStatusBloc, LoadingStatusState>(
              builder: (context, state) {
                if (state is LoadingStatusSuccess) {
                  dateTime = state.dateTime;
                  return PickDatePreviousNextWidget(
                      quantityText: '${state.loadingStatusList.length}',
                      onTapPrevious: () {
                        _bloc.add(LoadingStatusChangeDate(
                            generalBloc: generalBloc,
                            dateTime: state.dateTime
                                .subtract(const Duration(days: 1))));
                      },
                      onTapPick: (selectDate) {
                        _bloc.add(LoadingStatusChangeDate(
                          dateTime: selectDate,
                          generalBloc: generalBloc,
                        ));
                      },
                      onTapNext: () {
                        _bloc.add(LoadingStatusChangeDate(
                            generalBloc: generalBloc,
                            dateTime:
                                state.dateTime.add(const Duration(days: 1))));
                      },
                      stateDate: state.dateTime,
                      child: _buildTable(
                          loadingStatusList: state.loadingStatusList));
                }
                return const ItemLoading();
              },
            ),
          )),
    );
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '5586', width: 50),
      HeaderTable2Widget(label: '3597', width: 110),
      HeaderTable2Widget(label: '1298', width: 110),
      HeaderTable2Widget(label: '4188', width: 150),
      HeaderTable2Widget(label: '5152', width: 150),
      HeaderTable2Widget(label: '5153', width: 150),
      HeaderTable2Widget(label: '4866', width: 120),
    ];
  }

  Widget _buildTable({required List<LoadingStatusResponse> loadingStatusList}) {
    return TableDataWidget(
      listTableRowHeader: _headerTable(),
      listTableRowContent: loadingStatusList.isNotEmpty
          ? List.generate(
              loadingStatusList.length,
              (index) {
                return ColoredBox(
                  color: colorRowTable(index: index),
                  child: InkWell(
                    onTap: () async {
                      final result =
                          await _navigationService.navigateAndDisplaySelection(
                        routes.loadingStatusDetailRoute,
                        args: {
                          key_params.tripNoLoadingStatus:
                              loadingStatusList[index].tripNo,
                          key_params.itemLoadingStatus:
                              loadingStatusList[index],
                          key_params.etpLoadingStatus: dateTime,
                        },
                      );
                      if (result != null) {
                        _bloc.add(LoadingStatusViewLoaded(
                          etp: result as DateTime,
                          generalBloc: generalBloc,
                        ));
                      }
                    },
                    child: Row(
                      children: [
                        CellTableWidget(
                          width: 50,
                          content: (index + 1).toString(),
                        ),
                        CellTableWidget(
                            width: 110,
                            content:
                                loadingStatusList[index].contactCode ?? ''),
                        CellTableWidget(
                            width: 110,
                            content: loadingStatusList[index].equipment ?? ''),
                        CellTableWidget(
                            width: 150,
                            content: loadingStatusList[index].staffName ?? ''),
                        CellTableWidget(
                          width: 150,
                          content:
                              FileUtils.converFromDateTimeToStringddMMyyyyHHmm(
                            loadingStatusList[index].loadingStart ?? '',
                          ),
                        ),
                        CellTableWidget(
                            width: 150,
                            content: FileUtils
                                .converFromDateTimeToStringddMMyyyyHHmm(
                                    loadingStatusList[index].loadingEnd ?? '')),
                        CellTableWidget(
                          width: 120,
                          content: loadingStatusList[index].tripNo.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : [
              const CellTableNoDataWidget(width: 840),
            ],
    );
  }
}
