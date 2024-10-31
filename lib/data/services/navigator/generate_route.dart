import 'package:igls_new/businesses_logics/bloc/admin/equipments/equipment_detail/equipment_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/admin/equipments/equipments/equipments_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/admin/staffs/staff_detail/staff_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/admin/staffs/staffs/staffs_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/admin/users/users/users_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contact/contact/contact_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inbound_order_status/inbound_order_status/inbound_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inbound_order_status/inbound_order_status_search/inbound_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inventory_wp/inventory_wp/inventory_wp_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inventory_wp/inventory_wp_search/inventory_wp_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status/outbound_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status_detail/outbound_order_status_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status_search/outbound_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/shuttle_overview/shuttle_overview/shuttle_overview_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status/transport_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status_detail/transport_order_status_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status_search/transport_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_overview/transport_overview/transport_overview_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_overview/transport_overview_detail_trip/transport_overview_detail_trip_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_home/customer_home_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_profile/customer_profile_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/booking/booking/booking_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/booking/booking_search/booking_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_ageing/cntr_ageing_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_haulage/cntr_haulage_detail/cntr_haulage_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_haulage/cntr_haulage_search/cntr_haulage_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily/haulage_daily_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily_cntr_detail/haulage_daily_cntr_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily_cntr_image/haulage_daily_cntr_image_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_overview/haulage_overview/haulage_overview_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_overview/haulage_overview_cntr_detail/haulage_overview_cntr_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/track_and_trace/track_and_trace/track_and_trace_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_stock/site_stock_check_detail/site_stock_check_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_stock/site_stock_check_pending/site_stock_check_pending_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer_history/site_trailer_history_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer_pending/site_trailer_pending_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/transaction_report/transaction_report/transaction_report_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/home/inbox/notification_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/picking/picking/picking_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/picking/picking_detail/picking_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/put_away/add_put_away/add_put_away_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/put_away/put_away_search/put_away_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/clock_in_out/clock_in_out_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/leave/leave_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/leave_detail/leave_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/new_leave/add_leave_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/timesheets/timesheets_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/timesheets_detail/timesheets_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/other/driver_closing_history/driver_closing_history_detail/driver_closing_history_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/setting/setting_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/inventory/barcode_tracking/barcode_tracking_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_request.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';

import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/screen/customer/contract_logistics/inbound_order_status/inbound_order_status_search_view.dart';
import 'package:igls_new/presentations/screen/customer/contract_logistics/inventory/customer_inventory_search_view.dart';
import 'package:igls_new/presentations/screen/customer/contract_logistics/outbound_order_status/outbound_order_status_search_view.dart';
import 'package:igls_new/presentations/screen/customer/global_visibility/cntr_haulage/cntr_haulage_search_view.dart';
import 'package:igls_new/presentations/screen/customer/global_visibility/cntr_haulage/cntr_haulage_view.dart';
import 'package:igls_new/presentations/screen/customer/global_visibility/haulage_daily/haulage_daily_search_view.dart';
import 'package:igls_new/presentations/screen/customer/global_visibility/haulage_overview/haulage_overview_search_view.dart';
import 'package:igls_new/presentations/screen/customer/home/customer_home_view.dart';
import 'package:igls_new/presentations/screen/customer/profile/customer_setting_profile_view.dart';
import 'package:igls_new/presentations/screen/freight_fowarding/ha_transaction_report/ha_transaction_report_view.dart';
import 'package:igls_new/presentations/screen/freight_fowarding/site_stock_check/site_stock_check_pending_view.dart';
import 'package:igls_new/presentations/screen/local_distribution/todo/todo_simple_trip_detail_view.dart';
import 'package:igls_new/presentations/screen/mpi/clock_in_out/clock_in_out_view.dart';
import 'package:igls_new/presentations/screen/mpi/leave/add_leave_view.dart';
import 'package:igls_new/presentations/screen/mpi/leave/leave_detail_view.dart';
import 'package:igls_new/presentations/screen/mpi/leave/leave_view.dart';
import 'package:igls_new/presentations/screen/mpi/timesheet/timesheet_view.dart';
import 'package:igls_new/presentations/screen/mpi/timesheet/timesheets_detail_view.dart';
import 'package:igls_new/presentations/screen/user_profile/user_profile_view.dart';
import 'package:igls_new/presentations/screen/warehouse/goods_receipt/goods_receipt_detail_view.dart';
import 'package:igls_new/presentations/screen/warehouse/goods_receipt/goods_receipt_view.dart';
import 'package:igls_new/presentations/screen/warehouse/inbound_photo/inbound_photo_view.dart';
import 'package:igls_new/presentations/screen/warehouse/inventory/barcode_tracking_view.dart';
import 'package:igls_new/presentations/screen/warehouse/inventory/inventory_view.dart';
import 'package:igls_new/presentations/screen/warehouse/inventory/inventory_view_detail.dart';
import 'package:igls_new/presentations/screen/warehouse/picking/picking_details_view.dart';
import 'package:igls_new/presentations/screen/warehouse/picking/picking_view.dart';
import 'package:igls_new/presentations/screen/warehouse/put_away/add_put_away_view.dart';
import 'package:igls_new/presentations/screen/warehouse/put_away/put_away_search_view.dart';
import 'package:igls_new/presentations/screen/warehouse/relocation/relocation_view.dart';
import 'package:igls_new/presentations/screen/warehouse/stock_count/stock_count_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.loginViewRoute:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<LoginBloc>(
                    create: (BuildContext context) =>
                        LoginBloc()..add(LoginViewLoaded()),
                  ),
                ],
                child: const LoginView(),
              ));
    case routes.homePageRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HomeBloc(),
                child: const HomePage(),
              ));
    case routes.registerRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => RegisterBloc(),
                child: const RegisterScreen(),
              ));
    case routes.notificationRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => NotificationBloc(),
              child: const NotificationView()));
    //menu home
    case routes.driverProfileRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    UserProfileBloc() /* ..add(UserProfileLoaded(pageId: pageId, pageName: pageName)) */,
                child: const UserProfileView(),
              ));
    case routes.planTransferRoute:
      final task = (settings.arguments as Map)[key_params.taskTodoHaulage];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PlanTransferBloc(),
          child: PlanTransferView(task: task),
        ),
      );
    // return MaterialPageRoute(
    //     builder: (context) => BlocProvider(
    //           create: (context) => PlanTransferBloc()
    //             ..add(PlanTransferViewLoaded(dateTime: DateTime.now())),
    //           child: const PlanTransferView(),
    //         ));
    case routes.taskHistoryRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TaskHistoryBloc(),
                child: const TaskHistoryView(),
              ));
    case routes.taskHistoryDetailRoute:
      final id = (settings.arguments as Map)[key_params.taskHistoryDetailById];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TaskHistoryDetailBloc(),
          child: TaskHistoryDetailView(id: id),
        ),
      );
    case routes.taskHistoryDetailItemRoute:
      final DailyTask dailyTask =
          (settings.arguments as Map)[key_params.dailyTask];
      // final List<ListDetail> listDetail;
      final dtdId =
          (settings.arguments as Map)[key_params.taskHistoryDetailItemByDtdId];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TaskHistoryDetailItemBloc(),
                child: TaskHistoryDetailItemView(
                    dailyTask: dailyTask, dtdId: dtdId),
              ));
    case routes.driverCheckInRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DriverCheckInBloc(),
                child: const DriverCheckInView(),
              ));
    case routes.toDoHaulageRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ToDoHaulageBloc(),
                child: const ToDoHaulageView(),
              ));
    case routes.toDoHaulageImageRoute:
      final String trailerNo =
          (settings.arguments as Map)[key_params.trailerNoImage];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TodoHaulageImageBloc(),
                child: TodoHaulageImageView(
                  trailerNo: trailerNo,
                ),
              ));
    case routes.toDoHaulageDetailRoute:
      final int woTaskId = (settings.arguments as Map)[key_params.woTaskId];
      final isPending =
          (settings.arguments as Map)[key_params.isPendingTodoHaulage];
      final wOTaskIdPending =
          (settings.arguments as Map)[key_params.wOTaskIdPending];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ToDoHaulageDetailBloc(),
                child: ToDoHaulageDetailView(
                  woTaskId: woTaskId,
                  isPending: isPending,
                  wOTaskIdPending: wOTaskIdPending,
                ),
              ));

    case routes.takePictureRoute:
      final String title =
          (settings.arguments as Map)[key_params.titleGalleryTodo];
      final refNoType = (settings.arguments as Map)[key_params.refNoType];
      final docRefType = (settings.arguments as Map)[key_params.docRefType];
      final String refNoValue =
          (settings.arguments as Map)[key_params.refNoValue];
      final allowEdit = (settings.arguments as Map)[key_params.allowEdit];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TakePictureBloc(),
                child: TakePictureView(
                  // itemId: itemId,
                  title: title,
                  refNoType: refNoType,
                  docRefType: docRefType,
                  refNoValue: refNoValue,
                  allowEdit: allowEdit,
                ),
              ));

    case routes.displayPictureRoute:
      final List<XFile>? xFiles =
          (settings.arguments as Map)[key_params.pictureFile];
      final refNoType = (settings.arguments as Map)[key_params.refNoType];
      final docRefType = (settings.arguments as Map)[key_params.docRefType];
      final refNoValue = (settings.arguments as Map)[key_params.refNoValue];
      final List<File> files =
          xFiles != null ? xFiles.map((x) => File(x.path)).toList() : [];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DisplayPictureBloc()
                  ..add(DisplayPictureViewLoaded(
                      files: files,
                      docRefType: docRefType,
                      refNoType: refNoType,
                      refNoValue: refNoValue)),
                child: const DisplayPictureView(),
              ));

    case routes.toDoTripRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ToDoTripBloc(),
                child: const ToDoTripView(
                    /* pageId: pageId, pageName: pageName */),
              ));
    case routes.toDoTripDetailRoute:
      final tripNo = (settings.arguments as Map)[key_params.tripNo];
      final isPendingTodoTrip =
          (settings.arguments as Map)[key_params.isPendingTodoTrip];
      final tripNoPending =
          (settings.arguments as Map)[key_params.tripNoPending];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TodoSimpleTripDetailBloc(),
                child: TodoSimpleTripDetailView(
                    tripNo: tripNo,
                    isPendingTrip: isPendingTodoTrip,
                    tripNoPending: tripNoPending),
              ));
    case routes.toDoNormalTripDetailRoute:
      final tripNo = (settings.arguments as Map)[key_params.tripNo];
      final isPendingTodoTrip =
          (settings.arguments as Map)[key_params.isPendingTodoTrip];
      final tripNoPending =
          (settings.arguments as Map)[key_params.tripNoPending];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ToDoNormalTripDetailBloc(),
                child: ToDoNormalTripDetailView(
                    tripNo: tripNo,
                    isPendingTrip: isPendingTodoTrip,
                    tripNoPending: tripNoPending),
              ));
    case routes.addToDoTripRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => AddTodoTripBloc(),
                child: const AddToDoTripView(
                    /* pageId: pageId, pageName: pageName */),
              ));
    case routes.editTodoTripRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      final tripNo = (settings.arguments as Map)[key_params.tripNo];
      final contactCode = (settings.arguments as Map)[key_params.contactCode];
      final isPendingTodoTrip =
          (settings.arguments as Map)[key_params.isPendingTodoTrip];
      final tripNoPending =
          (settings.arguments as Map)[key_params.tripNoPending];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => UpdateTodoTripBloc(),
                child: UpdateTodoSimpleTripView(
                  tripNo: tripNo,
                  contactCode: contactCode,
                  isPendingTrip: isPendingTodoTrip,
                  tripNoPending: tripNoPending,
                  /*  pageId: pageId,
                    pageName: pageName */
                ),
              ));
    case routes.webViewCheckListRoute:
      final url = (settings.arguments as Map)[key_params.urlCheckList];
      final tripNo = (settings.arguments as Map)[key_params.tripNo];
      return MaterialPageRoute(
          builder: (context) => WebViewCheckListView(url: url, title: tripNo));
    case routes.webViewRoute:
      final url = (settings.arguments as Map)[key_params.urlCheckList];
      final tripNo = (settings.arguments as Map)[key_params.tripNo];
      return MaterialPageRoute(
          builder: (context) => WebViewPluginView(url: url, title: tripNo));

    case routes.siteStockCheckRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SiteStockCheckBloc(),
                child: const SiteStockCheckView(),
              ));
    case routes.siteStockCheckDetailRoute:
      final cyCode = (settings.arguments as Map)[key_params.cyCode];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SiteStockCheckDetailBloc(),
                child: SiteStockCheckDetailView(cyCode: cyCode),
              ));

    case routes.stockCountRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => StockCountBloc(),
                child: const StockCountView(),
              ));
    case routes.relocationRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => RelocationBloc(),
                child: const RelocationView(),
              ));
    case routes.goodsReceiptRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => GoodsReceiptBloc(),
                child: const GoodsReceiptView(),
              ));
    case routes.goodsReceiptDetailRoute:
      final GoodReceiptOrderResponse goodsReceipt =
          (settings.arguments as Map)[key_params.goodsReceipt];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => GoodsReceiptDetailBloc(),
                child: GoodsReceiptDetailView(
                  goodsReceipt: goodsReceipt,
                  iOrderNo: goodsReceipt.iOrdNo!,
                ),
              ));

    case routes.settingRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SettingBloc()
            ..add(const SettingViewLoaded(
                /* pageId: pageId, pageName: pageName */)),
          child: const SettingView(),
        ),
      );
    case routes.changLangRoute:
      return MaterialPageRoute(
        builder: (context) => const ChangeLanguageView(),
      );
    case routes.changPasswordRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ChangePasswordBloc()..add(const ChangePasswordLoaded()),
          child: const ChangePasswordView(),
        ),
      );

    case routes.userProfileRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserProfileBloc(),
          child: const UserProfileView(),
        ),
      );

    case routes.siteTrailerRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SiteTrailerBloc(),
                child: const SiteTrailerView(),
              ));
    case routes.siteTrailerDetailRoute:
      final cyName = (settings.arguments as Map)[key_params.cyName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SiteTrailerCheckDetailBloc(),
                child: SiteTrailerDetailView(cyName: cyName),
              ));
    case routes.siteTrailerPendingRoute:
      final cyPending = (settings.arguments as Map)[key_params.cyPending];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SiteTrailerPendingBloc(),
                child: SiteTrailerPendingView(
                  cyPending: cyPending,
                ),
              ));

    case routes.cashCostAppovalRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => CashCostApprovalBloc(),
                child: const CashCostAppovalView(
                    // pageId: pageId,
                    // pageName: pageName,
                    ),
              ));
    case routes.cashCostAppovalDetailRoute:
      final detail = (settings.arguments as Map)[key_params.cashCostApproval];
      return MaterialPageRoute(
          builder: (context) => CashCostApprovalDetailView(
                detailList: detail,
              ));
    //warehouse
    case routes.inboundPhotoRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => InboundPhotoBloc(),
                child: const InboundPhotoView(),
              ));

    case routes.inventoryRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InventoryBloc(),
          child: const InventoryView(),
        ),
      );
    case routes.inventoryDetailRoute:
      final sbNo =
          (settings.arguments as Map)[key_params.inventoryDetailBySBNo];
      final contact =
          (settings.arguments as Map)[key_params.inventoryDetailByContactCode];
      final dc =
          (settings.arguments as Map)[key_params.inventoryDetailByDCcode];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InventoryDetailBloc(),
          child: InventoryDetailView(
            sbNo: sbNo,
            dcCode: dc,
            contactCode: contact,
          ),
        ),
      );

    //haulage activity
    case routes.haulageActivityTRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HaulageActivityBloc(),
                child: const HaulageActivityView(),
              ));

    // case routes.manualDriverClosingRoute:
    //   final tripHistory = (settings.arguments as Map)[key_params.tripHistory];

    //   // final String? tripNo =
    //   //     (settings.arguments as Map)[key_params.tripNoClosing];
    //   // final String? contactCode =
    //   //     (settings.arguments as Map)[key_params.contactClosing];
    //   //final pageId = (settings.arguments as Map)[key_params.pageId];
    //   //   final pageName = (settings.arguments as Map)[key_params.pageName];
    //   return MaterialPageRoute(
    //     builder: (context) => BlocProvider(
    //       create: (context) => ManualDriverClosingBloc(),
    //       child: ManualDriverClosingView(
    //         /*  ddcId: dDCId, */
    //         tripHistory: tripHistory,
    //         /*  tripNo: tripNo,
    //         contactCode: contactCode, */
    //       ),
    //     ),
    //   );
    case routes.historyTodoRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HistoryTodoBloc(),
          child: const HistoryTodoView(),
        ),
      );
    case routes.historyTodoSimpleRoute:
      final tripHistory = (settings.arguments as Map)[key_params.tripHistory];

      // final tripNo =
      //     (settings.arguments as Map)[key_params.tripNoHistoryTodoSimple];
      // final contactCode =
      //     (settings.arguments as Map)[key_params.contactClosing];
      // final tripClass = (settings.arguments as Map)[key_params.tripClass];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HistoryTodoDetailSimpleBloc(),
          child: SimpleTripTodoDetailView(
            trip:
                tripHistory, /* tripNo: tripNo, tripClass: tripClass, contactCode: contactCode */
          ),
        ),
      );

    case routes.historyTodoNormalRoute:
      final tripHistory = (settings.arguments as Map)[key_params.tripHistory];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HistoryTodoDetailNormalBloc(),
          child: NormalTripTodoDetailView(trip: tripHistory),
        ),
      );

    case routes.shipmentStatusRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ShipmentStatusBloc(),
          child: const ShipmentStatusView(),
        ),
      );
    case routes.shipmentStatusDetailRoute:
      final woNo = (settings.arguments as Map)[key_params.woNobyShipmentStatus];
      final cntrNo =
          (settings.arguments as Map)[key_params.cntrNobyShipmentStatus];
      final itemNo =
          (settings.arguments as Map)[key_params.itemNobyShipmentStatus];
      final bcNo = (settings.arguments as Map)[key_params.bcNobyShipmentStatus];
      final equipmentType =
          (settings.arguments as Map)[key_params.equipmentTypeShipmentStatus];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ShipmentStatusDetailBloc(),
          child: ShipmentStatusDetailView(
              woNo: woNo,
              cntrNo: cntrNo,
              itemNo: itemNo,
              bcNO: bcNo,
              equipmentType: equipmentType),
        ),
      );

    case routes.driverClosingHistoryRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DriverClosingHistoryBloc(),
                child: const DriverClosingHistoryView(),
              ));

    case routes.driverClosingHistoryDetailRoute:
      final dDCId = (settings.arguments as Map)[key_params.dDCId];
      final String? etp = (settings.arguments as Map)[key_params.etpAllowance];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DriverClosingHistoryDetailBloc(),
                child: DriverClosingHistoryDetailView(
                    dDCId: dDCId, etp: etp ?? ''),
              ));
    case routes.toDoHaulageWebViewRoute:
      final url = (settings.arguments as Map)[key_params.urlWebView];

      return MaterialPageRoute(
          builder: (context) =>
              WebViewPluginView(title: "ViewImage".tr(), url: url));

    case routes.repairRequestRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => RepairRequestBloc(),
                child: const RepairRequestView(),
              ));
    case routes.shuttleTripRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ShuttleTripBloc(),
                child: const ShuttleTripView(),
              ));
    case routes.addShuttleTripRoute:
      final shuttleTrip =
          (settings.arguments as Map)[key_params.shuttleTripPending];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => AddShuttleTripBloc(),
                child: AddShuttleTripView(shuttleTripsResponse: shuttleTrip),
              ));
    case routes.updateShuttleTripRoute:
      final shuttleTrip = (settings.arguments as Map)[key_params.shuttleTrip];
      final dateTime = (settings.arguments as Map)[key_params.dateTime];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => UpdateShuttleTripBloc(),
                child: UpdateShuttleTripView(
                    shuttleTrip: shuttleTrip, dateTime: dateTime),
              ));
    case routes.announcementDetailRoute:
      final annId = (settings.arguments as Map)[key_params.annId];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => AnnouncementDetailBloc(),
                child: AnnouncementDetailView(annId: annId),
              ));
    case routes.palletRelocationRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => PalletRelocationBloc(),
                child: const PalletRelocationView(),
              ));
    // *09/03/2023

    case routes.driverSalaryRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DriverSalaryBloc()
            ..add(const DriverSalaryLoaded(
                /* pageId: pageId, pageName: pageName */)),
          child: const DriverSalaryView(),
        ),
      );
    case routes.driverSalaryDetailRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DriverSalaryDetailBloc(),
          child: const DriverSalaryDetailView(),
        ),
      );
    case routes.driverStatusRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DeliveryStatusBloc(),
                child: const DeliveryStatusView(),
              ));

    // *18/03/02023
    case routes.pdfViewRoute:
      final file = (settings.arguments as Map)[key_params.fileLocation];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              SalaryFileBloc()..add(SalaryFileLoaded(fileLocation: file)),
          child: const PDFView(),
        ),
      );

    //*22/05/2023
    case routes.loadingStatusRoute:
      final etp = (settings.arguments as Map)[key_params.etpLoadingStatus];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => LoadingStatusBloc(),
                child: LoadingStatusView(etp: etp),
              ));
    case routes.loadingStatusDetailRoute:
      final tripNo =
          (settings.arguments as Map)[key_params.tripNoLoadingStatus];
      final itemLoadingStatus =
          (settings.arguments as Map)[key_params.itemLoadingStatus];
      final etp = (settings.arguments as Map)[key_params.etpLoadingStatus];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoadingStatusDetailBloc()
            ..add(LoadingStatusDetailViewLoaded(
                tripNo: tripNo, detail: itemLoadingStatus, etp: etp)),
          child: LoadingStatusDetailView(
              itemLoadingStatus: itemLoadingStatus, etp: etp),
        ),
      );

    case routes.mapViewRoute:
      final picLat = (settings.arguments as Map)[key_params.picLat];
      final picLon = (settings.arguments as Map)[key_params.picLon];
      final shpLat = (settings.arguments as Map)[key_params.shpLat];
      final shpLon = (settings.arguments as Map)[key_params.shpLon];
      return MaterialPageRoute(
        builder: (context) => MapView(
            picLat: picLat, picLon: picLon, shpLat: shpLat, shpLon: shpLon),
      );

    // case routes.shuttleOverviewMapViewRoute:
    //   final lat = (settings.arguments as Map)[key_params.mapLat];
    //   final lon = (settings.arguments as Map)[key_params.mapLon];
    //   return MaterialPageRoute(
    //     builder: (context) => ShuttleOverviewMapView(
    //       lat: lat,
    //       lon: lon,
    //     ),
    //   );

    case routes.staffsRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => StaffsBloc(),
          child: const StaffsView(/* pageId: pageId, pageName: pageName */),
        ),
      );
    case routes.staffDetailRoute:
      final userId = (settings.arguments as Map)[key_params.userId];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => StaffDetailBloc(),
          child: StaffDetailView(userId: userId),
        ),
      );

    case routes.equipmentsRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EquipmentsBloc(),
          child: const EquipmentsView(/* pageId: pageId, pageName: pageName */),
        ),
      );
    case routes.equipmentDetailRoute:
      final equipmentCode =
          (settings.arguments as Map)[key_params.equipmentCode];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EquipmentDetailBloc(),
          child: EquipmentDetailView(equipmentCode: equipmentCode),
        ),
      );
    case routes.usersRoute:
      //final pageId = (settings.arguments as Map)[key_params.pageId];
      //   final pageName = (settings.arguments as Map)[key_params.pageName];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UsersBloc(),
          child: const UsersView(/* pageId: pageId, pageName: pageName */),
        ),
      );

    case routes.userDetailRoute:
      final userId = (settings.arguments as Map)[key_params.userId];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserDetailBloc(),
          child: UserDetailView(userId: userId),
        ),
      );

    //*******************   CUSTOMER  *********************************************** */
    case routes.customerHomeRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => CustomerHomeBloc(),
            child: const CustomerHomeView()),
      );
    case routes.customerOOSSearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => OutboundOrderStatusSearchBloc(),
          child: const OutboundOrderStatusSearchView(),
        ),
      );
    case routes.customerOOSRoute:
      final model = (settings.arguments as Map)[key_params.cusOOSModel];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerOOSBloc(),
          child: OutboundOrderStatusView(model: model),
        ),
      );
    case routes.customerIOSSearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InboundOrderStatusSearchBloc(),
          child: const InboundOrderStatusSearchView(),
        ),
      );
    case routes.customerIOSRoute:
      final model = (settings.arguments as Map)[key_params.cusIOSModel];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerIOSBloc(),
          child: InboundOrderStatusView(model: model),
        ),
      );
    case routes.customerIOSDetailRoute:
      final orderId = (settings.arguments as Map)[key_params.orderId];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InboundOrderDetailBloc(),
          child: InboundOrderDetailView(
            orderId: orderId,
          ),
        ),
      );

    case routes.customerOOSDetailRoute:
      final orderId = (settings.arguments as Map)[key_params.orderIdOOS];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerOOSDetailBloc(),
          child: CustomerOOSDetailView(orderId: orderId),
        ),
      );
    case routes.customerInventorySearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InventoryWpSearchBloc(),
          child: const CustomerInventorySearchView(),
        ),
      );
    case routes.customerInventoryRoute:
      final model = (settings.arguments as Map)[key_params.cusInventoryModel];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerInventoryWPBloc(),
          child: CustomerInventoryView(model: model),
        ),
      );
    case routes.customerTOSSearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerTOSSearchBloc(),
          child: const CustomerTOSSearchView(),
        ),
      );
    case routes.customerTOSRoute:
      final content = (settings.arguments as Map)[key_params.cusTOSModel];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerTOSBloc(),
          child: CustomerTOSView(content: content),
        ),
      );
    case routes.customerTOSDetailRoute:
      final orderId = (settings.arguments as Map)[key_params.orderIdTOS];
      final tripNo = (settings.arguments as Map)[key_params.tripNoTOS];
      final deliveryMode =
          (settings.arguments as Map)[key_params.deliveryModeTOS];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerTOSDetailBloc(),
          child: CustomerTOSDetailView(
            orderId: orderId.toString(),
            tripNo: tripNo,
            deliveryMode: deliveryMode ?? '',
          ),
        ),
      );
    case routes.customerTrackAndTraceRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TrackAndTraceBloc(),
          child: const TrackAndTraceView(),
        ),
      );
    case routes.customerCNTRHaulageSearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CNTRHaulageSearchBloc(),
          child: const CNTRHaulageSearchView(),
        ),
      );
    case routes.customerCNTRHaulageRoute:
      final GetCntrHaulageReq model =
          (settings.arguments as Map)[key_params.cusCNTRHaulageModel];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CntrHaulageBloc(),
          child: CNTRHaulageView(model: model),
        ),
      );
    case routes.customerCNTRHaulageDetailRoute:
      final woNo = (settings.arguments as Map)[key_params.woNo];
      final woItemNo = (settings.arguments as Map)[key_params.woItemNo];
      final status = (settings.arguments as Map)[key_params.statusCntrHaulage];
      final blCarrier = (settings.arguments as Map)[key_params.cusBLCarrier];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CntrHaulageDetailBloc(),
          child: CNTRHaulageDetailView(
            woNo: woNo,
            woItemNo: woItemNo,
            status: status,
            blCarrierNo: blCarrier,
          ),
        ),
      );
    case routes.customerNotifySetting:
      final woNo = (settings.arguments as Map)[key_params.woNo];
      final woItemNo = (settings.arguments as Map)[key_params.woItemNo];
      final isSubscribed = (settings.arguments as Map)[key_params.isSubscribed];
      final receiver = (settings.arguments as Map)[key_params.receiver];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CntrHaulageDetailBloc(),
          child: SettingNotifyHaulageView(
            isSubscribed: isSubscribed,
            woNo: woNo,
            itemNo: woItemNo,
            receiver: receiver,
          ),
        ),
      );
    case routes.customerCNTRAgeingRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CntrAgeingBloc(),
          child: const CntrAgeingView(),
        ),
      );
    case routes.customerProfileRoute:
      return MaterialPageRoute(
        builder: (context) => const CustomerProfileView(),
      );
    case routes.customerSettingRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerProfileBloc(),
          child: const CustomerSettingView(),
        ),
      );
    case routes.customerHaulageDailySearchRoute:
      return MaterialPageRoute(
          builder: (context) => const HaulageDailySearchView());
    case routes.customerHaulageDailyRoute:
      final content =
          (settings.arguments as Map)[key_params.cusHaulageDailyModel];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HaulageDailyBloc(),
                child: HaulageDailyView(
                  content: content,
                ),
              ));
    case routes.customerHaulageDailyCNTRRoute:
      final woNo = (settings.arguments as Map)[key_params.woNoHaulageDaily];
      final woItemNo =
          (settings.arguments as Map)[key_params.woItemNoHaulageDaily];
      final blCarrierNo = (settings.arguments as Map)[key_params.cusBLCarrier];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HaulageDailyCntrDetailBloc(),
          child: HaulageDailyCNTRDetailView(
              woItemNo: woItemNo, woNo: woNo, blCarrierNo: blCarrierNo),
        ),
      );

    case routes.customerHaulageDailyCNTRPhotoRoute:
      final customerWoTaskID =
          (settings.arguments as Map)[key_params.customerWoTaskID];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HaulageDailyCNTRImageBloc()
                  ..add(HaulageDailyCNTRImageViewLoaded(
                      customerWoTaskID: customerWoTaskID.toString())),
                child: HaulageDailyCNTRImageView(
                  customerWoTaskID: customerWoTaskID.toString(),
                ),
              ));
    case routes.customerChangePassRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerProfileBloc(),
          child: const CusChangePassView(),
        ),
      );

    case routes.customerHaulageOverviewSearchRoute:
      return MaterialPageRoute(
        builder: (context) => const HaulageOverviewSearchView(),
      );
    case routes.customerHaulageOverviewRoute:
      final model =
          (settings.arguments as Map)[key_params.cusHaulageOverviewModel];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HaulageOverviewBloc(),
          child: HaulageOverviewView(model: model),
        ),
      );
    case routes.customerHaulageOverviewCNTRRoute:
      final woNo = (settings.arguments as Map)[key_params.woNoHaulageOverview];
      final woItemNo =
          (settings.arguments as Map)[key_params.woItemNoHaulageOverview];
      final blCarrierNo = (settings.arguments as Map)[key_params.cusBLCarrier];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HaulageOverviewCntrDetailBloc(),
                child: HaulageOverviewCNTRView(
                  woItemNo: woItemNo,
                  woNo: woNo,
                  blCarrierNo: blCarrierNo,
                ),
              ));
    case routes.contactRoute:
      final subsidiaryOb = (settings.arguments as Map)[key_params.subsidiaryOb];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ContactBloc()..add(ContactViewLoaded()),
                child: ContactView(
                  subsidiaryRes: subsidiaryOb,
                ),
              ));
    case routes.customerTimeLineRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CustomerProfileBloc(),
          child: const CustomerTimeLineView(),
        ),
      );

    case routes.siteTrailerHistoryRoute:
      final trailerHistory =
          (settings.arguments as Map)[key_params.trailerHistory];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SiteTrailerHistoryBloc(),
          child: SiteTrailerHistoryView(trailer: trailerHistory),
        ),
      );

    case routes.webViewForgotPasswordRoute:
      final username =
          (settings.arguments as Map)[key_params.usernameForgotPassword];
      final tabMode = (settings.arguments as Map)[key_params.tabMode];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ForgotPasswordBloc(),
                child: WebViewForgotPasswordView(
                    username: username, tabMode: tabMode),
              ));

    case routes.customerDemDetStatusRoute:
      return MaterialPageRoute(
        builder: (context) => const DemDetStatusView(),
      );

    /*  case routes.trackingViewRoute:
      return MaterialPageRoute(
        builder: (context) => const TrackingView(),
      ); */

    /* case routes.historyTrackingViewRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HistoryTrackingBloc(),
          child: const HistoryTrackingView(),
        ),
      );
 */
    //08/04/2024

    case routes.customerBookingSearchRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => BookingSearchBloc(),
          child: const BookingSearchView(),
        ),
      );

    case routes.customerBookingRoute:
      final CustomerBookingReq content =
          (settings.arguments as Map)[key_params.cusBookingModel];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => BookingBloc(),
          child: BookingView(content: content),
        ),
      );
    case routes.customerTransportOverviewRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TransportOverviewBloc(),
          child: const TransportOverviewView(),
        ),
      );
    case routes.customerTransportOverviewDetailTripRoute:
      final String tripNo = (settings.arguments as Map)[key_params.cusTOTripNo];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TransportOverviewDetailTripBloc(),
          child: TransportOverviewDetailTripView(tripNo: tripNo),
        ),
      );
    case routes.customerShuttleOverviewRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ShuttleOverviewBloc(),
          child: const ShuttleOverviewView(),
        ),
      );

    case routes.putAwayRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PutAwaySearchBloc(),
          child: const PutAwaySearchView(),
        ),
      );

    case routes.addPutAwayRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AddPutAwayBloc(),
          child: const AddPutAwayView(),
        ),
      );

    case routes.pickingRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PickingBloc(),
          child: const PickingView(),
        ),
      );
    case routes.pickingDetailRoute:
      final pickingItem = (settings.arguments as Map)[key_params.pickingItem];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PickingDetailBloc(),
          child: PickingDetailView(pickingItem: pickingItem),
        ),
      );

    case routes.inventoryBarcodeTrackingRoute:
      return MaterialPageRoute(builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => BarcodeTrackingBloc(),
          child: const BarcodeTrackingView(),
        );
      });
    case routes.haTransactionReportRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => TransactionReportBloc(),
            child: const TransactionReportView(),
          );
        },
      );
    case routes.siteStockPendingRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => SiteStockCheckPendingBloc(),
            child: const SiteStockCheckPendingView(),
          );
        },
      );
//*MPi hardcode
    case routes.mpiClockInOutRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => ClockInOutBloc(),
            child: const ClockInOutView(),
          );
        },
      );
    case routes.mpiTimesheetsRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => TimesheetsBloc(),
            child: const TimesheetsView(),
          );
        },
      );
    case routes.mpiTimesheetsDetailRoute:
      final timesheet = (settings.arguments as Map)[key_params.timesheets];

      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => TimesheetsDetailBloc(),
            child: TimesheetsDetailView(
              timesheetsResponse: timesheet,
            ),
          );
        },
      );

    case routes.mpiLeaveRoute:
      final isAddLeave = (settings.arguments as Map)[key_params.isAddLeave];

      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => LeaveBloc(),
            child: LeaveView(isAddLeave: isAddLeave ?? false),
          );
        },
      );

    case routes.mpiLeaveDetailRoute:
      final lvNo = (settings.arguments as Map)[key_params.lvNoLeave];

      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => LeaveDetailBloc(),
            child: LeaveDetailView(lvNo: lvNo),
          );
        },
      );

    case routes.mpiAddLeaveRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AddLeaveBloc(),
          child: const AddLeaveView(),
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('${strings.noPath} ${settings.name}')),
        ),
      );
  }
}
