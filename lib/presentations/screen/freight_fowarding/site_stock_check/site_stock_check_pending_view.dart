import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_stock/site_stock_check_pending/site_stock_check_pending_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_trailer/trailer_pending_reponse.dart';
import 'package:igls_new/data/services/navigator/navigator.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/enum/range_date_search.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/shared/utils/file_utils.dart';
import '../../../widgets/admin_component/cell_table.dart';
import '../../../widgets/admin_component/header_table.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/cell_table_no_data.dart';
import '../../../widgets/table_widget/table_data.dart';

class SiteStockCheckPendingView extends StatefulWidget {
  const SiteStockCheckPendingView({super.key});
  @override
  State<SiteStockCheckPendingView> createState() =>
      _SiteStockCheckPendingViewState();
}

class _SiteStockCheckPendingViewState extends State<SiteStockCheckPendingView> {
  late GeneralBloc generalBloc;
  late SiteStockCheckPendingBloc _bloc;
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(
          CySiteResponse(cyCode: '', cyName: '5059'.tr()));

  final ValueNotifier<int> _rangeDateNotifier = ValueNotifier<int>(1);

  int? selectedRangeDate;
  CySiteResponse? cySelected;

  List<CySiteResponse> cyList = [];

  BehaviorSubject<List<TrailerPendingRes>> pendingList =
      BehaviorSubject<List<TrailerPendingRes>>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteStockCheckPendingBloc>(context);
    _bloc.add(SiteStockCheckPendingViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title: Text('5444'.tr())),
        body:
            BlocConsumer<SiteStockCheckPendingBloc, SiteStockCheckPendingState>(
                listener: (context, state) {
          if (state is SiteStockCheckPendingFailure) {
            CustomDialog().error(context, err: state.message);
          }
          if (state is GetSiteStockCheckPendingSuccess) {
            pendingList.add(state.pendingList);
          }
          if (state is SiteStockCheckPendingSuccess) {
            pendingList.add(state.pendingList);

            cyList = state.cySiteList;

            _cyNotifier.value = state.cySiteList[0];
            cySelected = state.cySiteList[0];

            _rangeDateNotifier.value = RangeDateSearch.today.code;
            selectedRangeDate = RangeDateSearch.today.code;
          }
        }, builder: (context, state) {
          if (state is SiteStockCheckPendingLoading) {
            return const ItemLoading();
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDate(),
                _buildSearch(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: MediaQuery.sizeOf(context).height * 0.015,
                  ),
                  child: Text(
                    '5444'
                        .tr() /* '${state.lstTrailerPendingFilter.length} ${'5444'.tr()}' */,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                StreamBuilder(
                  stream: pendingList.stream,
                  builder: (context, snapshot) {
                    return TableDataWidget(
                        listTableRowHeader: _headerTable(),
                        listTableRowContent: (!snapshot.hasData ||
                                snapshot.data == [])
                            ? [const CellTableNoDataWidget(width: 820)]
                            : List.generate(snapshot.data!.length, (i) {
                                final item = snapshot.data![i];
                                return ColoredBox(
                                  color: colorRowTable(index: i),
                                  child: Row(children: [
                                    CellTableWidget(
                                        content: (i + 1).toString(), width: 50),
                                    _buildTrailerNo(
                                        trailerNo: item.trailerNumber ?? ''),
                                    CellTableWidget(
                                        content: item.lastCheckDate != null &&
                                                item.lastCheckDate != ''
                                            ? FileUtils
                                                .convertDateForHistoryDetailItem(
                                                    item.lastCheckDate ?? '')
                                            : '',
                                        width: 150),
                                    CellTableWidget(
                                        content: item.lastCYName ?? '',
                                        width: 200),
                                    CellTableWidget(
                                        content: item.lastRemark ?? '',
                                        isAlignLeft: true,
                                        width: 300),
                                  ]),
                                );
                              }));
                  },
                )
              ]);
        }));
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
    _bloc.add(SiteStockCheckPendingSearch(
        generalBloc: generalBloc,
        cySiteCode: _cyNotifier.value.cyCode ?? '',
        dcCode: generalBloc.generalUserInfo?.defaultCenter ?? '',
        rangeDate: _rangeDateNotifier.value));
  }

  Widget _buildDate() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
        horizontal: MediaQuery.sizeOf(context).height * 0.015,
      ),
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

  // Widget _buildCY() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         horizontal: MediaQuery.sizeOf(context).height * 0.015),
  //     child: ValueListenableBuilder(
  //       valueListenable: _cyNotifier,
  //       builder: (context, value, child) =>
  //           DropDownButtonFormField2CYSiteWidget(
  //         onChanged: (value) {
  //           value as CySiteResponse;
  //           _cyNotifier.value = value;
  //           cySelected = value;
  //           /* _bloc
  //                               .add(SiteTrailerPendingFilterByCY(
  //                                   cyName: value.cyName ?? '')); */
  //         },
  //         value: cySelected,
  //         hintText: '5083',
  //         label: '5124',
  //         list: cyList,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTrailerNo({
    required String trailerNo,
  }) {
    return Container(
      width: 120,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: colors.defaultColor,
      ))),
      padding: const EdgeInsets.all(8),
      child: TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(5),
              shadowColor: MaterialStateProperty.all(colors.defaultColor),
              backgroundColor: MaterialStateProperty.all(colors.defaultColor)),
          child: Text(
            trailerNo,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, trailerNo);
          }),
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

  List<Widget> _headerTable() {
    return [
      const HeaderTable2Widget(label: '5586', width: 50),
      const HeaderTable2Widget(label: '4012', width: 120),
      const HeaderTable2Widget(label: '5445', width: 150),
      const HeaderTable2Widget(label: '5446', width: 200),
      const HeaderTable2Widget(label: '1276', width: 300),
    ];
  }
}
