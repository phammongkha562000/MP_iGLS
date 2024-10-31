import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/global/global.dart';
import 'package:igls_new/data/models/inbox/notification_response.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/home/inbox/notification_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/shared.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  BehaviorSubject<List<NotificationItem>> notificationList = BehaviorSubject();
  final ValueNotifier _isSelectNotifier = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();

  late GeneralBloc generalBloc;
  late NotificationBloc notificationBloc;
  int quantity = 0;
  @override
  void initState() {
    generalBloc = BlocProvider.of(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    notificationBloc.add(NotificationViewLoaded(generalBloc: generalBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        notificationBloc.add(NotificationPaging(
            userId: generalBloc.generalUserInfo?.userId ?? ''));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, globalApp.countNotification),
        ),
        title: Text('5252'.tr()),
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationUpdateSuccessfully) {
              notificationBloc
                  .add(NotificationViewLoaded(generalBloc: generalBloc));
            }
            if (state is NotificationSuccess) {
              notificationList.add(state.notificationList);
              quantity = state.quantity;
            }
            if (state is NotificationPagingSuccess) {
              notificationList.add(state.notificationList);
            }
            if (state is NotificationFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          child: StreamBuilder(
            stream: notificationList.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  final listSelected = snapshot.data!
                      .where((element) => element.isSelected == true)
                      .toList();
                  final isRead = (listSelected.isEmpty &&
                              snapshot.data!
                                  .where((element) =>
                                      element.finalStatusMessage == 'NEW')
                                  .toList()
                                  .isNotEmpty ||
                          listSelected.isNotEmpty &&
                              listSelected
                                  .where((element) =>
                                      element.isSelected == true &&
                                      element.finalStatusMessage == 'NEW')
                                  .toList()
                                  .isNotEmpty)
                      ? true
                      : false;
                  return Column(
                    children: [
                      _buildCountNoti(
                          quantity: quantity /* notificationList.value */,
                          listSelected: listSelected),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: _isSelectNotifier,
                          builder: (context, value, child) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                notificationBloc.add(NotificationViewLoaded(
                                    generalBloc: generalBloc));
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 40),
                                itemCount: snapshot.data!.length,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  final item = snapshot.data![index];
                                  return InkWell(
                                    onTap: _isSelectNotifier.value
                                        ? () {
                                            notificationBloc.add(
                                                NotificationChecked(
                                                    reqId: item.reqId ?? 0,
                                                    isChecked:
                                                        item.isSelected != null
                                                            ? !item.isSelected!
                                                            : true));
                                          }
                                        : () {
                                            notificationBloc.add(
                                                NotificationUpdateStatus(
                                                    generalBloc: generalBloc,
                                                    templateId:
                                                        item.templateId ?? 0,
                                                    status: constants.inboxRead,
                                                    reqIds:
                                                        item.reqId.toString()));
                                          },
                                    child: ColoredBox(
                                        color: item.finalStatusMessage == 'NEW'
                                            ? colors.bgDrawerColor
                                            : Colors.white,
                                        child: Row(
                                          children: [
                                            _isSelectNotifier.value
                                                ? Checkbox(
                                                    activeColor:
                                                        colors.defaultColor,
                                                    value: item.isSelected ??
                                                        false,
                                                    onChanged: (value) {
                                                      notificationBloc.add(
                                                          NotificationChecked(
                                                              reqId:
                                                                  item.reqId ??
                                                                      0,
                                                              isChecked:
                                                                  value!));
                                                    })
                                                : const SizedBox(),
                                            Expanded(
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                leading: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                              spreadRadius: 3,
                                                              blurRadius: 3,
                                                              offset:
                                                                  const Offset(
                                                                      0, 3)),
                                                        ],
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.notifications,
                                                          color: Colors.amber,
                                                          size: 36,
                                                        ))),
                                                title: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          '${item.requestTitle ?? ''} ',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colors
                                                              .textBlack)),
                                                  TextSpan(
                                                      text: item.requestMessage,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: colors
                                                              .textBlack)),
                                                ])),
                                                subtitle: Text(
                                                  FormatDateConstants
                                                      .convertddMMyyyyHHmm(
                                                          item.requestDate!),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      BlocBuilder<NotificationBloc, NotificationState>(
                          builder: (context, state) {
                        if (state is NotificationPagingLoading) {
                          return Platform.isAndroid
                              ? const CircularProgressIndicator()
                              : const CupertinoActivityIndicator();
                        }
                        return const SizedBox();
                      }),
                      _buildOptionsBottom(
                          listSelected: listSelected, isRead: isRead)
                    ],
                  );
                }
                return const EmptyWidget();
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return const ItemLoading();
            },
          )),
    );
  }

  Widget _buildCountNoti(
      {/* required List<NotificationItem> notificationList */ required int
          quantity,
      required List<NotificationItem> listSelected}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$quantity ${'5252'.tr()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isSelectNotifier,
          builder: (context, value, child) => TextButton(
            child: Text(
              _isSelectNotifier.value ? '5268'.tr() : '5267'.tr(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: colors.defaultColor),
            ),
            onPressed: () {
              _isSelectNotifier.value = !_isSelectNotifier.value;
              listSelected.isNotEmpty
                  ? {notificationBloc.add(NotificationUnCheckedMultiple())}
                  : {};
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsBottom(
      {required List<NotificationItem> listSelected, required bool isRead}) {
    return ValueListenableBuilder(
      valueListenable: _isSelectNotifier,
      builder: (context, value, child) => _isSelectNotifier.value
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: listSelected.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              notificationBloc.add(NotificationUpdateAll(
                                  generalBloc: generalBloc));
                            },
                            child: Text('5266'.tr(),
                                style: _buildTextStyleBTN(enable: isRead))),
                        TextButton(
                            onPressed: () {
                              _showConfirmDialog(context, onOk: () {
                                notificationBloc.add(NotificationDeleteAll(
                                    generalBloc: generalBloc));
                              }, text: '5553');
                            },
                            child:
                                Text('5265'.tr(), style: _buildTextStyleBTN())),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: isRead
                                ? () {
                                    notificationBloc.add(
                                        NotificationUpdateMultiple(
                                            generalBloc: generalBloc));
                                  }
                                : null,
                            child: Text(
                                '${'5264'.tr()} (${listSelected.length})',
                                style: _buildTextStyleBTN(enable: isRead))),
                        TextButton(
                            onPressed: () {
                              _showConfirmDialog(context, onOk: () {
                                notificationBloc.add(NotificationDeleteMultiple(
                                    generalBloc: generalBloc));
                              },
                                  text:
                                      '${'5554'.tr()} ${listSelected.length} ${'5555'.tr()}');
                            },
                            child: Text(
                                '${'5263'.tr()} (${listSelected.length})',
                                style: _buildTextStyleBTN())),
                      ],
                    ),
            )
          : const SizedBox(),
    );
  }

  _showConfirmDialog(BuildContext context,
          {required VoidCallback onOk, required String text}) =>
      AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              dialogType: DialogType.question,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(text.tr()),
              ),
              btnCancelText: "26".tr(),
              btnCancelColor: Colors.blue,
              btnCancelOnPress: () {
                // Navigator.pop(context);
              },
              btnOkText: '5263'.tr(),
              btnOkColor: colors.textRed,
              btnOkOnPress: onOk)
          .show();

  TextStyle _buildTextStyleBTN({bool? enable}) {
    return TextStyle(color: enable ?? true ? colors.defaultColor : Colors.grey);
  }
}
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});

//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }

// class _NotificationViewState extends State<NotificationView> {
//   final ValueNotifier _isSelectNotifier = ValueNotifier(false);

//   late GeneralBloc generalBloc;
//   late NotificationBloc notificationBloc;
//   @override
//   void initState() {
//     generalBloc = BlocProvider.of(context);
//     notificationBloc = BlocProvider.of<NotificationBloc>(context);
//     notificationBloc.add(NotificationViewLoaded(generalBloc: generalBloc));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context, globalApp.countNotification),
//         ),
//         title: Text('5252'.tr()),
//       ),
//       body: BlocConsumer<NotificationBloc, NotificationState>(
//         listener: (context, state) {
//           if (state is NotificationUpdateSuccessfully) {
//             notificationBloc
//                 .add(NotificationViewLoaded(generalBloc: generalBloc));
//           }
//           if (state is NotificationFailure) {
//             CustomDialog().error(context, err: state.message);
//           }
//         },
//         builder: (context, state) {
//           if (state is NotificationSuccess) {
//             //check data
//             final listSelected = state.notificationList
//                 .where((element) => element.isSelected == true)
//                 .toList();
//             final isRead = (listSelected.isEmpty &&
//                         state.notificationList
//                             .where((element) =>
//                                 element.finalStatusMessage == 'NEW')
//                             .toList()
//                             .isNotEmpty ||
//                     listSelected.isNotEmpty &&
//                         listSelected
//                             .where((element) =>
//                                 element.isSelected == true &&
//                                 element.finalStatusMessage == 'NEW')
//                             .toList()
//                             .isNotEmpty)
//                 ? true
//                 : false;
//             return state.notificationList.isNotEmpty
//                 ? Column(
//                     children: [
//                       _buildCountNoti(
//                           notificationList: state.notificationList,
//                           listSelected: listSelected),
//                       _buildListNoti(notificationList: state.notificationList),
//                       _buildOptionsBottom(
//                           listSelected: listSelected, isRead: isRead)
//                     ],
//                   )
//                 : const EmptyWidget();
//           }
//           return const ItemLoading();
//         },
//       ),
//     );
//   }

//   Widget _buildCountNoti(
//       {required List<NotificationItem> notificationList,
//       required List<NotificationItem> listSelected}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '${notificationList.length} ${'5252'.tr()}',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         ValueListenableBuilder(
//           valueListenable: _isSelectNotifier,
//           builder: (context, value, child) => TextButton(
//             child: Text(
//               _isSelectNotifier.value ? '5268'.tr() : '5267'.tr(),
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, color: colors.defaultColor),
//             ),
//             onPressed: () {
//               _isSelectNotifier.value = !_isSelectNotifier.value;
//               listSelected.isNotEmpty
//                   ? {notificationBloc.add(NotificationUnCheckedMultiple())}
//                   : {};
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildListNoti({required List<NotificationItem> notificationList}) {
//     return Expanded(
//       child: Scrollbar(
//         thumbVisibility: true,
//         child: ValueListenableBuilder(
//           valueListenable: _isSelectNotifier,
//           builder: (context, value, child) => RefreshIndicator(
//             onRefresh: () async {
//               notificationBloc
//                   .add(NotificationViewLoaded(generalBloc: generalBloc));
//             },
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: notificationList.length,
//               itemBuilder: (context, index) {
//                 final item = notificationList[index];
//                 return InkWell(
//                   onTap: _isSelectNotifier.value
//                       ? () {
//                           notificationBloc.add(NotificationChecked(
//                               reqId: item.reqId ?? 0,
//                               isChecked: item.isSelected != null
//                                   ? !item.isSelected!
//                                   : true));
//                         }
//                       : () {
//                           notificationBloc.add(NotificationUpdateStatus(
//                               generalBloc: generalBloc,
//                               templateId: item.templateId ?? 0,
//                               status: constants.inboxRead,
//                               reqIds: item.reqId.toString()));
//                         },
//                   child: ColoredBox(
//                       color: item.finalStatusMessage == 'NEW'
//                           ? colors.bgDrawerColor
//                           : Colors.white,
//                       child: Row(
//                         children: [
//                           _isSelectNotifier.value
//                               ? Checkbox(
//                                   activeColor: colors.defaultColor,
//                                   value: item.isSelected ?? false,
//                                   onChanged: (value) {
//                                     notificationBloc.add(NotificationChecked(
//                                         reqId: item.reqId ?? 0,
//                                         isChecked: value!));
//                                   })
//                               : const SizedBox(),
//                           Expanded(
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 8),
//                               leading: DecoratedBox(
//                                   decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.grey.withOpacity(0.4),
//                                             spreadRadius: 3,
//                                             blurRadius: 3,
//                                             offset: const Offset(0, 3)),
//                                       ],
//                                       shape: BoxShape.circle,
//                                       color: Colors.white),
//                                   child: const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Icon(
//                                         Icons.notifications,
//                                         color: Colors.amber,
//                                         size: 36,
//                                       ))),
//                               title: RichText(
//                                   text: TextSpan(children: [
//                                 TextSpan(
//                                     text: '${item.requestTitle ?? ''} ',
//                                     style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: colors.textBlack)),
//                                 TextSpan(
//                                     text: item.requestMessage,
//                                     style: const TextStyle(
//                                         fontSize: 15, color: colors.textBlack)),
//                               ])),
//                               subtitle: Text(
//                                 FormatDateConstants.convertddMMyyyyHHmm(
//                                     item.requestDate!),
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionsBottom(
//       {required List<NotificationItem> listSelected, required bool isRead}) {
//     return ValueListenableBuilder(
//       valueListenable: _isSelectNotifier,
//       builder: (context, value, child) => _isSelectNotifier.value
//           ? Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: listSelected.isEmpty
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                             onPressed: () {
//                               notificationBloc.add(NotificationUpdateAll(
//                                   generalBloc: generalBloc));
//                             },
//                             child: Text('5266'.tr(),
//                                 style: _buildTextStyleBTN(enable: isRead))),
//                         TextButton(
//                             onPressed: () {
//                               notificationBloc.add(NotificationDeleteAll(
//                                   generalBloc: generalBloc));
//                             },
//                             child:
//                                 Text('5265'.tr(), style: _buildTextStyleBTN())),
//                       ],
//                     )
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                             onPressed: isRead
//                                 ? () {
//                                     notificationBloc.add(
//                                         NotificationUpdateMultiple(
//                                             generalBloc: generalBloc));
//                                   }
//                                 : null,
//                             child: Text('5264'.tr(),
//                                 style: _buildTextStyleBTN(enable: isRead))),
//                         TextButton(
//                             onPressed: () {
//                               notificationBloc.add(NotificationDeleteMultiple(
//                                   generalBloc: generalBloc));
//                             },
//                             child:
//                                 Text('5263'.tr(), style: _buildTextStyleBTN())),
//                       ],
//                     ),
//             )
//           : const SizedBox(),
//     );
//   }

//   TextStyle _buildTextStyleBTN({bool? enable}) {
//     return TextStyle(color: enable ?? true ? colors.defaultColor : Colors.grey);
//   }
// }
