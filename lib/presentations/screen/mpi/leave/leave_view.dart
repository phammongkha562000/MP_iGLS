import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/leave/leave_bloc.dart';
import 'package:igls_new/data/models/mpi/leave/leaves/leave_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/format_date_local.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/empty.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/widgets/load/loading_paging.dart';
import 'package:igls_new/presentations/widgets/mpi/container_panel_color.dart';
import 'package:igls_new/presentations/widgets/mpi/get_widget_by_type/text_by_status.dart';
import 'package:igls_new/presentations/widgets/pick_date_previous_next.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class LeaveView extends StatefulWidget {
  const LeaveView({super.key, required this.isAddLeave});
  final bool isAddLeave;
  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  final _navigationService = getIt<NavigationService>();
  DateTime date = DateTime.now();
  BehaviorSubject<List<LeaveResult>> leaveLst = BehaviorSubject();
  final ScrollController _scrollController = ScrollController();
  int quantity = 0;
  late GeneralBloc generalBloc;
  late LeaveBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<LeaveBloc>(context);
    _bloc.userInfo = generalBloc.generalUserInfo;
    _bloc.add(LeaveLoaded(date: DateTime.now()));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        BlocProvider.of<LeaveBloc>(context)
            .add(LeavePaging(date: DateTime.now()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBarCustom(
            title: Text("5684".tr()),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.isAddLeave == true
                    ? () {
                        _navigationService.pushNamed(routes.homePageRoute);
                      }
                    : () {
                        Navigator.pop(context);
                      }),
          ),
          body: BlocConsumer<LeaveBloc, LeaveState>(
            listener: (context, state) {
              if (state is LeaveFailure) {
                CustomDialog().error(context, err: state.message,
                    btnOkOnPress: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<LeaveBloc>(context)
                      .add(LeaveLoaded(date: date));
                });
                /* MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    BlocProvider.of<LeaveBloc>(context)
                        .add(LeaveLoaded(date: date));
                  }); */
              }
              if (state is LeaveLoadSuccess) {
                leaveLst.add(state.leavePayload ?? []);
                quantity = state.quantity;
              }
            },
            builder: (context, state) {
              if (state is LeaveLoading) {
                return const ItemLoading();
              }
              return StreamBuilder(
                stream: leaveLst.stream,
                builder: (context, snapshot) {
                  return PickDatePreviousNextWidget(
                      isMonth: true,
                      onTapPrevious: () {
                        date = DateTime(date.year, date.month - 1, 1);
                        BlocProvider.of<LeaveBloc>(context)
                            .add(LeaveLoaded(date: date));
                      },
                      onTapNext: () {
                        date = DateTime(date.year, date.month + 1, 1);
                        BlocProvider.of<LeaveBloc>(context)
                            .add(LeaveLoaded(date: date));
                      },
                      onTapPick: (selectedDate) {
                        date = selectedDate;
                        BlocProvider.of<LeaveBloc>(context)
                            .add(LeaveLoaded(date: selectedDate));
                      },
                      stateDate: date,
                      quantityText: "$quantity",
                      lstChild: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              BlocProvider.of<LeaveBloc>(context)
                                  .add(LeaveLoaded(date: date));
                            },
                            child: (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data!.isEmpty)
                                ? ListView(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.8,
                                        child: const EmptyWidget(),
                                      ),
                                    ],
                                  )
                                : Scrollbar(
                                    controller: _scrollController,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.only(
                                          bottom: 48.h,
                                          left: 16.w,
                                          right: 16.w),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var item = snapshot.data![index];

                                        return _buildCard(item: item);
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        (state is LeavePagingLoading)
                            ? const PagingLoading()
                            : const SizedBox()
                      ]);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              '5701'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _navigationService.pushNamed(routes.mpiAddLeaveRoute);
            },
            icon: const Icon(Icons.add),
          )),
    );
  }

  Widget _buildCard({required LeaveResult item}) {
    return InkWell(
      onTap: () {
        _navigationService.pushNamed(routes.mpiLeaveDetailRoute,
            args: {key_params.lvNoLeave: item.lvNo});
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w, top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(item.lvNo ?? ''),
                  ContainerPanelColor(text: item.lvNo ?? ''),

                  TextByTypeStatus(status: item.leaveStatus.toString())
                ],
              ),
            ),
            _buildDate(
              title: '5147',
              content:
                  FormatDateLocal.format_dd_MM_yyyy(item.fromDate.toString()),
            ),
            _buildDate(
              title: '5151',
              content:
                  FormatDateLocal.format_dd_MM_yyyy(item.toDate.toString()),
            ),
            _buildDate(
              title: '5685',
              content: '${item.leaveDays} - ${item.marker}',
            ),
            _buildLeaveType(item)
          ],
        ),
      ),
    );
  }

  TextStyle styleItem() {
    return const TextStyle(
      color: colors.textBlack,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle styleContent() {
    return const TextStyle(
      color: colors.textBlack,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildDate({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            title.tr(),
            style: styleItem(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            content,
            style: styleContent(),
          ),
        ),
      ]),
    );
  }

  Padding _buildLeaveType(LeaveResult item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Row(children: [
        Expanded(
          child: Text(
            "5686".tr(),
            style: styleItem(),
          ),
        ),
        Expanded(
          child: Text(
            item.leaveTypeDesc.toString(),
            style: styleContent(),
          ),
        ),
        Expanded(
          child: Text(
            FormatDateLocal.format_dd_MM_yyyy(item.submitDate.toString()),
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: colors.textGrey,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3),
          ),
        ),
      ]),
    );
  }

  String getTextType(String type) {
    switch (type) {
      case "NEW":
        return "new".tr();
      case "INPR":
        return "inpr".tr();
      case "CLOS":
        return "close".tr();
      default:
        return "";
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "NEW":
        return colors.btnGreen;
      case "INPR":
        return colors.defaultColor;
      case "CLOS":
        return colors.textRed;
      default:
        return colors.btnGreen;
    }
  }
}
