import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/presentations/widgets/customer_component/title_expansion.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/models/customer/contract_logistics/inbound_order_status/get_ios_detail_res.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/table_widget/table_data.dart';

class InboundOrderDetailView extends StatefulWidget {
  const InboundOrderDetailView({super.key, required this.orderId});
  final int orderId;

  @override
  State<InboundOrderDetailView> createState() => _InboundOrderDetailViewState();
}

class _InboundOrderDetailViewState extends State<InboundOrderDetailView> {
  late CustomerBloc customerBloc;
  late InboundOrderDetailBloc iosDetailBloc;
  TextEditingController receiptDateCtrl = TextEditingController();
  TextEditingController orderStatusCtrl = TextEditingController();
  TextEditingController orderTypeCtl = TextEditingController();
  TextEditingController updateByCrtl = TextEditingController();
  TextEditingController createdCrtl = TextEditingController();
  BehaviorSubject<List<Items>> lstItemCtrl = BehaviorSubject<List<Items>>();
  BehaviorSubject<List<OrderDocuments>> lstDocumentsCtrl =
      BehaviorSubject<List<OrderDocuments>>();
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    iosDetailBloc = BlocProvider.of<InboundOrderDetailBloc>(context)
      ..add(InboundOrderDetailLoaded(
          orderId: widget.orderId.toString(),
          strCompany: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarCustom(
              title: const Text('IOS Detail'), //hardcode
            ),
            body: BlocConsumer<InboundOrderDetailBloc, InboundOrderDetailState>(
                listener: (context, state) {
              if (state is IOSDetailLoadSuccess) {
                receiptDateCtrl.text =
                    FileUtils.convertDateForHistoryDetailItem(
                        state.iosDetailRes.orderDetail?.receiptDate ?? '');
                orderStatusCtrl.text =
                    state.iosDetailRes.orderDetail?.ordStatus ?? "";
                orderTypeCtl.text =
                    state.iosDetailRes.orderDetail?.orderType ?? '';
                updateByCrtl.text =
                    state.iosDetailRes.orderDetail?.updateUser ?? '';
                createdCrtl.text =
                    "${FileUtils.convertDateForHistoryDetailItem(state.iosDetailRes.orderDetail?.createDate ?? '')} By ${state.iosDetailRes.orderDetail?.createUser}";
                lstItemCtrl.add(state.iosDetailRes.items ?? []);
                lstDocumentsCtrl.add(state.iosDetailRes.orderDocuments ?? []);
              }
              if (state is DownloadFileSuccessState) {
                CustomDialog().success(context);
              }
              if (state is DownloadFileFailState) {
                CustomDialog().error(context);
              }
              if (state is IOSDetailLoadFail) {
                CustomDialog().error(context, err: state.message,
                    btnOkOnPress: () {
                  Navigator.pop(context);
                });
              }
            }, builder: (context, state) {
              if (state is ShowLoadingState) {
                return const Center(child: ItemLoading());
              }
              return SingleChildScrollView(
                child: Column(children: [
                  buildGeneral(),
                  buildItem(),
                  buildDocumments(),
                  buildPhoto()
                ]),
              );
            })));
  }

  buildGeneral() => ExpansionTile(
          initiallyExpanded: true,
          title: const TitleExpansionWidget(
              text: '102', asset: Icon(Icons.gamepad_sharp)),
          childrenPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: receiptDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text('125'.tr()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: orderStatusCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text('124'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: orderTypeCtl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text('123'.tr()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: updateByCrtl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text('65'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: TextFormField(
                controller: createdCrtl,
                readOnly: true,
                decoration: InputDecoration(
                  label: Text('2385'.tr()),
                ),
              ),
            )
          ]);
  buildItem() => ExpansionTile(
          initiallyExpanded: true,
          title: const TitleExpansionWidget(
              text: '144', asset: Icon(Icons.assignment_rounded)),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: StreamBuilder<List<Items>>(
                    stream: lstItemCtrl.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Row(children: _headerTableItem()),
                                Expanded(
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: List.generate(
                                            snapshot.data!.length, (index) {
                                          final item = snapshot.data![index];
                                          return ColoredBox(
                                            color: colorRowTable(index: index),
                                            child: Row(children: [
                                              CellTableWidget(
                                                width: 120.w,
                                                content: item.itemCode ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 230.w,
                                                content: item.itemDesc ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 100.w,
                                                content: item.grade ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 150.w,
                                                content: item.lotCode ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 150.w,
                                                content:
                                                    item.productionDate ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 150.w,
                                                content: item.expiredDate ?? '',
                                              ),
                                              CellTableWidget(
                                                width: 150.w,
                                                content: item.qty.toString(),
                                              ),
                                              CellTableWidget(
                                                  width: 150.w,
                                                  content:
                                                      item.gRQty.toString()),
                                            ]),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return emptyDataWidget(_headerTableItem());
                      }
                      return emptyDataWidget(_headerTableItem());
                    },
                  )),
                ],
              ),
            ),
          ]);
  buildDocumments() => ExpansionTile(
          initiallyExpanded: true,
          title:
              const TitleExpansionWidget(text: '2463', asset: Icon(Icons.apps)),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: StreamBuilder<List<OrderDocuments>>(
                    stream: lstDocumentsCtrl.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Row(children: _headerTableDocuments()),
                                Expanded(
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: List.generate(
                                            snapshot.data!.length, (index) {
                                          final item = snapshot.data![index];
                                          return ColoredBox(
                                            color: colorRowTable(index: index),
                                            child: Row(children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialogConfirm(item);
                                                },
                                                child: CellTableWidget(
                                                  width: 400.h,
                                                  content: item.fileName ?? '',
                                                ),
                                              ),
                                              CellTableWidget(
                                                width: 250.h,
                                                content:
                                                    "By ${item.createUser}",
                                              ),
                                            ]),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return emptyDataWidget(_headerTableDocuments());
                      }
                      return emptyDataWidget(_headerTableDocuments());
                    },
                  )),
                ],
              ),
            ),
          ]);
  buildPhoto() => const ExpansionTile(
      initiallyExpanded: true,
      title: TitleExpansionWidget(
          text: '4804', asset: Icon(Icons.photo_library_rounded)),
      children: []); //hardcode
  List<Widget> _headerTableItem() {
    return [
      HeaderTable2Widget(label: '128'.tr(), width: 120.w),
      HeaderTable2Widget(label: '131'.tr(), width: 230.w),
      HeaderTable2Widget(label: '132'.tr(), width: 100.w),
      HeaderTable2Widget(label: 'List Code', width: 150.w),
      HeaderTable2Widget(label: '167'.tr(), width: 150.w),
      HeaderTable2Widget(label: '166'.tr(), width: 150.w),
      HeaderTable2Widget(label: '133'.tr(), width: 150.w),
      HeaderTable2Widget(label: '178'.tr(), width: 150.w),
    ];
  }

  List<Widget> _headerTableDocuments() {
    return [
      HeaderTable2Widget(label: '5279'.tr(), width: 400.w),
      HeaderTable2Widget(label: '63'.tr(), width: 250.w),
    ];
  }

 

  showDialogConfirm(OrderDocuments item) {
    AwesomeDialog(
        padding: EdgeInsets.all(8.w),
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        dismissOnTouchOutside: false,
        btnOkText: "Xác nhận",
        btnCancelText: "Hủy",
        autoDismiss: false,
        onDismissCallback: (type) {},
        body: Text(
          "Tải file ${item.fileName} về máy ?",
          style: styleTextTitle,
        ),
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          Navigator.of(context).pop();
          iosDetailBloc.add(DownloadFileEvent(
              docNo: item.docNo.toString(),
              fileName: item.fileName ?? '',
              strCompany:
                  customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
        }).show();
  }

  emptyDataWidget(List<Widget> headerTable) => Column(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: headerTable)),
        SizedBox(height: 100.h, child: Center(child: Text("5058".tr())))
      ]);
}
