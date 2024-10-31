import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/admin/staffs/staffs/staffs_bloc.dart';
import 'package:igls_new/presentations/widgets/admin_component/expansion_tile_custom.dart';
import 'package:igls_new/presentations/widgets/admin_component/quantity_quick_search.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_dc.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_std_code.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import '../../../widgets/table_widget/table_widget.dart';

class StaffsView extends StatefulWidget {
  const StaffsView({
    super.key,
  });
  @override
  State<StaffsView> createState() => _StaffsViewState();
}

class _StaffsViewState extends State<StaffsView> {
  final _navigationService = getIt<NavigationService>();

  final ValueNotifier<StdCode> _roleTypeNotifier =
      ValueNotifier<StdCode>(StdCode());
  StdCode? roleTypeSelected;

  final ValueNotifier<DcLocal> _dcNotifier = ValueNotifier<DcLocal>(DcLocal());

  DcLocal? dcSelected;

  final TextEditingController _staffIDController = TextEditingController();
  final TextEditingController _staffNameController = TextEditingController();
  final TextEditingController _quickSearchController = TextEditingController();
  final ValueNotifier<bool> _isDeleted = ValueNotifier<bool>(false);
  late StaffsBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<StaffsBloc>(context);
    _bloc.add(StaffsViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('1299'.tr())),
      body: BlocConsumer<StaffsBloc, StaffsState>(
        listener: (context, state) {
          if (state is StaffsFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is StaffsSuccess) {
            _getData(state: state);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTileWidget(
                    initiallyExpanded: true,
                    listWidget: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    controller: _staffIDController,
                                    label: '3506')),
                            _buildSizedBox(),
                            Expanded(
                                child: _buildTextField(
                              controller: _staffNameController,
                              label: '3507',
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: ValueListenableBuilder(
                              valueListenable: _roleTypeNotifier,
                              builder: (context, value, child) =>
                                  DropDownButtonFormField2StdCodeWidget(
                                      isRequired: false,
                                      onChanged: (value) {
                                        _roleTypeNotifier.value =
                                            value as StdCode;
                                        roleTypeSelected = value;
                                      },
                                      value: roleTypeSelected,
                                      label: '3508',
                                      hintText: '3508',
                                      list: state.roleTypeList),
                            )),
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
                                      list: state.dcList),
                            ))
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isDeleted,
                        builder: (context, value, child) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('54'.tr()),
                          value: _isDeleted.value,
                          onChanged: (value) {
                            _isDeleted.value = value!;
                          },
                        ),
                      ),
                      ElevatedButtonWidget(
                        text: '36',
                        onPressed: () {
                          _bloc.add(StaffsSearch(
                              generalBloc: generalBloc,
                              staffID: _staffIDController.text,
                              staffName: _staffNameController.text,
                              roleType: _roleTypeNotifier.value,
                              dcCode: _dcNotifier.value,
                              isDeleted: _isDeleted.value));
                        },
                      ),
                    ],
                  ),
                  QuantityQuickSearchWidget(
                    controller: _quickSearchController,
                    quantity: '${state.staffListSearch.length}',
                    onChanged: (value) {
                      _bloc.add(StaffsQuickSearch(textSearch: value));
                    },
                  ),
                  _buildTable(staffList: state.staffListSearch)
                ],
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  void _getData({required StaffsSuccess state}) {
    _dcNotifier.value = state.dcLocalSearch;
    _roleTypeNotifier.value = state.roleTypeSearch;
    dcSelected = state.dcLocalSearch;
    roleTypeSelected = state.roleTypeSearch;
    _staffIDController.text = state.staffIDSearch;
    _staffNameController.text = state.staffNameSearch;
    _isDeleted.value = state.isDeleted;
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          label: Text(
            label.tr(),
          ),
          hintText: label.tr()),
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(
      width: 10.w,
    );
  }

  Widget _buildTable({required List<StaffsResponse> staffList}) {
    return IntrinsicHeight(
      child: Column(
        children: [
          TableDataWidget(
              listTableRowHeader: const [
                HeaderTable2Widget(label: '5586', width: 50),
                HeaderTable2Widget(label: '3506', width: 120),
                HeaderTable2Widget(label: '3507', width: 160),
                HeaderTable2Widget(label: '1298', width: 100),
                HeaderTable2Widget(label: '3508', width: 120),
                HeaderTable2Widget(label: '90', width: 80),
              ],
              listTableRowContent: staffList == [] || staffList.isEmpty
                  ? [
                      const CellTableNoDataWidget(width: 630),
                    ]
                  : List.generate(staffList.length, (index) {
                      return ColoredBox(
                          color: colorRowTable(index: index),
                          child: InkWell(
                            onTap: () async {
                              final result = await _navigationService
                                  .navigateAndDisplaySelection(
                                      routes.staffDetailRoute,
                                      args: {
                                    key_params.userId: staffList[index]
                                        .staffUserId
                                        .toString()
                                        .trim()
                                  });
                              if (result != null) {
                                _bloc.add(StaffsSearch(
                                    generalBloc: generalBloc,
                                    staffID: _staffIDController.text,
                                    staffName: _staffNameController.text,
                                    roleType: _roleTypeNotifier.value,
                                    dcCode: _dcNotifier.value,
                                    isDeleted: _isDeleted.value));
                              }
                            },
                            child: Row(
                              children: [
                                CellTableWidget(
                                  width: 50,
                                  content: (index + 1).toString(),
                                ),
                                CellTableWidget(
                                  width: 120,
                                  content: staffList[index].staffUserId ?? '',
                                ),
                                CellTableWidget(
                                    width: 160,
                                    content: staffList[index].staffName ?? '',
                                    isAlignLeft: true),
                                CellTableWidget(
                                  width: 100,
                                  content:
                                      staffList[index].defaultEquipment ?? '',
                                ),
                                CellTableWidget(
                                  width: 120,
                                  content: staffList[index].roleType ?? '',
                                ),
                                CellTableWidget(
                                  width: 80,
                                  content: staffList[index].dcCode ?? '',
                                ),
                              ],
                            ),
                          ));
                    })),
        ],
      ),
    );
  }
}
