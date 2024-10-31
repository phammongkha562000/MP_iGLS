import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/picking/picking/picking_bloc.dart';
import 'package:igls_new/data/models/ware_house/picking/picking_item_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/widgets/table_widget/cell_table_no_data.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class PickingView extends StatefulWidget {
  const PickingView({super.key});

  @override
  State<PickingView> createState() => _PickingViewState();
}

class _PickingViewState extends State<PickingView> {
  final _navigationService = getIt<NavigationService>();

  BehaviorSubject<List<PickingItemResponse>> lstItem =
      BehaviorSubject<List<PickingItemResponse>>();
  final TextEditingController _waveNoController = TextEditingController();
  late PickingBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<PickingBloc>(context);
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(title: Text('1294'.tr())),
        body: BlocConsumer<PickingBloc, PickingState>(
          listener: (context, state) {
            if (state is PickingSuccess) {
              lstItem.add(state.lstItem);
            }
            if (state is PickingFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          builder: (context, state) {
            if (state is PickingLoading) {
              return const ItemLoading();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildCard(),
                  _buildTable()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    return CardCustom(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text("183".tr()),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              decoration: InputDecoration(
                  hintText: '${'5185'.tr()}...',
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _waveNoController.clear();
                    },
                  )),
              textInputAction: TextInputAction.done,
              onSubmitted: (newValue) {
                getListItem();
              },
              controller: _waveNoController,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Image.asset(
                assets.barCode,
                scale: 2,
              ),
              onPressed: () {
                final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
                qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                    context: context,
                    onCode: (code) {
                      setState(() {
                        _waveNoController.text = code ?? '';
                        getListItem();
                      });
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTable() {
    return IntrinsicHeight(
      child: Row(
        children: [
          StreamBuilder(
            stream: lstItem.stream,
            builder: (context, snapshot) {
              return TableDataWidget(
                listTableRowHeader: _headerTable(context),
                listTableRowContent: (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty)
                    ? List.generate(snapshot.data!.length, (i) {
                        final item = snapshot.data![i];

                        return InkWell(
                          onTap: () async {
                            final result = await _navigationService
                                .navigateAndDisplaySelection(
                                    routes.pickingDetailRoute,
                                    args: {key_params.pickingItem: item});
                            if (result != null) {
                              getListItem();
                            }
                          },
                          child: ColoredBox(
                              color: colorRowTable(index: i),
                              child: Row(children: [
                                CellTableWidget(
                                    width: (MediaQuery.sizeOf(context).width -
                                            16.w) /
                                        3,
                                    content: item.locCode.toString()),
                                CellTableWidget(
                                    width: (MediaQuery.sizeOf(context).width -
                                            16.w) /
                                        3,
                                    content: item.itemCode ?? ''),
                                CellTableWidget(
                                  width: (MediaQuery.sizeOf(context).width -
                                          16.w) /
                                      3,
                                  content: item.pKPQty.toString(),
                                )
                              ])),
                        );
                      })
                    : [
                        CellTableNoDataWidget(
                            width: MediaQuery.sizeOf(context).width - 16.w),
                      ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _headerTable(context) {
    return [
      HeaderTable2Widget(
          label: "165", width: (MediaQuery.sizeOf(context).width - 16.w) / 3),
      HeaderTable2Widget(
          label: "4867", width: (MediaQuery.sizeOf(context).width - 16.w) / 3),
      HeaderTable2Widget(
          label: "133", width: (MediaQuery.sizeOf(context).width - 16.w) / 3),
    ];
  }

  void getListItem() {
    _bloc.add(PickingSearch(
        waveNo: _waveNoController.text, generalBloc: generalBloc));
  }
}
