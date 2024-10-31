import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/delivery_status/delivery_status_bloc.dart';
import 'package:igls_new/data/models/local_distribution/delivery_status/delivery_status.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../presentations.dart';
import '../../../widgets/table_widget/table_widget.dart';

class DeliveryStatusView extends StatefulWidget {
  const DeliveryStatusView({super.key});

  @override
  State<DeliveryStatusView> createState() => _DeliveryStatusViewState();
}

class _DeliveryStatusViewState extends State<DeliveryStatusView> {
  final _localNotifier = ValueNotifier<String>('');
  final ValueNotifier<ContactLocal> _customerNotifer =
      ValueNotifier<ContactLocal>(
          ContactLocal(contactCode: '', contactName: '5059'.tr()));
  ContactLocal? customerSelected;
  final _horizontalScrollController1 = ScrollController();
  List<GetTeTruckDashboard2> detailList = [];
  List<GetTeTruckDashboard1> summaryList = [];
  late GeneralBloc generalBloc;
  late DeliveryStatusBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<DeliveryStatusBloc>(context);
    _bloc.add(DeliveryStatusViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
          title: Text('4892'.tr()),
        ),
        body: BlocListener<DeliveryStatusBloc, DeliveryStatusState>(
          listener: (context, state) {
            if (state is DeliveryStatusFailure) {
              if (state.errorCode == constants.errorNoConnect) {
                CustomDialog().error(
                  context,
                  err: state.message,
                  btnMessage: '5038'.tr(),
                  btnOkOnPress: () => _bloc
                      .add(DeliveryStatusViewLoaded(generalBloc: generalBloc)),
                );
                return;
              }

              CustomDialog().error(context, err: state.message);
            }
          },
          child: BlocBuilder<DeliveryStatusBloc, DeliveryStatusState>(
            builder: (context, state) {
              if (state is DeliveryStatusSuccess) {
                detailList = state.deliveryStatus.getTeTruckDashboard2 ?? [];
                summaryList = state.deliveryStatus.getTeTruckDashboard1 ?? [];
                _localNotifier.value = state.contactCode;
                if (state.contactList.isNotEmpty) {
                  final contact = state.contactList
                      .where(
                          (element) => element.contactCode == state.contactCode)
                      .toList();

                  if (contact.isNotEmpty) {
                    _customerNotifer.value = contact.first;
                    customerSelected = _customerNotifer.value;
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: ValueListenableBuilder(
                                valueListenable: _localNotifier,
                                builder: (context, value, child) =>
                                    DropDownButtonFormField2ContactLocalWidget(
                                  isGrey: true,
                                  onChanged: (value) {
                                    _customerNotifer.value =
                                        value as ContactLocal;
                                    customerSelected = value;
                                    _bloc.add(DeliveryStatusChangeContact(
                                        generalBloc: generalBloc,
                                        contactCode: value.contactCode!));
                                  },
                                  value: customerSelected,
                                  hintText: '5082',
                                  label: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: '1272'.tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(
                                        text: ' *',
                                        style:
                                            TextStyle(color: colors.textRed)),
                                  ])),
                                  list: state.contactList,
                                ),
                              ),
                            ),
                            const WidthSpacer(width: 0.01),
                            Expanded(
                              flex: 2,
                              child: ElevatedButtonWidget(
                                isPadding: false,
                                text: '5158'.tr(),
                                onPressed: () {
                                  _bloc.add(DeliveryStatusChangeContact(
                                      generalBloc: generalBloc));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    _buildTitle(iconData: Icons.dashboard, text: '145'),
                    _buildTableSummary(
                        list: state.deliveryStatus.getTeTruckDashboard1 ?? []),
                    _buildTitle(iconData: Icons.equalizer, text: '5051'),
                    _buildTableDetail(
                        detailList:
                            state.deliveryStatus.getTeTruckDashboard2 ?? []),
                  ],
                );
              }
              return const ItemLoading();
            },
          ),
        ));
  }

  Widget _buildTableDetail({required List<GetTeTruckDashboard2> detailList}) {
    return TableDataWidget(
        color: colors.defaultColor,
        listTableRowHeader: const [
          HeaderTable2Widget(label: '5586', width: 50),
          HeaderTable2Widget(label: '3597', width: 120),
          HeaderTable2Widget(label: '5586', width: 80),
          HeaderTable2Widget(label: '1298', width: 100),
          HeaderTable2Widget(label: '3507', width: 160),
          HeaderTable2Widget(label: '2416', width: 150),
          HeaderTable2Widget(label: '141', width: 250),
          HeaderTable2Widget(label: '5152', width: 100),
          HeaderTable2Widget(label: '5153', width: 100),
          HeaderTable2Widget(label: '1279', width: 150),
          HeaderTable2Widget(label: '5159', width: 200),
          HeaderTable2Widget(label: '1276', width: 200),
        ],
        listTableRowContent: detailList.isNotEmpty
            ? List.generate(detailList.length, (index) {
                return ColoredBox(
                    color: colorRowTable(index: index),
                    child: Row(
                      children: [
                        CellTableWidget(
                          width: 50,
                          content: (index + 1).toString(),
                        ),
                        CellTableWidget(
                          content: detailList[index].contactCode ?? '',
                          width: 120,
                        ),
                        CellTableWidget(
                          width: 80,
                          content: FileUtils.convertddMMItem(
                              detailList[index].etp ?? ''),
                        ),
                        CellTableWidget(
                          content: detailList[index].equipmentCode ?? '',
                          width: 100,
                        ),
                        CellTableWidget(
                          width: 160,
                          content: detailList[index].staffName ?? '',
                        ),
                        CellTableWidget(
                          content: detailList[index].mobileNo ?? '',
                          width: 150,
                        ),
                        CellTableWidget(
                          width: 250,
                          isAlignLeft: true,
                          content: detailList[index].shipTo ?? '',
                        ),
                        CellTableWidget(
                          content: detailList[index].started ?? '',
                          width: 100,
                        ),
                        CellTableWidget(
                          content: detailList[index].done ?? '',
                          width: 100,
                        ),
                        CellTableWidget(
                          content: detailList[index].updateStatus ?? '',
                          width: 150,
                        ),
                        CellTableWidget(
                          width: 200,
                          content: detailList[index].porterName ?? '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: detailList[index].tripMemo ?? '',
                        ),
                      ],
                    ));
              })
            : [
                const CellTableNoDataWidget(
                  width: 1660,
                ),
              ]);
  }

  Widget _buildTableSummary({required List<GetTeTruckDashboard1> list}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController1,
        child: Column(
          children: [
            Table(
                border: list == [] || list.isEmpty
                    ?   TableBorder.symmetric(
                        outside: const BorderSide(
                          color: colors.defaultColor,
                        ),
                      )
                    : TableBorder.all(
                        color: colors.defaultColor.withOpacity(0.5),
                      ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  TableRow(
                      decoration: const BoxDecoration(
                        color: colors.defaultColor,
                      ),
                      children: [
                        const HeaderTableWidget(
                          headerText: '5586',
                        ),
                        const HeaderTableWidget(headerText: '3597'),
                        const HeaderTableWidget(headerText: '5089'),
                        const HeaderTableWidget(headerText: '5153'),
                        const HeaderTableWidget(headerText: '245'),
                        HeaderTableWidget(headerText: '${'3539'.tr()} (%)'),
                      ]),
                  ...list == [] || list.isEmpty
                      ? List.generate(1, (i) {
                          return TableRow(
                              decoration: BoxDecoration(
                                color: colorRowTable(index: i),
                              ),
                              children: [
                                const SizedBox(),
                                const SizedBox(),
                                const SizedBox(),
                                _buildText(
                                    text: "5058".tr().toUpperCase(),
                                    isNoData: true),
                                const SizedBox(),
                                const SizedBox(),
                              ]);
                        })
                      : List.generate(
                          list.length,
                          (i) {
                            final item = list[i];

                            return TableRow(
                              children: [
                                _buildText(text: (i + 1).toString()),
                                _buildText(text: item.contact ?? ''),
                                _buildText(text: item.trips.toString()),
                                _buildText(text: item.done.toString()),
                                _buildText(text: item.progress.toString()),
                                _buildText(text: item.rate.toString()),
                              ],
                            );
                          },
                        ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({required IconData iconData, required String text}) =>
      Padding(
        padding: EdgeInsets.only(bottom: 8.h, top: 16.h, left: 16.w),
        child: Row(
          children: [
            Icon(iconData),
            const WidthSpacer(width: 0.01),
            Text(
              text.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _buildText(
      {required String text, bool? isShipTo, bool? isNoData, bool? isStatus}) {
    return SizedBox(
      width: text.length > 50 ? 200 : null,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          child: Text(text,
              maxLines: 2,
              textAlign: isShipTo ?? false ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                color: isStatus ?? false
                    ? (text == "Wrong" ? colors.textRed : Colors.black)
                    : isNoData ?? false
                        ? colors.btnGreyDisable
                        : Colors.black,
              ))),
    );
  }
}
