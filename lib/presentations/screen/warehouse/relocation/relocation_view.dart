import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/relocation/relocation_bloc.dart';
import 'package:igls_new/data/models/ware_house/relocation/relocation_response.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';

import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class RelocationView extends StatefulWidget {
  const RelocationView({super.key});

  @override
  State<RelocationView> createState() => _RelocationViewState();
}

class _RelocationViewState extends State<RelocationView> {
  late RelocationBloc _bloc;
  late GeneralBloc generalBloc;
  final _remarkController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<RelocationBloc>(context);
    _bloc.add(
        RelocationViewLoaded(date: DateTime.now(), generalBloc: generalBloc));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(RelocationPaging(generalBloc: generalBloc));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('2400'.tr())),
      body: BlocConsumer<RelocationBloc, RelocationState>(
        listener: (context, state) {
          if (state is RelocationSuccess) {
            if (state.saveSuccess == true) {
              CustomDialog().success(context);
              return;
            }
          }
          if (state is RelocationFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is RelocationSuccess) {
            return PickDatePreviousNextWidget(
                quantityText: '${state.quantity}',
                onTapPrevious: () {
                  _bloc.add(
                      RelocationPreviousDateLoaded(generalBloc: generalBloc));
                },
                onTapPick: (selectDate) {
                  _bloc.add(RelocationPickDate(
                      date: selectDate, generalBloc: generalBloc));
                },
                onTapNext: () {
                  _bloc.add(RelocationNextDateLoaded(generalBloc: generalBloc));
                },
                stateDate: state.date,
                lstChild: [
                  Expanded(
                      child: state.relocationList.isEmpty
                          ? const Center(
                              child: EmptyWidget(),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return _rowItemPlan(
                                    item: state.relocationList[index]);
                              },
                              itemCount: state.relocationList.length,
                            )),
                  state.isPagingLoading
                      ? const PagingLoading()
                      : const SizedBox()
                ]);
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _row(
      {required String title, required String content, Widget? widget}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: widget != null ? textStyle(color: colors.textBlack) : null,
            ),
          ),
          widget ?? const SizedBox(),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.right,
              style: textStyle(color: colors.textBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowItemPlan({required RelocationResult item}) {
    return ElevatedButtonWidget(
      onPressed: () => _showDialogWidget(context, item: item),
      height: 50,
      borderRadius: 8.r,
      backgroundColor:
          item.isDone ?? false ? colors.btnGreyDisable : colors.defaultColor,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.oldLocCode ?? '',
              style: textStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.double_arrow,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.newLocCode ?? '',
              style: textStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              NumberFormatter.numberFormatTotalQty(item.qty!).toString(),
              style: textStyle(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ).paddingSymmetric(vertical: 8.h);
  }

  Future _showDialogWidget(BuildContext context,
          {required RelocationResult item}) =>
      AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              dialogType:
                  item.isDone ?? false ? DialogType.info : DialogType.question,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(isDone: item.isDone ?? false),
                  _row(title: '128'.tr(), content: item.itemCode ?? ''),
                  _row(title: '131'.tr(), content: item.itemDesc ?? ''),
                  _row(
                      title: '133'.tr(),
                      content: NumberFormatter.numberFormatTotalQty(item.qty!)
                          .toString()),
                  const Divider(color: colors.btnGreyDisable),
                  _row(
                    title: item.oldLocCode ?? '',
                    content: item.newLocCode ?? '',
                    widget: const Icon(
                      Icons.double_arrow,
                      color: colors.defaultColor,
                    ),
                  ),
                  const Divider(color: colors.btnGreyDisable),
                  item.isDone ?? false
                      ? Column(
                          children: [
                            _row(
                                title: '1276'.tr(),
                                content: item.completeMemo ?? ''),
                            _row(
                                title: '62'.tr(),
                                content:
                                    FileUtils.convertDateForHistoryDetailItem(
                                        item.createDate!)),
                            _row(
                                title: '63'.tr(),
                                content: item.createUser ?? ''),
                            _row(
                                title: '64'.tr(),
                                content:
                                    FileUtils.convertDateForHistoryDetailItem(
                                        item.updateDate!)),
                            _row(
                                title: '65'.tr(),
                                content: item.updateUser ?? ''),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Text('1276'.tr()),
                        ),
                  item.isDone ?? false
                      ? const SizedBox()
                      : TextFormField(
                          controller: _remarkController,
                          minLines: 1,
                          maxLines: 4,
                        )
                ],
              ).paddingSymmetric(horizontal: 8.w),
              btnCancelText: "26".tr(),
              btnCancelColor: Colors.blue,
              btnCancelOnPress: () {},
              btnOkText: '5087'.tr(),
              btnOkColor: colors.textRed,
              btnOkOnPress: item.isDone ?? false
                  ? null
                  : () {
                      _showConfirmDialog(context, item: item);
                    })
          .show();

  _showConfirmDialog(BuildContext context, {required RelocationResult item}) =>
      AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType:
              item.isDone ?? false ? DialogType.info : DialogType.question,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  _textSpan(
                    text: "${'5088'.tr()} ",
                  ),
                  _textSpan(text: item.itemDesc!.toUpperCase(), isStyle: true),
                  _textSpan(
                    text: ' ${'5147'.tr()} ',
                  ),
                  _textSpan(text: item.oldLocCode!, isStyle: true),
                  _textSpan(
                    text: ' ${'5151'.tr()} ',
                  ),
                  _textSpan(text: item.newLocCode!, isStyle: true),
                  _textSpan(
                    text: ' ? ',
                  ),
                ])),
              ],
            ),
          ),
          btnCancelText: "26".tr(),
          btnCancelColor: Colors.blue,
          btnCancelOnPress: () {},
          btnOkText: '5087'.tr(),
          btnOkColor: colors.textRed,
          btnOkOnPress: () {
            _bloc.add(RelocationSave(
                item: item,
                remark: _remarkController.text,
                generalBloc: generalBloc));
            _remarkController.text = '';
          }).show();

  Widget _title({required bool isDone}) {
    return Center(
      child: Text(
        isDone ? '5086'.tr().toUpperCase() : '5085'.tr().toUpperCase(),
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: colors.defaultColor),
      ),
    );
  }

  TextSpan _textSpan({required String text, bool? isStyle}) => TextSpan(
      text: text,
      style: TextStyle(
          fontWeight: isStyle ?? false ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
          color: colors.textBlack,
          fontStyle: isStyle ?? false ? FontStyle.italic : FontStyle.normal));
}
