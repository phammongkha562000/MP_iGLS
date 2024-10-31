import 'package:flutter/material.dart';

import '../../widgets/icon_custom.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/constants.dart' as constants;

StatelessWidget getImage(String component, {double? sizeIcon}) {
  switch (component) {
    //Freight Fowarding
    case constants.caseHaulageActivity:
      return IconCustom(iConURL: assets.mActivity, size: sizeIcon ?? 24);
    case constants.caseCashCostAppoval:
      return IconCustom(
          iConURL: assets.mCashCostApproval, size: sizeIcon ?? 24);
    case constants.caseSiteStockCheck:
      return IconCustom(iConURL: assets.mSiteList, size: sizeIcon ?? 24);
    case constants.caseSiteTrailer:
      return IconCustom(iConURL: assets.mSiteTrailer, size: sizeIcon ?? 24);
    case constants.caseShipmentStatus:
      return IconCustom(iConURL: assets.mShipment, size: sizeIcon ?? 24);
    //HA DRIVER MENU
    case constants.caseTodoFreightForwarding:
      return IconCustom(iConURL: assets.mDashboard, size: sizeIcon ?? 24);
    case '/paymentslip':
      return IconCustom(iConURL: assets.mSalary, size: sizeIcon ?? 24);
    case constants.casePlanTransfer:
      return IconCustom(iConURL: assets.mPlanTranfer, size: sizeIcon ?? 24);
    case constants.caseTaskHistory:
      return IconCustom(iConURL: assets.mTaskHistory, size: sizeIcon ?? 24);
    case constants.caseDriverCheckIn:
      return IconCustom(iConURL: assets.mDriverCheckin, size: sizeIcon ?? 24);
    case '/driverleavedate':
      return IconCustom(iConURL: assets.mDriverLeaveDate, size: sizeIcon ?? 24);
    case constants.caseDriverProfile:
      return IconCustom(iConURL: assets.mDriverProfile, size: sizeIcon ?? 24);
    case constants.caseStockCount:
      return IconCustom(iConURL: assets.stockCount, size: sizeIcon ?? 24);
    case constants.caseRelocation:
      return IconCustom(iConURL: assets.relocation, size: sizeIcon ?? 24);
    case "/driverdashboard":
      return IconCustom(iConURL: assets.mnDashboard, size: sizeIcon ?? 24);
    case constants.caseInventory:
      return IconCustom(iConURL: assets.mnInventory, size: sizeIcon ?? 24);
    case constants.caseGoodsReceipt:
      return IconCustom(iConURL: assets.mnGoodsReceipt, size: sizeIcon ?? 24);
    case constants.casePutAway:
      return IconCustom(iConURL: assets.mnPutAway, size: sizeIcon ?? 24);
    case constants.casePicking:
      return IconCustom(iConURL: assets.mnPicking, size: sizeIcon ?? 24);
    case constants.caseInboundPhoto:
      return IconCustom(iConURL: assets.mnInboundphoto, size: sizeIcon ?? 24);
    case constants.casePalletRelocation:
      return IconCustom(iConURL: assets.mnPaletLocation, size: sizeIcon ?? 24);
    case constants.caseTripRecord:
      return IconCustom(iConURL: assets.mnTripRecord, size: sizeIcon ?? 24);
    case constants.caseToDoLocalDistribution:
      return IconCustom(iConURL: assets.mnTodo, size: sizeIcon ?? 24);
    case constants.caseHistoryTodo:
      return IconCustom(iConURL: assets.mnHistoryTodo, size: sizeIcon ?? 24);
    case constants.casePickUpDelivery:
      return IconCustom(iConURL: assets.mnPickupDelivery, size: sizeIcon ?? 24);
    case constants.caseLoadingStatus:
      return IconCustom(iConURL: assets.mnLoadingStatus, size: sizeIcon ?? 24);
    case constants.caseShuttleTrip:
      return IconCustom(iConURL: assets.mnShuttleTrip, size: sizeIcon ?? 24);
    case constants.caseReceiptPackage:
      return IconCustom(iConURL: assets.mnReceipt, size: sizeIcon ?? 24);
    case constants.caseTransferPackage:
      return IconCustom(iConURL: assets.mnTransfer, size: sizeIcon ?? 24);
    case constants.caseReleasePackage:
      return IconCustom(iConURL: assets.mnRelease, size: sizeIcon ?? 24);

    case constants.caseSetting:
      return IconCustom(iConURL: assets.setting, size: sizeIcon ?? 24);
    default:
      return IconCustom(iConURL: assets.kIconTruck, size: sizeIcon ?? 24);
  }
}
