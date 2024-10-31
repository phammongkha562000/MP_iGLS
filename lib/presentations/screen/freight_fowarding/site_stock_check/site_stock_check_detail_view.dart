import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_stock/site_stock_check_detail/site_stock_check_detail_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/site_stock_check_summary_response.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/enum/range_date_search.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/widgets/table_widget/cell_table_view.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class SiteStockCheckDetailView extends StatefulWidget {
  final String cyCode;
  const SiteStockCheckDetailView({
    super.key,
    required this.cyCode,
  });
  @override
  State<SiteStockCheckDetailView> createState() =>
      _SiteStockCheckDetailViewState();
}

class _SiteStockCheckDetailViewState extends State<SiteStockCheckDetailView> {
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(CySiteResponse(cyCode: '', cyName: ''));
  final ValueNotifier<int> _rangeDateNotifier = ValueNotifier<int>(1);

  int? selectedRangeDate;
  CySiteResponse? cySelected;
  List<DcLocal> dcList = [];
  List<CySiteResponse> cyList = [];

  BehaviorSubject<List<SiteStockCheckResponse>> siteStockCheckList =
      BehaviorSubject<List<SiteStockCheckResponse>>();
  BehaviorSubject<List<SiteStockSummaryResponse>> siteStockSummaryList =
      BehaviorSubject<List<SiteStockSummaryResponse>>();

  late SiteStockCheckDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteStockCheckDetailBloc>(context);
    _bloc.add(SiteStockCheckDetailViewLoaded(
      generalBloc: generalBloc,
      cyCode: widget.cyCode,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title: Text('5577'.tr())),
        body: BlocConsumer<SiteStockCheckDetailBloc, SiteStockCheckDetailState>(
            listener: (context, state) {
          if (state is SiteStockCheckDetailFailure) {
            CustomDialog().error(context, err: state.message);
          }
          if (state is SiteStockCheckDeleteSuccess) {
            _bloc.add(SiteStockCheckDetailSearch(
                rangeDate: selectedRangeDate ?? 1,
                dcCode: generalBloc.generalUserInfo?.defaultCenter ?? '',
                cySiteCode: cySelected == null ? '' : cySelected!.cyCode ?? '',
                generalBloc: generalBloc));
          }
          if (state is SiteStockCheckDetailSuccess) {
            siteStockCheckList.add(state.siteStockCheckList);
            siteStockSummaryList.add(state.summaryList);

            cyList = state.cySiteList;
            dcList = state.dcList;

            _cyNotifier.value = widget.cyCode != ''
                ? state.cySiteList
                    .where((element) => element.cyCode == widget.cyCode)
                    .single
                : state.cySiteList[0];
            cySelected = widget.cyCode != ''
                ? state.cySiteList
                    .where((element) => element.cyCode == widget.cyCode)
                    .single
                : state.cySiteList[0];
            _rangeDateNotifier.value = RangeDateSearch.today.code;
            selectedRangeDate = RangeDateSearch.today.code;
          }
          if (state is GetSiteStockCheckDetailSuccess) {
            siteStockCheckList.add(state.siteStockCheckList);
            siteStockSummaryList.add(state.summaryList);
          }
        }, builder: (context, state) {
          if (state is SiteStockCheckDetailLoading) {
            return const ItemLoading();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCY(cyList: cyList),
                _buildDate(),
                _buildSearch(),
                _buildTableSummary(),
                _buildTableChecked(),
              ],
            ),
          );
        }));
  }

  Widget _buildTableSummary() {
    return StreamBuilder(
        stream: siteStockSummaryList.stream,
        builder: (context, snapshot) {
          return ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                '145'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                TableView(
                    headerChildren: _headerSummaryStr,
                    rowChildren: snapshot.hasData
                        ? List.generate(snapshot.data!.length, (i) {
                            final item = snapshot.data![i];

                            return TableRow(
                              decoration: BoxDecoration(
                                  color: i % 2 != 0
                                      ? colors.defaultColor.withOpacity(0.1)
                                      : Colors.white),
                              children: [
                                CellTableView(text: item.cyName ?? ''),
                                CellTableView(text: item.total.toString()),
                              ],
                            );
                          })
                        : [],
                    columnWidths: {
                      0: FixedColumnWidth(
                          (MediaQuery.sizeOf(context).width - 16.w) * 0.6),
                      1: FixedColumnWidth(
                          (MediaQuery.sizeOf(context).width - 16.w) * 0.4),
                    }),
                SizedBox(
                  height: 40.h,
                )
              ]);
        });
  }

  Widget _buildTableChecked() {
    return StreamBuilder(
        stream: siteStockCheckList.stream,
        builder: (context, snapshot) {
          return ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                '${snapshot.hasData ? snapshot.data!.length : 0} ${'5125'.tr()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                snapshot.hasData
                    ? TableView(
                        headerChildren: _headerStr,
                        rowChildren: List.generate(snapshot.data!.length, (i) {
                          final item = snapshot.data![i];

                          return TableRow(
                            decoration: BoxDecoration(
                                color: i % 2 != 0
                                    ? colors.defaultColor.withOpacity(0.1)
                                    : Colors.white),
                            children: [
                              CellTableView(text: (i + 1).toString()),
                              CellTableView(text: item.trailerNumber ?? ''),
                              CellTableView(
                                  text: FormatDateConstants.convertMMddyyyyHHmm(
                                      item.createDate ?? '')),
                              CellTableView(
                                text: item.remark ?? '',
                              ),
                              _buildIconButton(
                                trlId: item.trsId ?? 0,
                                enable: item.createUser ==
                                        generalBloc.generalUserInfo?.userId
                                    ? true
                                    : false,
                              )
                            ],
                          );
                        }),
                        columnWidths: snapshot.hasData &&
                                snapshot.data! != [] &&
                                snapshot.data!.isNotEmpty
                            ? {
                                0: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) *
                                        0.1),
                                1: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) *
                                        0.3),
                                2: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) *
                                        0.4),
                                3: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) *
                                        0.4),
                                4: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) *
                                        0.2),
                              }
                            : null,
                        tableColumnWidth: snapshot.hasData &&
                                snapshot.data! != [] &&
                                snapshot.data!.isNotEmpty
                            ? null
                            : FixedColumnWidth(
                                (MediaQuery.sizeOf(context).width - 16.w) /
                                    _headerStr.length),
                      )
                    : TableView(
                        headerChildren: _headerStr,
                        rowChildren: const [],
                        tableColumnWidth: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) /
                                _headerStr.length),
                      ),
                SizedBox(
                  height: 40.h,
                )
              ]);
        });
  }

  Widget _buildSearch() {
    return ElevatedButtonWidget(
      text: "36",
      onPressed: () {
        _onSearch();
      },
    );
  }

  void _onSearch() {
    //Todo
    _bloc.add(SiteStockCheckDetailSearch(
        generalBloc: generalBloc,
        cySiteCode: _cyNotifier.value.cyCode ?? '',
        dcCode: generalBloc.generalUserInfo?.defaultCenter ?? '',
        rangeDate: _rangeDateNotifier.value));
  }

  Widget _buildIconButton({required int trlId, required bool enable}) {
    return Container(
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

  final List<String> _headerStr = ['5586', '4012', '4330', '1276', '24'];
  final List<String> _headerSummaryStr = ['5124', '1284'];

  Widget _buildDate() {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.sizeOf(context).height * 0.015,
          bottom: MediaQuery.sizeOf(context).height * 0.03,
          left: MediaQuery.sizeOf(context).height * 0.015),
      child: DropdownButtonFormField2<int>(
        barrierColor: dropdown_custom.bgDrawerColor(),
        decoration: InputDecoration(
          label: Text('239'.tr()), //hardcode
        ),
        validator: (value) {
          if (value == null) {
            return '5067'.tr();
          }
          return null;
        },
        isExpanded: true,
        buttonStyleData: dropdown_custom.customButtonStyleData(),
        menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
        dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
        hint: Text("date".tr()),
        items: RangeDateSearch.values
            .map((item) => dropDownMenuItemDate(item.code))
            .toList(),
        selectedItemBuilder: (context) {
          return RangeDateSearch.values.map((e) {
            return Text(RangeDateSearch.from(e.code).toString().tr());
          }).toList();
        },
        value: selectedRangeDate,
        onChanged: (value) {
          setState(() {
            _rangeDateNotifier.value = value as int;
            selectedRangeDate = value;
          });
        },
      ),
    );
  }

  DropdownMenuItem<int> dropDownMenuItemDate(int item) {
    return DropdownMenuItem<int>(
        value: item,
        child: dropdown_custom
            .cardItemDropdown(assetIcon: assets.kCalendar, children: [
          Text(RangeDateSearch.from(item).toString().tr(),
              style: const TextStyle(
                color: colors.defaultColor,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  DropdownMenuItem<DcLocal> dropDownMenuItemDCLocal(DcLocal item) {
    return DropdownMenuItem<DcLocal>(
        value: item,
        child: dropdown_custom
            .cardItemDropdown(assetIcon: assets.locationStock, children: [
          Text(item.dcDesc ?? "",
              style: const TextStyle(
                color: colors.defaultColor,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget buildSelectedItemDCLocal(DcLocal e) {
    return Text(e.dcDesc ?? "");
  }

  Widget _buildCY({required List<CySiteResponse> cyList}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).height * 0.015,
          vertical: MediaQuery.sizeOf(context).height * 0.03),
      child: DropDownButtonFormField2CYSiteWidget(
        onChanged: (value) {
          setState(() {
            value as CySiteResponse;
            _cyNotifier.value = value;
            cySelected = value;
          });
        },
        value: cySelected,
        hintText: '5083',
        label: '5124',
        list: cyList,
      ),
    );
  }

  Widget buildTableNoData(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: colors.defaultColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: const Row(
              children: [
                Expanded(child: HeaderTableWidget(headerText: '5586')),
                Expanded(child: HeaderTableWidget(headerText: 'TrailerNo')),
                Expanded(child: HeaderTableWidget(headerText: 'CNTRNo')),
                Expanded(child: HeaderTableWidget(headerText: 'Tire')),
                Expanded(child: HeaderTableWidget(headerText: 'Led')),
                Expanded(child: HeaderTableWidget(headerText: 'Time')),
                Expanded(child: HeaderTableWidget(headerText: 'Memo')),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // color: ,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              border: Border.all(
                color: colors.defaultColor,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).width * 0.02),
              child: const EmptyWidget(),
            ),
          ),
        ],
      ),
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
          _bloc.add(SiteStockCheckDetailDelete(
              trsId: trlId,
              subsidiaryId: generalBloc.generalUserInfo?.subsidiaryId ?? '',
              updateUser: generalBloc.generalUserInfo?.userId ?? ''));
          Navigator.of(context).pop();
        }).show();
  }
}
