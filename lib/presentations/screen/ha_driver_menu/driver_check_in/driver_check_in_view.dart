import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/ha_driver_menu/driver_check_in/driver_check_in_bloc.dart';
import 'package:igls_new/data/shared/mixin/alert.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class DriverCheckInView extends StatefulWidget {
  const DriverCheckInView({super.key});

  @override
  State<DriverCheckInView> createState() => _DriverCheckInViewState();
}

class _DriverCheckInViewState extends State<DriverCheckInView> with Alert {
  final _tractorController = TextEditingController();
  final _driverIdController = TextEditingController();
  final _dateTimeController = TextEditingController();
  late GeneralBloc generalBloc;
  late DriverCheckInBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<DriverCheckInBloc>(context);
    _bloc.add(DriverCheckInViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('4673'.tr())),
      body: BlocListener<DriverCheckInBloc, DriverCheckInState>(
        listener: (context, state) {
          if (state is DriverCheckInSuccess) {
            if (state.isSuccess == true) {
              CustomDialog().success(context);
            }
          }
          if (state is DriverCheckInFailure) {
            if (state.errorCode == constants.errorNullEquipDriverId) {
              CustomDialog().error(
                context,
                err: state.message,
                btnOkOnPress: () => Navigator.of(context).pop(),
              );

              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<DriverCheckInBloc, DriverCheckInState>(
          builder: (context, state) {
            if (state is DriverCheckInSuccess) {
              _tractorController.text = state.tractor;
              _driverIdController.text = state.driverId;
              _dateTimeController.text =
                  state.dateTime != null ? state.dateTime ?? '' : '';
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _heightSpacer(),
                          _row(
                              title: '5044'.tr(),
                              controller: _dateTimeController),
                          _heightSpacer(),
                          _row(
                              title: '4011'.tr(),
                              controller: _tractorController),
                          _heightSpacer(),
                          _row(
                              title: '2499'.tr(),
                              controller: _driverIdController),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: -1,
                    child: ElevatedButtonWidget(
                      isPaddingBottom: true,
                      borderRadius: 32,
                      backgroundColor:
                          state.dateTime == '' || state.dateTime == null
                              ? null
                              : colors.btnGreyDisable,
                      onPressed: state.dateTime == '' || state.dateTime == null
                          ? () => _bloc.add(
                              DriverCheckInUpdate(generalBloc: generalBloc))
                          : null,
                      text: state.dateTime == '' || state.dateTime == null
                          ? '5589'
                          : "2384",
                    ),
                  )
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _row(
          {required String title, required TextEditingController controller}) =>
      RowFlex3and7(
        child3: Text(
          title,
          style: styleTextTitle,
        ),
        child7: TextField(
          controller: controller,
          enabled: false,
          decoration: const InputDecoration(
            fillColor: colors.textWhite,
            filled: true,
          ),
        ),
      );
  HeightSpacer _heightSpacer() => const HeightSpacer(height: 0.03);
}
