import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:igls_new/businesses_logics/bloc/ha_driver_menu/plan_transfer/plan_transfer_bloc.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';

class PlanTransferView extends StatefulWidget {
  const PlanTransferView({
    super.key,
    required this.task,
  });
  final HaulageToDoDetail task;

  @override
  State<PlanTransferView> createState() => _PlanTransferViewState();
}

class _PlanTransferViewState extends State<PlanTransferView> {
  final _tractorController = TextEditingController();
  final _navigationService = getIt<NavigationService>();

  final _formKey = GlobalKey<FormState>();
  late GeneralBloc generalBloc;
  late PlanTransferBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<PlanTransferBloc>(context);
    _bloc.add(PlanTransferLoaded(task: widget.task, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("Plan Transfer".tr()),
      ),
      body: BlocListener<PlanTransferBloc, PlanTransferState>(
        listener: (context, state) {
          if (state is PlanTransferLoading) {
            CustomDialog().showCustomDialog(context);
            return;
          } else if (state is PlanTransferSuccess) {
            CustomDialog().hideCustomDialog(context);
            if (state.isSuccess == true) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                showToastWidget(
                  const SuccessToast(),
                  position: StyledToastPosition.top,
                  animation: StyledToastAnimation.slideFromRightFade,
                  context: context,
                );
              });
              _navigationService
                  .pushNamedAndRemoveUntil(routes.toDoHaulageRoute);
            }
          }
          if (state is PlanTransferFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showToastWidget(
                ErrorToast(error: state.message),
                position: StyledToastPosition.top,
                animation: StyledToastAnimation.slideFromRightFade,
                context: context,
              );
            });
          }
        },
        child: BlocBuilder<PlanTransferBloc, PlanTransferState>(
          builder: (context, state) {
            if (state is PlanTransferSuccess) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: CardCustom(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text("Tractor".tr()),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: _tractorController,
                                    decoration: const InputDecoration(
                                        hintText: "51C12345",
                                        hintStyle: TextStyle(
                                            color: colors.btnGreyDisable)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '5067'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const HeightSpacer(height: 0.01),
                            ElevatedButtonWidget(
                              text: "Search",
                              onPressed: () {
                                log(_tractorController.text);
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<PlanTransferBloc>(context)
                                      .add(
                                    PlanTransferSearch(
                                        tractorNo: _tractorController.text,
                                        generalBloc: generalBloc),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CardCustom(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.listToDo != null
                                  ? '${'pendingTask'.tr()} (${state.listToDo!.length})'
                                  : '${'pendingTask'.tr()} (0)',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: state.listToDo != null &&
                                      state.listToDo != [] &&
                                      state.listToDo!.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      itemCount: state.listToDo!.length,
                                      itemBuilder: (context, index) =>
                                          _card(item: state.listToDo![index]),
                                    )
                                  : ListView(
                                      children: const [EmptyWidget()],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.sizeOf(context).width * 0.015),
                      child: ElevatedButtonWidget(
                          text: 'transfer',
                          onPressed: state.listToDo != null &&
                                  state.listToDo != [] &&
                                  state.listToDo!.isNotEmpty
                              ? () {
                                  BlocProvider.of<PlanTransferBloc>(context)
                                      .add(PlanTransferUpdate(
                                          priEquipment: _tractorController.text,
                                          generalBloc: generalBloc));
                                }
                              : null,
                          backgroundColor: state.listToDo != null &&
                                  state.listToDo != [] &&
                                  state.listToDo!.isNotEmpty
                              ? colors.defaultColor
                              : colors.btnGreyDisable),
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

  Widget _card({required TodoHaulageResult item}) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: Text('woNo'.tr())),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.woNo ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.contactCode ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: colors.textAmber,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const HeightSpacer(height: 0.02),
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Expanded(flex: 2, child: Text('woEquipmentMode'.tr())),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.woEquipMode ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.taskModeOrginal ?? ''}-${item.tradeType == 'E' ? TradeType.exportTradeType.toString() : TradeType.importTradeType.toString()}',
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      FormatDateConstants.convertddMMHHmm(item.taskDate ?? ''),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const HeightSpacer(height: 0.02),
              Row(
                children: [
                  Expanded(flex: 2, child: Text('EquipmentType'.tr())),
                  Expanded(
                    flex: 7,
                    child: Text(
                      item.equipmentType ?? '',
                      style: styleLeftItem(),
                    ),
                  )
                ],
              ),
              const HeightSpacer(height: 0.02),
              Row(
                children: [
                  Expanded(flex: 2, child: Text('3645'.tr())),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.cntrNo ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.woTaskStatus ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  TextStyle styleLeftItem() => const TextStyle(fontWeight: FontWeight.bold);
}
