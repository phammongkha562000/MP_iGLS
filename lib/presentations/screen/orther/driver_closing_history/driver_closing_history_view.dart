import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/other/driver_closing_history/driver_closing_history_bloc.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_response.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/table_widget/cell_table_no_data.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/admin_component/header_table.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/cell_table.dart';
import '../../../widgets/table_widget/table_data.dart';

class DriverClosingHistoryView extends StatefulWidget {
  const DriverClosingHistoryView({super.key});

  @override
  State<DriverClosingHistoryView> createState() =>
      _DriverClosingHistoryViewState();
}

class _DriverClosingHistoryViewState extends State<DriverClosingHistoryView> {
  final _navigationService = getIt<NavigationService>();
  final _isSearchNotifer = ValueNotifier<bool>(false);
  final _tripNoController = TextEditingController();
  final _orderNoController = TextEditingController();

  ValueNotifier<ContactLocal> _customerNotifer = ValueNotifier<ContactLocal>(
      ContactLocal(contactCode: '', contactName: ''));
  ContactLocal? customerSelected;
  late GeneralBloc generalBloc;
  late DriverClosingHistoryBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<DriverClosingHistoryBloc>(context);
    _bloc.add(DriverClosingHistoryViewLoaded(
        date: DateTime.now(), generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        title: Text('5483'.tr()),
        actions: [
          IconButton(
              onPressed: () {
                _isSearchNotifer.value = !_isSearchNotifer.value;
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: BlocListener<DriverClosingHistoryBloc, DriverClosingHistoryState>(
        listener: (context, state) {
          if (state is DriverClosingHistoryFailure) {
            _clearText();

            if (state.errorCode == constants.errorNullEquipDriverId) {
              CustomDialog().error(context,
                  err: state.message,
                  btnOkOnPress: () => Navigator.of(context).pop());
              return;
            }

            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<DriverClosingHistoryBloc, DriverClosingHistoryState>(
          builder: (context, state) {
            if (state is DriverClosingHistorySuccess) {
              return PickDatePreviousNextWidget(
                quantityText: '${state.historyList.length}',
                onTapPrevious: () {
                  _bloc.add(DriverClosingHistoryPreviousDateLoaded(
                      generalBloc: generalBloc,
                      contactCode: customerSelected?.contactCode ?? ''));
                },
                onTapPick: (selectDate) {
                  _bloc.add(DriverClosingHistoryPickDate(
                      date: selectDate,
                      generalBloc: generalBloc,
                      contact: customerSelected));
                },
                onTapNext: () {
                  _bloc.add(DriverClosingHistoryNextDateLoaded(
                      generalBloc: generalBloc,
                      contactCode: customerSelected?.contactCode ?? ''));
                },
                stateDate: state.date,
                child: Expanded(
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _isSearchNotifer,
                        builder: (context, value, child) =>
                            _isSearchNotifer.value
                                ? _buildSearch(localList: state.localList ?? [])
                                : const SizedBox(),
                      ),
                      _buildTable(list: state.historyList)
                    ],
                  ),
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildSearch({List<ContactLocal>? localList}) => CardCustom(
        elevation: 5,
        radius: 32,
        child: Column(
          children: [
            _buildPadding(
              text: '2468',
              controller: _tripNoController,
            ),
            _buildPadding(
              text: '122',
              controller: _orderNoController,
            ),
            _buildPadding(
              text: '1272',
              widget: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: ValueListenableBuilder(
                      valueListenable: _customerNotifer,
                      builder: (context, value, child) =>
                          DropDownButtonFormField2ContactLocalWidget(
                        bgColor: Colors.white,
                        onChanged: (value) {
                          _customerNotifer.value = value as ContactLocal;
                          customerSelected = value;
                        },
                        value: customerSelected,
                        hintText: '5082',
                        label: Text('1272'.tr(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        list: localList ?? [],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          customerSelected = null;
                          _customerNotifer.value =
                              ContactLocal(contactCode: '', contactName: '');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: colors.textRed,
                          size: 36,
                        )),
                  )
                ],
              ),
            ),
            const HeightSpacer(height: 0.01),
            ElevatedButtonWidget(
              isPadding: false,
              text: '36',
              onPressed: () {
                _bloc.add(DriverClosingHistoryPickDate(
                    generalBloc: generalBloc,
                    contact: customerSelected,
                    orderNo: _orderNoController.text,
                    tripNo: _tripNoController.text));
              },
            )
          ],
        ),
      );
  Widget _buildTable({required List<DriverClosingHistoryResponse> list}) {
    return TableDataWidget(
        listTableRowHeader: _headerTable(),
        listTableRowContent: list.isEmpty
            ? [const CellTableNoDataWidget(width: 830)]
            : List.generate(
                list.length,
                (index) {
                  final item = list[index];
                  return ColoredBox(
                    color: colorRowTable(index: index),
                    child: InkWell(
                      onTap: () async {
                        final result = await _navigationService
                            .navigateAndDisplaySelection(
                                routes.driverClosingHistoryDetailRoute,
                                args: {key_params.dDCId: item.dDCId});
                        if (result != null) {
                          _bloc.add(DriverClosingHistoryViewLoaded(
                              date: DateTime.now(), generalBloc: generalBloc));
                        }
                      },
                      child: Row(
                        children: [
                          CellTableWidget(
                              width: 50, content: (index + 1).toString()),
                          CellTableWidget(
                              width: 200, content: item.tripNo ?? ''),
                          CellTableWidget(
                              width: 200, content: item.tripDate ?? ''),
                          CellTableWidget(
                              width: 120, content: item.contactCode ?? ''),
                          CellTableWidget(
                              width: 150,
                              isAlignLeft: true,
                              content: item.acualTotal != null
                                  ? item.acualTotal.toString()
                                  : ''),
                          SizedBox(
                            // decoration: BoxDecoration(
                            //   border: const Border(
                            //       right: BorderSide(
                            //     color: colors.defaultColor,
                            //   )),
                            // ),
                            width: 110,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: item.closingStatus == 'POST'
                                      ? colors.textGreen
                                      : colors.textGrey),
                              child: Text(
                                item.closingStatusDesc ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colors.textWhite),
                              ),
                            ),
                          )
                          // CellTableWidget(
                          //     width: 300,
                          //     content: list[index].driverTripTypeDesc ?? '')
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '5586', width: 50),
      HeaderTable2Widget(label: '4866', width: 200),
      HeaderTable2Widget(label: '5586', width: 200),
      HeaderTable2Widget(label: '3597', width: 120),
      HeaderTable2Widget(label: '5485', width: 150),
      HeaderTable2Widget(label: '1279', width: 110),
    ];
  }

  Widget _buildPadding(
          {required String text,
          TextEditingController? controller,
          Widget? widget}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: controller != null
              ? TextFormField(
                  decoration: InputDecoration(
                      label: Text(text.tr()), hintText: '${text.tr()}...'),
                  controller: controller,
                )
              : widget!);
  /* Widget _itemHistory({required DriverClosingHistoryResponse item}) => InkWell(
        onTap: () => _navigationService.pushNamed(
            routes.driverClosingHistoryDetailRoute,
            args: {key_params.dDCId: item.dDCId}),
        child: CardCustom(
          padding1: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.015,
              vertical: MediaQuery.sizeOf(context).width * 0.01),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.contactCode!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: colors.textGreen),
                ),
                (item.closingStatus != null && item.closingStatus != '')
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: item.closingStatus == 'POST'
                                ? colors.textGreen
                                : colors.textGrey),
                        child: Text(
                          item.closingStatus ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textWhite),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.tripNo!.startsWith("S")
                        ? TripType.simpleTrip.toString()
                        : TripType.normalTrip.toString(),
                  ),
                  Text(
                    item.tripNo ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _buildListTile(
                text: item.driverTripTypeDesc ?? '',
                iconData: Icons.description),
            _buildListTile(
                text: item.closingStatusDesc ?? '', iconData: Icons.info),
            _buildListTile(
              text: FormatDateConstants.convertdd_MM_yyyy_HH_mm(
                  item.driverPostDate ?? ''),
              iconData: Icons.timer,
            ),
          ]),
        ),
      ); */
  /*  Widget _buildListTile({required String text, required IconData iconData}) =>
      ListTile(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: Text(text),
        leading: Icon(
          iconData,
          color: colors.defaultColor,
        ),
      ); */
  void _clearText() {
    _customerNotifer = ValueNotifier<ContactLocal>(
        ContactLocal(contactCode: '', contactName: ''));

    customerSelected = null;
    _orderNoController.clear();
    _tripNoController.clear();
  }
}
