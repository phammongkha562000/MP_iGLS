import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer_history/site_trailer_history_bloc.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/load/load_list.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/admin_component/cell_table.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../../widgets/table_widget/cell_table_no_data.dart';
import '../../../widgets/table_widget/header_table.dart';
import '../../../widgets/table_widget/table_data.dart';

class SiteTrailerHistoryView extends StatefulWidget {
  const SiteTrailerHistoryView({super.key, required this.trailer});
  final String trailer;

  @override
  State<SiteTrailerHistoryView> createState() => _SiteTrailerHistoryViewState();
}

class _SiteTrailerHistoryViewState extends State<SiteTrailerHistoryView> {
  late GeneralBloc generalBloc;
  late SiteTrailerHistoryBloc _bloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteTrailerHistoryBloc>(context);
    _bloc.add(SiteTrailerHistoryViewLoaded(
        trailer: widget.trailer, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5449'.tr())),
      body: BlocConsumer<SiteTrailerHistoryBloc, SiteTrailerHistoryState>(
        listener: (context, state) {
          if (state is SiteTrailerHistoryFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(
                context,
                btnMessage: '5038'.tr(),
                err: state.message,
                btnOkOnPress: () =>
                    BlocProvider.of<SiteTrailerHistoryBloc>(context).add(
                        SiteTrailerHistoryViewLoaded(
                            generalBloc: generalBloc, trailer: widget.trailer)),
              );
              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is SiteTrailerHistorySuccess) {
            return Column(
              children: [
                const SizedBox(height: 24),
                TableDataWidget(
                    listTableRowHeader: _headerTable(),
                    listTableRowContent: (state.historyFilterList == [] ||
                            state.historyFilterList.isEmpty)
                        ? [
                            const CellTableNoDataWidget(width: 1400),
                          ]
                        : List.generate(state.historyFilterList.length, (i) {
                            final item = state.historyFilterList[i];
                            return ColoredBox(
                              color: colorRowTable(index: i),
                              child: Row(children: [
                                CellTableWidget(
                                    content: (i + 1).toString(), width: 50),
                                CellTableWidget(
                                    content: item.trailerNumber ?? '',
                                    width: 100),
                                CellTableWidget(
                                    content: item.cntrStatus ?? '', width: 150),
                                CellTableWidget(
                                    content: item.cntrNo ?? '', width: 150),
                                CellTableWidget(
                                    content: item.tireStatus ?? '', width: 100),
                                CellTableWidget(
                                    content: item.ledStatus ?? '', width: 100),
                                CellTableWidget(
                                    content: FormatDateConstants
                                        .convertddMMyyyyHHmm2(
                                            item.createDate ?? ''),
                                    width: 150),
                                CellTableWidget(
                                    content: item.remark ?? '',
                                    isAlignLeft: true,
                                    width: 300),
                                CellTableWidget(
                                    content: item.cyName ?? '',
                                    isAlignLeft: true,
                                    width: 300),
                              ]),
                            );
                          })),
              ],
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '5586'.tr(), width: 50),
      HeaderTable2Widget(label: '4012'.tr(), width: 100),
      HeaderTable2Widget(label: '5126'.tr(), width: 150),
      HeaderTable2Widget(label: '3645'.tr(), width: 150),
      HeaderTable2Widget(label: '5129'.tr(), width: 100),
      HeaderTable2Widget(label: '5130'.tr(), width: 100),
      HeaderTable2Widget(label: '4330'.tr(), width: 150),
      HeaderTable2Widget(label: '1276'.tr(), width: 300),
      HeaderTable2Widget(label: '5124'.tr(), width: 300),
    ];
  }
}
