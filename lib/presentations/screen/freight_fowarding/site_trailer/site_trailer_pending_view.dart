import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/navigator/navigator.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer_pending/site_trailer_pending_bloc.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/shared/utils/file_utils.dart';
import '../../../widgets/admin_component/cell_table.dart';
import '../../../widgets/admin_component/header_table.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/cell_table_no_data.dart';
import '../../../widgets/table_widget/table_data.dart';

class SiteTrailerPendingView extends StatefulWidget {
  const SiteTrailerPendingView({super.key, this.cyPending});
  final CySiteResponse? cyPending;
  @override
  State<SiteTrailerPendingView> createState() => _SiteTrailerPendingViewState();
}

class _SiteTrailerPendingViewState extends State<SiteTrailerPendingView> {
  late GeneralBloc generalBloc;
  late SiteTrailerPendingBloc _bloc;
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(
          CySiteResponse(cyCode: '', cyName: '5059'.tr()));

  final ValueNotifier<bool> _isPriorityNotifier = ValueNotifier<bool>(false);

  CySiteResponse? cySelected;

  BehaviorSubject<List<TrailerPendingRes>> lstPendingCtrl =
      BehaviorSubject<List<TrailerPendingRes>>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteTrailerPendingBloc>(context);
    _bloc.add(SiteTrailerPendingLoad(
        generalBloc: generalBloc, cyPending: widget.cyPending));
    if (widget.cyPending != null) {
      _cyNotifier.value = widget.cyPending!;
      cySelected = widget.cyPending;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CySiteResponse> listLocalCy = <CySiteResponse>[
      CySiteResponse(cyCode: '', cyName: '5059'.tr()),
    ];
    listLocalCy.addAll(generalBloc.listCY);
    return Scaffold(
        appBar: AppBarCustom(title: Text('5444'.tr())),
        body: BlocConsumer<SiteTrailerPendingBloc, SiteTrailerPendingState>(
          listener: (context, state) {
            if (state is SiteTrailerPendingFailure) {
              CustomDialog().error(context, err: state.message);
            }
            if (state is SiteTrailerPendingSuccess) {
              lstPendingCtrl.add(state.lstTrailerPendingFilter);
            }
          },
          builder: (context, state) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).height * 0.015,
                        vertical: MediaQuery.sizeOf(context).height * 0.03),
                    child: ValueListenableBuilder(
                      valueListenable: _cyNotifier,
                      builder: (context, value, child) =>
                          DropDownButtonFormField2CYSiteWidget(
                        onChanged: (value) {
                          value as CySiteResponse;
                          _cyNotifier.value = value;
                          cySelected = value;
                          _bloc.add(SiteTrailerIsPendingChanged(
                              isPending: _isPriorityNotifier.value,
                              generalBloc: generalBloc,
                              cyPending: value));
                        },
                        value: cySelected ?? listLocalCy[0],
                        hintText: '5083',
                        label: '5124',
                        list: listLocalCy,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _isPriorityNotifier,
                      builder: (context, value, child) {
                        return CheckboxListTile(
                          title: Text('5585'.tr()),
                          value: value,
                          controlAffinity: ListTileControlAffinity.leading,
                          visualDensity: const VisualDensity(vertical: -4),
                          onChanged: (value) {
                            _isPriorityNotifier.value = value as bool;
                            _bloc.add(SiteTrailerIsPendingChanged(
                                isPending: value,
                                generalBloc: generalBloc,
                                cyPending: _cyNotifier.value));
                          },
                        );
                      }),
                  StreamBuilder(
                      stream: lstPendingCtrl.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal:
                                MediaQuery.sizeOf(context).height * 0.015,
                          ),
                          child: Text(
                            (snapshot.hasError ||
                                    snapshot.data == null ||
                                    snapshot.data!.isEmpty)
                                ? '0 ${'5444'.tr()}'
                                : '${lstPendingCtrl.value.length} ${'5444'.tr()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      }),
                  (state is SiteTrailerPendingLoading)
                      ? const Center(
                          child: SpinKitWave(
                          color: colors.defaultColor,
                          size: 40.0,
                        )).paddingOnly(top: 100.h)
                      : StreamBuilder(
                          stream: lstPendingCtrl.stream,
                          builder: (context, snapshot) {
                            return TableDataWidget(
                                listTableRowHeader: _headerTable(),
                                listTableRowContent: (snapshot.hasError ||
                                        snapshot.data == null ||
                                        snapshot.data!.isEmpty)
                                    ? [const CellTableNoDataWidget(width: 1220)]
                                    : List.generate(snapshot.data!.length, (i) {
                                        final item = snapshot.data![i];
                                        return ColoredBox(
                                          color: colorRowTable(index: i),
                                          child: Row(children: [
                                            CellTableWidget(
                                                content: (i + 1).toString(),
                                                width: 50),
                                            _buildTrailerNo(
                                                trailerNo:
                                                    item.trailerNumber ?? ''),
                                            CellTableWidget(
                                                content: item.lastCheckDate !=
                                                            null &&
                                                        item.lastCheckDate != ''
                                                    ? FileUtils
                                                        .convertDateForHistoryDetailItem(
                                                            item.lastCheckDate ??
                                                                '')
                                                    : '',
                                                width: 150),
                                            CellTableWidget(
                                                content: item.lastCYName ?? '',
                                                width: 200),
                                            CellTableWidget(
                                                content: item.lastCNTR ?? '',
                                                width: 200),
                                            CellTableWidget(
                                                content:
                                                    item.lastContactCode ?? '',
                                                width: 200),
                                            CellTableWidget(
                                                content: item.lastRemark ?? '',
                                                isAlignLeft: true,
                                                width: 300),
                                          ]),
                                        );
                                      }));
                          }),
                ]);
          },
        ));
  }

  Widget _buildTrailerNo({
    required String trailerNo,
  }) {
    return Container(
      width: 120,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: Colors.black38,
      ))),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                shadowColor: MaterialStateProperty.all(colors.defaultColor),
                backgroundColor:
                    MaterialStateProperty.all(colors.defaultColor)),
            child: Text(
              trailerNo,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context, trailerNo);
            }),
      ),
    );
  }

  List<Widget> _headerTable() {
    return [
      const HeaderTable2Widget(label: '5586', width: 50),
      const HeaderTable2Widget(label: '4012', width: 120),
      const HeaderTable2Widget(label: '5445', width: 150),
      const HeaderTable2Widget(label: '5446', width: 200),
      const HeaderTable2Widget(label: 'Last CNTR', width: 200),
      const HeaderTable2Widget(label: 'Last Contact Code', width: 200),
      const HeaderTable2Widget(label: '1276', width: 300),
    ];
  }
}
