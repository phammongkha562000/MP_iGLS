import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/inventory/barcode_tracking/barcode_tracking_bloc.dart';
import 'package:igls_new/data/models/ware_house/inventory/gr_tracking_response.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/styles.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/custom_card.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/widgets/table_widget/cell_table_view.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

class BarcodeTrackingView extends StatefulWidget {
  const BarcodeTrackingView({super.key});

  @override
  State<BarcodeTrackingView> createState() => _BarcodeTrackingViewState();
}

class _BarcodeTrackingViewState extends State<BarcodeTrackingView> {
  late BarcodeTrackingBloc _bloc;
  late GeneralBloc generalLoc;

  BehaviorSubject<List<GrTrackingResponse>> listTracking = BehaviorSubject();

  final _key1 = GlobalKey<FormState>();
  final TextEditingController _grNoController = TextEditingController();

  @override
  void initState() {
    generalLoc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<BarcodeTrackingBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('5587'.tr()),
        ),
        body: BlocConsumer<BarcodeTrackingBloc, BarcodeTrackingState>(
          listener: (context, state) {
            if (state is BarcodeTrackingSuccess) {
              listTracking.add(state.lstTracking);
            }
          },
          builder: (context, state) {
            if (state is BarcodeTrackingLoading) {
              return const ItemLoading();
            }
            return StreamBuilder(
              stream: listTracking.stream,
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGRNo(),
                        (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data! != [] &&
                                snapshot.data!.isNotEmpty)
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 16.w),
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        color: Colors.green, width: 8.w),
                                  ),
                                ),
                                child: Text(
                                  snapshot.data![0].grNo ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))
                            : const SizedBox(),
                        (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data! != [] &&
                                snapshot.data!.isNotEmpty)
                            ? TableView(
                                headerChildren: _headerStrList,
                                rowChildren: !snapshot.hasData
                                    ? []
                                    : List.generate(snapshot.data!.length, (i) {
                                        final item = snapshot.data![i];

                                        return TableRow(
                                          decoration: BoxDecoration(
                                              color: i % 2 != 0
                                                  ? colors.defaultColor
                                                      .withOpacity(0.1)
                                                  : Colors.white),
                                          children: [
                                            CellTableView(
                                                text: item.sequenNo.toString()),
                                            CellTableView(
                                              text: item.transactionType ?? '',
                                            ),
                                            CellTableView(
                                              text: item.oldLocCode ?? "",
                                            ),
                                            CellTableView(
                                              text: item.newLocCode ?? '',
                                            ),
                                            CellTableView(
                                                text: item.qty.toString()),
                                            CellTableView(
                                                text: FileUtils
                                                    .convertDateForHistoryDetailItem(
                                                        item.actionDate
                                                            .toString())),
                                          ],
                                        );
                                      }),
                              )
                            : TableView(
                                tableColumnWidth: FixedColumnWidth(
                                    (MediaQuery.sizeOf(context).width - 16.w) /
                                        6),
                                headerChildren: _headerStrList,
                                rowChildren: const []),
                      ]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildGRNo() {
    return CardCustom(
      child: Form(
        key: _key1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Text(
                  "1262".tr(),
                  style: styleTextTitle,
                )),
            Expanded(
                flex: 9,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    _searchGRNo(grNo: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '5067'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _grNoController.clear();
                        },
                      )),
                  autofocus: true,
                  controller: _grNoController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                )),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Image.asset(
                  assets.barCode,
                  scale: 2,
                ),
                onPressed: () async {
                  final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
                  qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                      context: context,
                      onCode: (code) {
                        setState(() {
                          _grNoController.text = code ?? '';
                          _searchGRNo(grNo: code ?? '');
                        });
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _searchGRNo({required String grNo}) {
    if (_key1.currentState!.validate()) {
      _bloc.add(BarcodeTrackingSearch(
          grNo: grNo,
          subsidiaryId: generalLoc.generalUserInfo?.subsidiaryId ?? ''));
    }
  }

  final List<String> _headerStrList = [
    '5586',
    '4863',
    '4864',
    '4865',
    '133',
    '4823'
  ];
}
