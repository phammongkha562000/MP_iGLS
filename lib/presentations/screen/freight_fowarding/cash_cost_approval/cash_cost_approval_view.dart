import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/freight_fowarding/cash_cost_approval/cash_cost_approval_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/cash_cost_appoval/cost_approval_response.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/radio_common.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/login/user.dart';
import '../../../widgets/app_bar_custom.dart';

class CashCostAppovalView extends StatefulWidget {
  const CashCostAppovalView({super.key});

  @override
  State<CashCostAppovalView> createState() => _CashCostAppovalViewState();
}

late CashCostApprovalBloc _bloc;
late GeneralBloc generalBloc;
final ScrollController _scrollController = ScrollController();

class _CashCostAppovalViewState extends State<CashCostAppovalView> {
  final _filterNotifer = ValueNotifier<String>('');
  final _navigationService = getIt<NavigationService>();
  bool isEnable = false;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<CashCostApprovalBloc>(context);
    _bloc.add(CashCostApprovalViewLoaded(
        date: DateTime.now(), tradeType: '', generalBloc: generalBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(CashCostApprovalPaging(
            userInfo: generalBloc.generalUserInfo ?? UserInfo()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4779'.tr()),
      ),
      body: BlocConsumer<CashCostApprovalBloc, CashCostApprovalState>(
        listener: (context, state) {
          if (state is CashCostApprovalSuccess) {
            if (state.isSuccess == true) {
              CustomDialog().success(context);
            } else if (state.isSuccess == false) {
              CustomDialog().error(context);
            }
          }
          if (state is CashCostApprovalFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is CashCostApprovalSuccess) {
            isEnable = state.cashCostList.isEmpty ? false : true;

            _filterNotifer.value = state.tradeType;
            return Column(
              children: [
                Expanded(
                  child: PickDatePreviousNextWidget(
                    quantityText: '${state.cashCostList.length}',
                    onTapPrevious: () {
                      _bloc.add(CashCostApprovalPreviousDateLoaded(
                          generalBloc: generalBloc));
                    },
                    onTapPick: (selectDate) {
                      _bloc.add(CashCostApprovalPickDate(
                        generalBloc: generalBloc,
                        date: selectDate,
                      ));
                    },
                    onTapNext: () {
                      _bloc.add(CashCostApprovalNextDateLoaded(
                          generalBloc: generalBloc));
                    },
                    stateDate: state.date,
                    childFilter: ValueListenableBuilder(
                        valueListenable: _filterNotifer,
                        builder: (context, value, child) {
                          return _buildGroupRadio(
                            groupValue: _filterNotifer.value,
                          );
                        }),
                    child: Expanded(
                      child: state.cashCostList.isEmpty
                          ? const Center(child: EmptyWidget())
                          : ListView.builder(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return _buildContent(
                                  item: state.cashCostList[index],
                                  indexParent: index,
                                );
                              },
                              itemCount: state.cashCostList.isNotEmpty
                                  ? state.cashCostList.length
                                  : 0,
                            ),
                    ),
                  ),
                ),
                const HeightSpacer(height: 0.03),
                Expanded(
                    flex: -1,
                    child: isEnable ? _buildBtnUpdate() : const SizedBox())
              ],
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildBtnUpdate() => ElevatedButtonWidget(
        isPaddingBottom: true,
        onPressed: () {
          _bloc.add(CashCostApprovalUpdate(generalBloc: generalBloc));
        },
        text: '5078',
      );

  Widget _buildContent(
          {required CashCostApprovalResult item, required int indexParent}) =>
      CardCustom(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: <Color>[
                            colors.defaultColor,
                            Colors.blue.shade100
                          ])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            NumberFormatter.numberFormatter(item.total!)
                                .toString(),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textBlack,
                                fontSize: 16),
                          ),
                        ],
                      ).paddingAll(8.w))),
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: item.itemGroup != null ? item.itemGroup!.length : 0,
            itemBuilder: (context, index) => _buildContentItem(
                itemList: item.itemGroup!,
                index: index,
                indexParent: indexParent),
          )
        ]),
      );
  Widget _buildContentItem(
          {required List<List<CashCostApproval>> itemList,
          required int index,
          required int indexParent}) =>
      InkWell(
        onTap: () => _navigationService.pushNamed(
            routes.cashCostAppovalDetailRoute,
            args: {key_params.cashCostApproval: itemList[index]}),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                    visualDensity: const VisualDensity(horizontal: -4),
                    activeColor: colors.defaultColor,
                    value: itemList[index].last.isSelected ?? false,
                    onChanged: (value) {
                      _bloc.add(CashCostApprovalSelected(
                          cashCostList: itemList[index]
                              .where((element) =>
                                  element.carrierBcNo ==
                                  itemList[index][0].carrierBcNo)
                              .toList(),
                          index: indexParent,
                          isSelected: value!));
                    }),
              ),
              Expanded(
                  flex: 2, child: Text(itemList[index][0].contactCode ?? '')),
              Expanded(
                  flex: 3,
                  child: Text(
                    itemList[index][0].carrierBcNo!.isNotEmpty
                        ? itemList[index][0].carrierBcNo!
                        : itemList[index][0].blNo!,
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    itemList[index][0].cargoMode! == 'FCL'
                        ? itemList[index].length.toString()
                        : itemList[index][0].cargoMode!,
                    textAlign: TextAlign.center,

                    //không hiêu tại sao là số 1
                  )),
              Expanded(
                  flex: 3,
                  child: Text(
                    NumberFormatter.numberFormatter(
                            total(cashCostList: itemList[index]))
                        .toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );

  double total({required List<CashCostApproval> cashCostList}) {
    double total = 0;
    for (var element in cashCostList) {
      total += element.amount!;
    }
    return total;
  }

  Widget _buildGroupRadio({required String groupValue}) {
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRadioBtn(title: '5059', value: '', groupValue: groupValue),
          _buildRadioBtn(title: '5079', value: 'I', groupValue: groupValue),
          _buildRadioBtn(title: '5080', value: 'E', groupValue: groupValue)
        ],
      );
    }
  }

  Widget _buildRadioBtn(
          {required String title,
          required String value,
          required String groupValue}) =>
      Expanded(
        child: RadioCommon(
            title: title,
            value: value,
            groupValue: groupValue,
            onChanged: (value) => _bloc.add(CashCostApprovalPickDate(
                tradeType: value, generalBloc: generalBloc))),
      );
}
