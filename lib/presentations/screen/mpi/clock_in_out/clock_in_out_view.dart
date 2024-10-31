import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/clock_in_out/clock_in_out_bloc.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';

class ClockInOutView extends StatefulWidget {
  const ClockInOutView({super.key});

  @override
  State<ClockInOutView> createState() => _ClockInOutViewState();
}

class _ClockInOutViewState extends State<ClockInOutView> {
  late ClockInOutBloc _bloc;
  late GeneralBloc generalBloc;
  String _timeString = '';
  Timer? _timer;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<ClockInOutBloc>(context);
    _bloc.generalBloc = generalBloc;
    _bloc.add(ClockInOutViewLoaded());
    _timeString = _formatCurrentTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _timeString = _formatCurrentTime();
    });
  }

  String _formatCurrentTime() {
    final DateTime now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  Color primaryColor = colors.defaultColor;
  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5759'.tr()),
      ),
      body: BlocConsumer<ClockInOutBloc, ClockInOutState>(
          listener: (context, state) {
        if (state is ClockInOutSuccessfully) {
          CustomDialog().success(context);
        }

        if (state is ClockInOutFailure) {
          // if (state.errorCode != null) {
          /* switch (state.errorCode) {
                      case MyError.errCodeNoInternet:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message,
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {
                              clockInOutBloc
                                  .add(ClockInOutViewLoaded(appBloc: appBloc));
                            });
                        break;
                      case MyError.errCodeDevice:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message,
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {});
                        break;

                      case MyError.errCodeLocation:
                        MyDialog.showWarning(
                            context: context,
                            message: state.message,
                            pressOk: () {
                              Navigator.pop(context);
                            },
                            turnOffCancel: true,
                            whenComplete: () {});
                        break;
                      case MyError.errCodeEnableLocation:
                        MyDialog.showWarning(
                          context: context,
                          pressOk: () async {
                            LocationHelper.settingLocation();
                            Navigator.pop(context);
                          },
                          turnOffCancel: true,
                          message: state.message.tr(),
                          whenComplete: () async {
                            _navigationService.pushNamed(MyRoute.homePageRoute);
                          },
                        );
                        break;

                      default:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message.toString(),
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {});
                    } */
          CustomDialog().error(context, err: state.message, btnOkOnPress: () {
            // Navigator.of(context).pop();
            _bloc.add(ClockInOutViewLoaded());
          });
        }
      }, builder: (context, state) {
        if (state is ClockInOutSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBtn(type: 0),
              _buildClock(),
              _buildBtn(type: 1),

              // Expanded(
              //   child: Center(
              //     child: DecoratedBox(
              //       decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(
              //               color: Color(0xff6A2E2A),
              //               style: BorderStyle.solid)),
              //       child: Container(
              //         margin: EdgeInsets.all(16),
              //         width: 150,
              //         height: 150,
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           gradient: RadialGradient(
              //             // Bạn có thể dùng LinearGradient nếu muốn
              //             colors: [
              //               Color(0xff6A2E2A), // Màu kết thúc
              //               Color(0xcc6A2E2A), // Màu bắt đầu
              //             ],
              //             center: Alignment.center, // Tâm của gradient
              //             radius: 0.8, // Độ phủ gradient
              //           ),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Color(0xff6A2E2A)
              //                   .withOpacity(0.7), // Màu của đổ bóng (có độ mờ)
              //               spreadRadius: 10, // Mức độ lan của đổ bóng
              //               blurRadius: 10, // Độ mờ của đổ bóng
              //               offset: Offset(
              //                   0, 4), // Độ dịch chuyển của đổ bóng (X, Y)
              //             ),
              //           ],
              //         ),
              //         child: Text(
              //           'Clock out'.toUpperCase(),
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w900,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          );
        }
        return const ItemLoading();
      }),
    );
  }

  Widget _buildBtn({required int type}) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () {
            log(type.toString());
            _bloc.add(ClockInOutUpdate(type: type));
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width / 1.5,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64.r),
              color: colors.defaultColor,

              // shape: BoxShape.circle,
              /* gradient: RadialGradient(
                // Bạn có thể dùng LinearGradient nếu muốn
                colors: [
                  type == 0
                      ? Color(0xff62b235)
                      : Color(0xff6A2E2A), // Màu kết thúc
                  type == 0
                      ? Color(0xcc62b235)
                      : Color(0xcc6A2E2A), // Màu bắt đầu
                ],
                center: Alignment.center, // Tâm của gradient
                radius: 0.8, // Độ phủ gradient
              ), */
            ),
            child: Text(
              type == 0 ? '5675'.tr().toUpperCase() : '5676'.tr().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClock() {
    return /*  Container(
        width: MediaQuery.sizeOf(context).width / 2,
        height: 80.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //       color: primaryColor,
            //       blurRadius: 10.0,
            //       spreadRadius: 5.0,
            //       offset: const Offset(1.0, 1.0))
            // ],
            color: Colors.white,
            // border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(16.r)),
        child: */
        Text(
      _timeString,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(
            offset: Offset(3.0, 3.0), // Khoảng cách đổ bóng
            blurRadius: 5.0, // Độ mờ của bóng
            color: Colors.grey, // Màu của bóng
          ),
        ],
      ),
    ) /* ) */;
  }
}
