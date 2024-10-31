import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/admin/equipments/equipments/equipments_bloc.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_type_response.dart';
import 'package:igls_new/data/models/equipments_admin/equipments_response.dart';
import 'package:igls_new/presentations/widgets/admin_component/expansion_tile_custom.dart';
import 'package:igls_new/presentations/widgets/admin_component/quantity_quick_search.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_dc.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_equip_type.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_std_code.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/table_widget/table_widget.dart';

class EquipmentsView extends StatefulWidget {
  const EquipmentsView({super.key});

  @override
  State<EquipmentsView> createState() => _EquipmentsViewState();
}

class _EquipmentsViewState extends State<EquipmentsView> {
  final TextEditingController _equipmentCodeController =
      TextEditingController();
  final TextEditingController _equipmentDescController =
      TextEditingController();
  final TextEditingController _assetCodeController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _quickSearchController = TextEditingController();

  final ValueNotifier<StdCode> _ownershipNotifier =
      ValueNotifier<StdCode>(StdCode());
  StdCode? ownershipSelected;
  final ValueNotifier<StdCode> _equipmentGroupNotifier =
      ValueNotifier<StdCode>(StdCode());
  StdCode? equipmentGroupSelected;
  final ValueNotifier<EquipmentTypeResponse> _equipmentTypeNotifier =
      ValueNotifier<EquipmentTypeResponse>(EquipmentTypeResponse());
  EquipmentTypeResponse? equipmentTypeSelected;

  final ValueNotifier<DcLocal> _dcNotifier = ValueNotifier<DcLocal>(DcLocal());
  DcLocal? dcSelected;

  final _navigationService = getIt<NavigationService>();

  late EquipmentsBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<EquipmentsBloc>(context);
    _bloc.add(EquipmentsViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(title: Text('1298'.tr())),
        body: BlocConsumer<EquipmentsBloc, EquipmentsState>(
            listener: (context, state) {
          if (state is EquipmentsFailure) {
            CustomDialog().error(context, err: state.message);
          }
        }, builder: (context, state) {
          if (state is EquipmentsSuccess) {
            _getData(state: state);
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpansion(
                      dcList: state.dcList,
                      equipmentGroup: state.equipmentGroup,
                      equipmentTypeList: state.equipmentTypeList,
                      ownershipList: state.ownershipList),
                  QuantityQuickSearchWidget(
                      controller: _quickSearchController,
                      quantity: '${state.equipmentsListSearch.length}',
                      onChanged: (value) {
                        _bloc.add(EquipmentsQuickSearch(textSearch: value));
                      }),
                  _buildTable(equipmentsList: state.equipmentsListSearch)
                ]);
          }
          return const ItemLoading();
        }));
  }

  Widget _buildExpansion({
    required List<DcLocal> dcList,
    required List<StdCode> ownershipList,
    required List<StdCode> equipmentGroup,
    required List<EquipmentTypeResponse> equipmentTypeList,
  }) {
    return ExpansionTileWidget(initiallyExpanded: true, listWidget: [
      Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(children: [
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _ownershipNotifier,
                    builder: (context, value, child) =>
                        DropDownButtonFormField2StdCodeWidget(
                            isRequired: false,
                            onChanged: (value) {
                              _ownershipNotifier.value = value as StdCode;
                              ownershipSelected = value;
                            },
                            value: ownershipSelected,
                            label: '106',
                            hintText: '106',
                            list: ownershipList))),
            _buildSizedBox(),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _equipmentTypeNotifier,
                    builder: (context, value, child) =>
                        DropDownButtonFormField2EquipTypeWidget(
                            isRequired: false,
                            onChanged: (value) {
                              _equipmentTypeNotifier.value =
                                  value as EquipmentTypeResponse;
                              equipmentTypeSelected = value;
                            },
                            value: equipmentTypeSelected,
                            label: '1291',
                            hintText: '1291',
                            list: equipmentTypeList)))
          ])),
      Row(children: [
        Expanded(
            child: _buildTextField(
                controller: _equipmentCodeController, label: '1289')),
        Expanded(
            child: _buildTextField(
                controller: _equipmentDescController, label: '1290'))
      ]),
      Row(children: [
        Expanded(
            child: _buildTextField(
                controller: _assetCodeController, label: '1292')),
        Expanded(
            child: _buildTextField(
                controller: _serialNumberController, label: '5586'))
      ]),
      Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(children: [
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _equipmentGroupNotifier,
                    builder: (context, value, child) =>
                        DropDownButtonFormField2StdCodeWidget(
                            isRequired: false,
                            onChanged: (value) {
                              _equipmentGroupNotifier.value = value as StdCode;
                              equipmentGroupSelected = value;
                            },
                            value: equipmentGroupSelected,
                            label: '3861',
                            hintText: '3861',
                            list: equipmentGroup))),
            _buildSizedBox(),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _dcNotifier,
                    builder: (context, value, child) =>
                        DropDownButtonFormField2DCWidget(
                            isRequired: false,
                            onChanged: (value) {
                              _dcNotifier.value = value as DcLocal;
                              dcSelected = value;
                            },
                            value: dcSelected,
                            label: '90',
                            hintText: '90',
                            list: dcList)))
          ])),
      const SizedBox(height: 8),
      ElevatedButtonWidget(text: '36', onPressed: () => _onSearch())
    ]);
  }

  void _onSearch() {
    _bloc.add(EquipmentsSearch(
        generalBloc: generalBloc,
        dcSearch: _dcNotifier.value,
        ownershipSearch: _ownershipNotifier.value,
        equipmentGroupSearch: _equipmentGroupNotifier.value,
        equipmentTypeSearch: _equipmentTypeNotifier.value,
        assetCode: _assetCodeController.text,
        equipmentCode: _equipmentCodeController.text,
        equipmentDesc: _equipmentDescController.text,
        serialNumber: _serialNumberController.text));
  }

  void _getData({required EquipmentsSuccess state}) {
    _ownershipNotifier.value = state.ownershipSearch;
    ownershipSelected = state.ownershipSearch;
    _equipmentGroupNotifier.value = state.equipmentGroupSearch;
    equipmentGroupSelected = state.equipmentGroupSearch;
    _equipmentTypeNotifier.value = state.equipmentTypeSearch;
    equipmentTypeSelected = state.equipmentTypeSearch;
    _dcNotifier.value = state.dcSearch;
    dcSelected = state.dcSearch;
    _assetCodeController.text = state.assetCode;
    _equipmentCodeController.text = state.equipmentCode;
    _equipmentDescController.text = state.equipmentDesc;
    _serialNumberController.text = state.serialNumber;
  }

  Widget _buildTable({required List<EquipmentsResponse> equipmentsList}) {
    return TableDataWidget(
        listTableRowHeader: const [
          HeaderTable2Widget(label: '5586', width: 50),
          HeaderTable2Widget(label: '1289', width: 120),
          HeaderTable2Widget(label: '5120', width: 140),
          HeaderTable2Widget(label: '3507', width: 150),
          HeaderTable2Widget(label: '1291', width: 80),
          HeaderTable2Widget(label: '90', width: 120),
          HeaderTable2Widget(label: '3861', width: 100),
          HeaderTable2Widget(label: '1276', width: 200),
          HeaderTable2Widget(label: '1308', width: 100),
          HeaderTable2Widget(label: '5121', width: 100),
          HeaderTable2Widget(label: '5122', width: 200)
        ],
        listTableRowContent: equipmentsList == [] || equipmentsList.isEmpty
            ? [const CellTableNoDataWidget(width: 1360)]
            : List.generate(equipmentsList.length, (index) {
                return ColoredBox(
                    color: colorRowTable(index: index),
                    child: InkWell(
                        onTap: () async {
                          _onDetail(
                              equipmentCode: equipmentsList[index]
                                  .equipmentCode
                                  .toString()
                                  .trim());
                        },
                        child: Row(children: [
                          CellTableWidget(
                              width: 50, content: (index + 1).toString()),
                          CellTableWidget(
                              width: 120,
                              content:
                                  equipmentsList[index].equipmentCode ?? ''),
                          CellTableWidget(
                              width: 140,
                              content:
                                  equipmentsList[index].defaultStaffId ?? ''),
                          CellTableWidget(
                              width: 150,
                              content: equipmentsList[index].staffName ?? '',
                              isAlignLeft: true),
                          CellTableWidget(
                              width: 80,
                              content: equipmentsList[index].equipTypeNo ?? ''),
                          CellTableWidget(
                              width: 120,
                              content: equipmentsList[index].dcCode ?? ''),
                          CellTableWidget(
                              width: 100,
                              content:
                                  equipmentsList[index].equipmentGroup ?? ''),
                          CellTableWidget(
                              width: 200,
                              content: equipmentsList[index].remarks ?? '',
                              isAlignLeft: true),
                          CellTableWidget(
                            width: 100,
                            content: equipmentsList[index].brand ?? '',
                          ),
                          CellTableWidget(
                              width: 100,
                              content: equipmentsList[index].gpsVendor ?? '',
                              isAlignLeft: true),
                          CellTableWidget(
                              width: 200,
                              content: equipmentsList[index].equipStatus ?? '',
                              isAlignLeft: true),
                        ])));
              }));
  }

  Future<void> _onDetail({required String equipmentCode}) async {
    final result = await _navigationService.navigateAndDisplaySelection(
        routes.equipmentDetailRoute,
        args: {key_params.equipmentCode: equipmentCode});
    if (result == true) {
      _bloc.add(EquipmentsViewLoaded(generalBloc: generalBloc));
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            label: Text(
              label.tr(),
            ),
            hintText: label.tr()),
      ),
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(
      width: 16.w,
    );
  }
}
