import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer_check_detail/site_trailer_check_detail_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/enum/working_status_trailer.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';

import 'package:igls_new/presentations/widgets/widgets.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../common/styles.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class SiteTrailerDetailView extends StatefulWidget {
  final String cyName;
  const SiteTrailerDetailView({
    super.key,
    required this.cyName,
  });

  @override
  State<SiteTrailerDetailView> createState() => _SiteTrailerDetailViewState();
}

class _SiteTrailerDetailViewState extends State<SiteTrailerDetailView> {
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(CySiteResponse(cyCode: '', cyName: ''));

  CySiteResponse? cySelected;

  late GeneralBloc generalBloc;
  late SiteTrailerCheckDetailBloc _bloc;
  int totalEmpty = 0;
  int totalLoaded = 0;
  int totalAll = 0;

  final yourScrollController = ScrollController();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteTrailerCheckDetailBloc>(context);
    _bloc.add(SiteTrailerCheckDetailViewLoaded(
        cyName: widget.cyName, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5136'.tr())),
      body:
          BlocListener<SiteTrailerCheckDetailBloc, SiteTrailerCheckDetailState>(
        listener: (context, state) {
          if (state is SiteTrailerCheckDeleteSuccess) {
            _bloc.add(SiteTrailerCheckDetailViewLoaded(
                cyName: cySelected == null ? '' : cySelected!.cyName ?? '',
                generalBloc: generalBloc));
          }
          if (state is SiteTrailerCheckDetailFailure) {
            CustomDialog().error(context,
                err: state.message,
                btnOkOnPress: () =>
                    BlocProvider.of<SiteTrailerCheckDetailBloc>(context).add(
                        SiteTrailerCheckDetailViewLoaded(
                            generalBloc: generalBloc, cyName: widget.cyName)));
          }
        },
        child: BlocBuilder<SiteTrailerCheckDetailBloc,
            SiteTrailerCheckDetailState>(
          builder: (context, state) {
            if (state is SiteTrailerCheckDetailSuccess) {
              totalEmpty = 0;
              totalLoaded = 0;
              totalAll = 0;
              if (state.cySite != null) {
                _cyNotifier.value = state.cySite!;
                cySelected = state.cySite;
              }
              List<CySiteResponse> listLocalCy = <CySiteResponse>[
                CySiteResponse(cyCode: '', cyName: ''),
              ];
              listLocalCy = state.cySiteList;
              for (var e in state.lstTrailerSumary) {
                totalEmpty += e.empty ?? 0;
                totalLoaded += e.loaded ?? 0;
                totalAll += e.total ?? 0;
              }
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.sizeOf(context).height * 0.015,
                            vertical: MediaQuery.sizeOf(context).height * 0.03),
                        child: ValueListenableBuilder(
                          valueListenable: _cyNotifier,
                          builder: (context, value, child) =>
                              DropDownButtonFormField2CYSiteWidget(
                            onChanged: (value) {
                              value as CySiteResponse;
                              _cyNotifier.value = value;
                              cySelected = value;
                              BlocProvider.of<SiteTrailerCheckDetailBloc>(
                                      context)
                                  .add(SiteTrailerCheckDetailPickCysite(
                                      generalBloc: generalBloc,
                                      cySiteCode: value.cyCode));
                            },
                            value: cySelected ?? listLocalCy[0],
                            hintText: '5083',
                            label: '5124',
                            list: listLocalCy,
                          ),
                        ),
                      ),
                      _titleTable(
                        title: '145'.tr(),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            TableDataWidget(
                                listTableRowHeader: _headerTableSumary(),
                                listTableRowContent: (state.lstTrailerSumary ==
                                            [] ||
                                        state.lstTrailerSumary.isEmpty)
                                    ? [
                                        const CellTableNoDataWidget(width: 500),
                                      ]
                                    : List.generate(
                                        state.lstTrailerSumary.length, (i) {
                                        final item = state.lstTrailerSumary[i];
                                        if (i ==
                                            state.lstTrailerSumary.length - 1) {
                                          return Column(
                                            children: [
                                              ColoredBox(
                                                color: colorRowTable(index: i),
                                                child: Row(children: [
                                                  CellTableWidget(
                                                      content:
                                                          item.cYName ?? '',
                                                      width: 200),
                                                  CellTableWidget(
                                                      content: item.loaded
                                                          .toString(),
                                                      width: 100),
                                                  CellTableWidget(
                                                      content:
                                                          item.empty.toString(),
                                                      width: 100),
                                                  CellTableWidget(
                                                      content:
                                                          item.total.toString(),
                                                      width: 100),
                                                ]),
                                              ),
                                              ColoredBox(
                                                color:
                                                    colorRowTable(index: i - 1),
                                                child: Row(children: [
                                                  CellTableWidget(
                                                      isHighlight: true,
                                                      colorHightLight:
                                                          Colors.black,
                                                      content: '1284'.tr(),
                                                      width: 200),
                                                  CellTableWidget(
                                                      isHighlight: true,
                                                      colorHightLight:
                                                          Colors.black,
                                                      content: totalLoaded
                                                          .toString(),
                                                      width: 100),
                                                  CellTableWidget(
                                                      isHighlight: true,
                                                      colorHightLight:
                                                          Colors.black,
                                                      content:
                                                          totalEmpty.toString(),
                                                      width: 100),
                                                  CellTableWidget(
                                                      isHighlight: true,
                                                      colorHightLight:
                                                          Colors.black,
                                                      content:
                                                          totalAll.toString(),
                                                      width: 100),
                                                ]),
                                              ),
                                            ],
                                          );
                                        }
                                        return ColoredBox(
                                          color: colorRowTable(index: i),
                                          child: Row(children: [
                                            CellTableWidget(
                                                content: item.cYName ?? '',
                                                width: 200),
                                            CellTableWidget(
                                                content: item.loaded.toString(),
                                                width: 100),
                                            CellTableWidget(
                                                content: item.empty.toString(),
                                                width: 100),
                                            CellTableWidget(
                                                content: item.total.toString(),
                                                width: 100),
                                          ]),
                                        );
                                      })),
                          ],
                        ),
                      ),
                      _titleTable(
                        title: '${state.siteTrailerList.length} ${'5125'.tr()}',
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            TableDataWidget(
                                listTableRowHeader: _headerTable(),
                                listTableRowContent: (state.siteTrailerList ==
                                            [] ||
                                        state.siteTrailerList.isEmpty)
                                    ? [
                                        const CellTableNoDataWidget(
                                            width: 1300),
                                      ]
                                    : List.generate(
                                        state.siteTrailerList.length, (i) {
                                        final item = state.siteTrailerList[i];
                                        return ColoredBox(
                                          color: colorRowTable(index: i),
                                          child: Row(children: [
                                            CellTableWidget(
                                                content: (i + 1).toString(),
                                                width: 50),
                                            CellTableWidget(
                                                content:
                                                    item.trailerNumber ?? '',
                                                width: 100),
                                            CellTableWidget(
                                                content: item.cntrStatus ?? '',
                                                width: 150),
                                            CellTableWidget(
                                                content: item.cntrNo ?? '',
                                                width: 150),
                                            CellTableWidget(
                                                content: item.workingStatus !=
                                                        null
                                                    ? WorkingStatusTrailer.from(
                                                            item.workingStatus!)
                                                        .toString()
                                                        .tr()
                                                    : '',
                                                width: 150),
                                            CellTableWidget(
                                                content: item.tireStatus ?? '',
                                                width: 100),
                                            CellTableWidget(
                                                content: item.ledStatus ?? '',
                                                width: 100),
                                            CellTableWidget(
                                                content: FormatDateConstants
                                                    .convertHHmm(
                                                        item.createDate ?? ''),
                                                width: 100),
                                            CellTableWidget(
                                                content: item.remark ?? '',
                                                isAlignLeft: true,
                                                width: 300),
                                            _buildIconButton(
                                              trlId: item.tRLId ?? 0,
                                              enable: item.createUser ==
                                                      generalBloc
                                                          .generalUserInfo
                                                          ?.userId
                                                  ? true
                                                  : false,
                                            )
                                          ]),
                                        );
                                      })),
                          ],
                        ),
                      )
                    ]),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _titleTable({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: MediaQuery.sizeOf(context).height * 0.015,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '5586'.tr(), width: 50),
      HeaderTable2Widget(label: '4012'.tr(), width: 100),
      HeaderTable2Widget(label: '5126'.tr(), width: 150),
      HeaderTable2Widget(label: '3645'.tr(), width: 150),
      HeaderTable2Widget(label: '5569'.tr(), width: 150),
      HeaderTable2Widget(label: '5129'.tr(), width: 100),
      HeaderTable2Widget(label: '5130'.tr(), width: 100),
      HeaderTable2Widget(label: '4330'.tr(), width: 100),
      HeaderTable2Widget(label: '1276'.tr(), width: 300),
      HeaderTable2Widget(label: '24'.tr(), width: 100),
    ];
  }

  List<Widget> _headerTableSumary() {
    return [
      HeaderTable2Widget(label: '5124'.tr(), width: 200),
      HeaderTable2Widget(label: '5127'.tr(), width: 100),
      HeaderTable2Widget(label: '5128'.tr(), width: 100),
      HeaderTable2Widget(label: '1284'.tr(), width: 100),
    ];
  }

  Widget _buildIconButton({required int trlId, required bool enable}) {
    return Container(
      width: 100,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: Colors.black38,
      ))),
      child: IconButton(
          icon: Icon(Icons.cancel_outlined,
              color: enable ? colors.textRed : colors.textGrey),
          onPressed: enable
              ? () {
                  _showDialogConfirm(context, trlId: trlId);
                }
              : null),
    );
  }

  _showDialogConfirm(BuildContext buildContext, {required int trlId}) {
    AwesomeDialog(
        padding: const EdgeInsets.all(8),
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        dismissOnTouchOutside: false,
        btnOkText: '24'.tr(),
        btnCancelText: "26".tr(),
        autoDismiss: false,
        onDismissCallback: (type) {},
        body: Column(
          children: [
            Text(
              "24".tr(),
              style: styleTextTitle,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('5578'.tr()),
            ),
          ],
        ),
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          BlocProvider.of<SiteTrailerCheckDetailBloc>(context).add(
              SiteTrailerDelete(
                  tRLId: trlId,
                  subsidiaryId: generalBloc.generalUserInfo?.subsidiaryId ?? '',
                  updateUser: generalBloc.generalUserInfo?.userId ?? ''));
          Navigator.of(context).pop();
        }).show();
  }
}
