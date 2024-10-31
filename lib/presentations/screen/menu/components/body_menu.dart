import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/home/frequently_visit_page_response.dart';

import 'package:igls_new/data/models/login/menu_response.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/export_common.dart';
import 'package:igls_new/presentations/screen/home/get_image_item_menu.dart';
import 'package:igls_new/presentations/widgets/export_widget.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class BodyMenu extends StatefulWidget {
  const BodyMenu({
    super.key,
    required this.listPermission,
  });
  final List<List<PageMenuPermissions>> listPermission;
  @override
  State<BodyMenu> createState() => _BodyMenuState();
}

final _navigationService = getIt<NavigationService>();

Map<String, String> mapNavigatePushRemove = {
  constants.caseDriverProfile: routes.driverProfileRoute
};
Map<String, String> mapNavigate = {
  constants.caseTaskHistory: routes.taskHistoryRoute,
  constants.caseDriverCheckIn: routes.driverCheckInRoute,
  constants.caseTodoFreightForwarding: routes.toDoHaulageRoute,
  constants.caseToDoLocalDistribution: routes.toDoTripRoute,
  constants.caseSetting: routes.settingRoute,
  constants.caseInboundPhoto: routes.inboundPhotoRoute,
  constants.caseSiteTrailer: routes.siteTrailerRoute,
  constants.caseStockCount: routes.stockCountRoute,
  constants.caseRelocation: routes.relocationRoute,
  constants.caseCashCostAppoval: routes.cashCostAppovalRoute,
  constants.caseInventory: routes.inventoryRoute,
  constants.caseGoodsReceipt: routes.goodsReceiptRoute,
  constants.caseHaulageActivity: routes.haulageActivityTRoute,
  constants.caseHistoryTodo: routes.historyTodoRoute,
  constants.caseDriverClosingHistory: routes.driverClosingHistoryRoute,
  constants.caseRepairRequest: routes.repairRequestRoute,
  constants.caseShuttleTrip: routes.shuttleTripRoute,
  constants.casePalletRelocation: routes.palletRelocationRoute,
  constants.caseDriverSalary: routes.driverSalaryRoute,
  constants.caseDeliveryStatus: routes.driverStatusRoute,
  constants.caseStaffs: routes.staffsRoute,
  constants.caseEquipments: routes.equipmentsRoute,
  constants.caseUsers: routes.usersRoute,
  constants.casePutAway: routes.addPutAwayRoute /* putAwayRoute */,
  constants.casePicking: routes.pickingRoute,
  constants.caseSiteStockCheck: routes.siteStockCheckRoute,
  constants.caseMPiCheckInOut: routes.mpiClockInOutRoute,
  constants.caseMPiTimesheet: routes.mpiTimesheetsRoute,
};

class _BodyMenuState extends State<BodyMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: widget.listPermission.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            /* getTitleMenuByMenuID(
                    menuId: widget.listPermission[index].first.parentsMenu!)
                .trim() */
            '${widget.listPermission[index].first.parentsMenuTId}'.tr(),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colors.defaultColor),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: colors.textWhite,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index2) {
                final quickMenu = FrequentlyVisitPageResponse(
                  menuName: widget.listPermission[index][index2].menuName,
                  pageId: widget.listPermission[index][index2].pageId,
                  pageName: widget.listPermission[index][index2].pageName,
                  tagVariant: widget.listPermission[index][index2].tagVariant,
                  termDic: '',
                  visit: 1,
                );
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4.h),
                  child: _itemChild(
                      text: widget.listPermission[index][index2].menuId
                          .toString(),
                      icon: widget.listPermission[index][index2].tagVariant
                          .toString(),
                      route: widget.listPermission[index][index2].tagVariant!,
                      pageId: widget.listPermission[index][index2].pageId!,
                      pageName: widget.listPermission[index][index2].pageName!,
                      quickMenu: quickMenu,
                      tId: widget.listPermission[index][index2].tId ?? 0),
                );
              },
              itemCount: widget.listPermission[index].length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChild(
          {required String text,
          required String icon,
          required String route,
          required FrequentlyVisitPageResponse quickMenu,
          required String pageId,
          required String pageName,
          required int tId}) =>
      ListTile(
        onTap: () {
          log(route);
          voidCallBack(
            context,
            path: route,
            pageId: pageId,
            pageName: pageName,
          );
        },
        leading: getImage(icon, sizeIcon: 24),
        trailing: const Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.blue,
          size: 20,
        ),
        title: Text(
          '$tId'.tr() /* getTitleMenuByMenuID(menuId: text).tr() */,
          style: const TextStyle(
            color: textDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}

voidCallBack(
  context, {
  required String path,
  required String pageId,
  required String pageName,
}) {
  switch (path) {
    case constants.caseDriverProfile:
      return _onNavigateDriverProfile(context);

    // case constants.caseManualDriverClosing:
    //   return _onNavigateManualDriverClosing(
    //     context,
    //   );

    case constants.caseLoadingStatus:
      return _onNavigateLoadingStatus(context);
    case constants.caseMPiLeave:
      return _onNavigateMPiLeave(context);
    default:
      return mapNavigate[path] == null
          ? showUpdateLater(context).show()
          : _navigationService.pushNamed(mapNavigate[path] ?? '');
  }
}

AwesomeDialog showUpdateLater(context) {
  return AwesomeDialog(
    dialogType: DialogType.info,
    btnOkColor: colors.textGreen,
    btnOkOnPress: () {},
    context: context,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const HeightSpacer(height: 0.01),
        Text(
          "5251".tr(),
          style: styleTextTitle,
        ),
        const HeightSpacer(height: 0.01),
      ],
    ),
  );
}

void _onNavigateDriverProfile(BuildContext context) {
  _navigationService.pushNamed(routes.driverProfileRoute);
}

// void _onNavigateManualDriverClosing(
//   BuildContext context,
// ) {
//   _navigationService
//       .pushNamed(routes.manualDriverClosingRoute, args: {key_params.dDCId: 0});
// }

void _onNavigateLoadingStatus(BuildContext context) {
  _navigationService.pushNamed(routes.loadingStatusRoute,
      args: {key_params.etpLoadingStatus: DateTime.now()});
}

void _onNavigateMPiLeave(BuildContext context) {
  _navigationService
      .pushNamed(routes.mpiLeaveRoute, args: {key_params.isAddLeave: false});
}
