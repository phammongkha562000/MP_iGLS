import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/leave_detail/leave_detail_bloc.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/leave_detail_response.dart';
import 'package:igls_new/data/shared/utils/format_date_local.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/widgets/mpi/container_panel_color.dart';
import 'package:igls_new/presentations/widgets/mpi/get_widget_by_type/text_by_status.dart';
import 'package:igls_new/presentations/widgets/row/row3_7.dart';
import 'package:igls_new/presentations/widgets/spacer_width.dart';

class LeaveDetailView extends StatefulWidget {
  const LeaveDetailView({
    super.key,
    required this.lvNo,
  });
  final String lvNo;

  @override
  State<LeaveDetailView> createState() => _LeaveDetailViewState();
}

class _LeaveDetailViewState extends State<LeaveDetailView> {
  late LeaveDetailBloc _bloc;
  late GeneralBloc generalBloc;
  Color backgroundPanel = colors.defaultColor;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<LeaveDetailBloc>(context);
    _bloc.add(LeaveDetailLoaded(
        lvNo: widget.lvNo,
        empCode: generalBloc.generalUserInfo?.empCode ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).primaryColor;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarCustom(
            title: Text("5696".tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            )),
        /*  onPressBack: () {
              Navigator.pop(context, 1);
            }), */
        body: BlocConsumer<LeaveDetailBloc, LeaveDetailState>(
          listener: (context, state) {
            if (state is LeaveDetailFailure) {
              CustomDialog().error(context, err: state.message,
                  btnOkOnPress: () {
                _bloc.add(LeaveDetailLoaded(
                    lvNo: widget.lvNo,
                    empCode: generalBloc.generalUserInfo?.empCode ?? ''));
              });
              // MyDialog.showError(
              //     context: context,
              //     messageError: state.message,
              //     pressTryAgain: () {
              //       Navigator.pop(context);
              //     },
              //     whenComplete: () {
              //       _bloc.add(LeaveDetailLoaded(lvNo: widget.lvNo));
              //     });
            }
          },
          builder: (context, state) {
            if (state is LeaveDetailLoadSuccess) {
              final detail = state.leaveDetail;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Column(
                  children: [
                    buildCard1(detail),
                    buildCardRemark(detail),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 100.h),
                        itemCount: detail.hlvLeaveDetails!.length,
                        itemBuilder: (context, index) {
                          var itemDetail = detail.hlvLeaveDetails![index];
                          return _buildApproval(
                              itemDetail: itemDetail, item: detail);
                        },
                      ),
                    )
                  ],
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildApproval(
      {required HlvLeaveDetail itemDetail, required LeaveDetailPayload item}) {
    return Card /* CardCustom */ (
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTypeAndDate(itemDetail),
              _buildNameAndStatus(itemDetail: itemDetail, item: item),
              itemDetail.comment != null && itemDetail.comment != ''
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(itemDetail.comment ?? ''),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Widget _buildNameAndStatus(
      {required HlvLeaveDetail itemDetail, required LeaveDetailPayload item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(
            itemDetail.assignerName ?? '',
          ),
        ),
        itemDetail.leaveStatus != null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.bgDrawerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: TextByTypeStatus(status: itemDetail.leaveStatus ?? ""),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget buildTypeAndDate(HlvLeaveDetail itemDetail) {
    log("${itemDetail.replyType}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
          decoration: BoxDecoration(
              color: colors.bgDrawerColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              )),
          child: Row(
            children: [
              getIConByType(
                  type: itemDetail.replyType.toString(),
                  status: itemDetail.leaveStatus == null ? false : true),
              const WidthSpacer(width: 0.02),
              Text(
                itemDetail.replyTypeDesc ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        (itemDetail.approvalType == null) && (itemDetail.replyType != 'REQ')
            ? const SizedBox()
            : ContainerPanelColor(
                isRight: true,
                text: FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                    itemDetail.createDate.toString())),

        /* Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                    color: backgroundPanel,
                    borderRadius: LayoutCustom.borderRadiusLeft32),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                        itemDetail.createDate.toString()),
                    style: TextStyle(
                      color: colorPanel,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ) */
      ],
    );
  }

  Card buildCardRemark(LeaveDetailPayload item) {
    return Card /* CardCustom */ (
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          children: [
            DecoratedBox(
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: colors.outerSpace))),
                child: Text(
                  "1276".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              children: [
                Text(
                  item.remark.toString(),
                  style: styleItem(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildCard1(LeaveDetailPayload item) {
    return Card /* CardCustom */ (
      elevation: 10,
      child: Column(
        children: [
          ColoredBox(
              color: backgroundPanel,
              child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.lvNo ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              children: [
                RowFlex3and7(
                    child3: Text(
                      "5697".tr(),
                      style: styleItem(),
                    ),
                    child7: Text(
                      "${FormatDateLocal.format_dd_MM_yyyy(item.fromDate.toString())} - ${FormatDateLocal.format_dd_MM_yyyy(item.toDate.toString())}",
                      style: styleItemBold(),
                    )),
                RowFlex3and7(
                  child3: Text(
                    "5685".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    '${item.leaveDays} - ${item.marker}',
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "5698".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    item.employeeName ?? '',
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "5686".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    item.leaveTypeDesc ?? "",
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "5699".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    FormatDateLocal.format_dd_MM_yyyy(
                        item.submitDate.toString()),
                    style: styleItemBold(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle styleItem() {
    return const TextStyle(
      color: colors.textBlack,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle styleItemBold() {
    return const TextStyle(
      color: colors.textBlack,
      fontWeight: FontWeight.bold,
    );
  }

  DecoratedBox getIConByType({required String type, required bool status}) {
    switch (type) {
      case "REQ":
      case "Request":
        return const DecoratedBox(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: colors.defaultColor),
            child: Icon(Icons.person, color: Colors.white));

      case "APPO":
      case "Approval":
        return status
            ? const DecoratedBox(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: colors.amber),
                child: Icon(Icons.check,
                    color: Colors
                        .white)) /*  const Icon(
                Icons.check,
                color: Colors.yellow,
              ) */ /* MyAssets.approveYellow */
            : const DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: colors.btnGreyDisable),
                child: Icon(Icons.check, color: Colors.white));
      /* const Icon(
                Icons.check,
                color: Colors.grey,
              ) */ /* MyAssets.approveGray */
      case "Action":
        return status
            ? const DecoratedBox(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: colors.amber),
                child: Icon(Icons.check,
                    color: Colors
                        .white)) /*  const Icon(
                Icons.check,
                color: Colors.yellow,
              ) */ /* MyAssets.approveYellow */
            : const DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: colors.btnGreyDisable),
                child: Icon(Icons.check, color: Colors.white));
      default:
        return const DecoratedBox(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: colors.defaultColor),
            child: Icon(Icons.person, color: Colors.white));
    }
  }
}
