import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:igls_new/data/models/freight_fowarding/cash_cost_appoval/cost_approval_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/widgets/widgets.dart';

import '../../../widgets/app_bar_custom.dart';

class CashCostApprovalDetailView extends StatefulWidget {
  const CashCostApprovalDetailView({
    super.key,
    required this.detailList,
  });
  final List<CashCostApproval> detailList;
  @override
  State<CashCostApprovalDetailView> createState() =>
      _CashCostApprovalDetailViewState();
}

final _navigationService = getIt<NavigationService>();

class _CashCostApprovalDetailViewState
    extends State<CashCostApprovalDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5081'.tr())),
      body: SingleChildScrollView(
        child: Column(children: [
          const HeightSpacer(height: 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.02,
            ),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                    colors.defaultColor,
                    Colors.blue.shade100
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      /* widget.detailList.first.approvalUser ??  */ '',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumberFormatter.numberFormatter(
                              _total(list: widget.detailList))
                          .toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.textBlack,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CardCustom(
              child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.detailList[0].contactCode ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.detailList[0].blNo!.isNotEmpty
                            ? widget.detailList[0].blNo!
                            : widget.detailList[0].carrierBcNo!,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        NumberFormatter.numberFormatter(
                                _total(list: widget.detailList))
                            .toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              const HeightSpacer(height: 0.01),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.detailList.length,
                itemBuilder: (context, index) =>
                    _buildItem(item: widget.detailList[index]),
              ),
            ],
          )),
        ]),
      ),
    );
  }

  double _total({required List<CashCostApproval> list}) {
    double total = 0;
    for (var element in list) {
      total += element.amount!;
    }
    return total;
  }

  Widget _buildItem({required CashCostApproval item}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () =>
            _navigationService.pushNamed(routes.takePictureRoute, args: {
          key_params.titleGalleryTodo: item.woNo,
          key_params.refNoValue: item.docId.toString(),
          key_params.refNoType: "COSWO",
          key_params.docRefType: "COSWO",
          key_params.allowEdit: false,
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.equipmentNo ?? '')),
              Expanded(flex: 3, child: Text(item.accountDesc ?? '')),
              Expanded(
                  flex: 3,
                  child: Text(
                    NumberFormatter.numberFormatter(item.amount!).toString(),
                    textAlign: TextAlign.right,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
