// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../repository/admin/equipments/equipments_repository.dart' as _i22;
import '../../repository/admin/staffs/staffs_repository.dart' as _i40;
import '../../repository/admin/users/users_repository.dart' as _i48;
import '../../repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart'
    as _i14;
import '../../repository/customer/contract_logistics/inventory_wp/inventory_wp_repository.dart'
    as _i15;
import '../../repository/customer/contract_logistics/outbound_order_status/outbound_order_status_repository.dart'
    as _i16;
import '../../repository/customer/contract_logistics/shuttle_overview/shuttle_overview_repository.dart'
    as _i36;
import '../../repository/customer/contract_logistics/transport_order_status/transport_order_status_repository.dart'
    as _i18;
import '../../repository/customer/contract_logistics/transport_overview/transport_overview_repository.dart'
    as _i46;
import '../../repository/customer/customer_profile/customer_profile_repository.dart'
    as _i17;
import '../../repository/customer/dashboard/dashboard_repository.dart' as _i11;
import '../../repository/customer/global_visibility/booking/booking_repository.dart'
    as _i6;
import '../../repository/customer/global_visibility/cntr_ageing/cntr_ageing_repository.dart'
    as _i9;
import '../../repository/customer/global_visibility/cntr_haulage/cntr_haulage_repository.dart'
    as _i10;
import '../../repository/customer/global_visibility/haulage_daily/haulage_dailly_repository.dart'
    as _i12;
import '../../repository/customer/global_visibility/haulage_overview/haulage_overview_repository.dart'
    as _i13;
import '../../repository/customer/global_visibility/track_and_trace/track_and_trace_repository.dart'
    as _i45;
import '../../repository/freight_fowarding/cash_cost_approval/cash_cost_approval_repository.dart'
    as _i8;
import '../../repository/freight_fowarding/shipment_status/shipment_status_repository.dart'
    as _i35;
import '../../repository/freight_fowarding/site_stock_check/site_stock_check_repository.dart'
    as _i38;
import '../../repository/freight_fowarding/site_trailer/site_trailer_repository.dart'
    as _i39;
import '../../repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart'
    as _i43;
import '../../repository/ha_driver_menu/driver_check_in/driver_check_in_repository.dart'
    as _i20;
import '../../repository/ha_driver_menu/task_history/task_history_repo.dart'
    as _i42;
import '../../repository/local_distribution/delivery_status/delivery_status_repository.dart'
    as _i19;
import '../../repository/local_distribution/history_todo/history_todo_repository.dart'
    as _i24;
import '../../repository/local_distribution/loading_status/loading_status_repository.dart'
    as _i27;
import '../../repository/ware_house/put_away/put_away_repository.dart' as _i32;
import '../../repository/local_distribution/shuttle_trip/shuttle_trip_repository.dart'
    as _i37;
import '../../repository/local_distribution/to_do_local_distribution/to_do_repository.dart'
    as _i44;
import '../../repository/login/login_repository.dart' as _i28;
import '../../repository/notification/notification_repository.dart' as _i30;
import '../../repository/other/driver_salary/driver_salary_repository.dart'
    as _i21;
import '../../repository/other/manual_driver_closing/manual_driver_closing_repository.dart'
    as _i29;
import '../../repository/other/repair_request/repair_request_repository.dart'
    as _i34;
import '../../repository/user_profile/user_repository.dart' as _i47;
import '../../repository/ware_house/goods-receipt/goods_receipt_repository.dart'
    as _i23;
import '../../repository/ware_house/inbound_photo/inbound_photo_repository.dart'
    as _i25;
import '../../repository/ware_house/inventory/inventory_repository.dart'
    as _i26;
import '../../repository/ware_house/pallet_relocation/pallet_relocation_repository.dart'
    as _i31;
import '../../repository/ware_house/relocation/relocation_repository.dart'
    as _i33;
import '../../repository/ware_house/stock_count/stock_count_repository.dart'
    as _i41;
import '../../repository/ware_house/picking/picking_repository.dart' as _i49;
import '../../repository/freight_fowarding/transaction_report/transaction_report_repository.dart'
    as _i50;

import '../../repository/mpi/timesheet/timesheet_repository.dart' as _i51;
import '../../repository/mpi/leave/leave_repository.dart' as _i52;
import '../navigator/navigation_service.dart' as _i4;
import '../network/client.dart' as _i5;
import '../services.dart' as _i7;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i4.NavigationService>(() => _i4.NavigationService());
  gh.lazySingleton<_i5.AbstractDioHttpClient>(
      () => _i5.ApiClient(client: gh<_i3.Dio>()));
  gh.factory<_i6.BookingRepository>(
      () => _i6.BookingRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i8.CashCostApprovalRepository>(() =>
      _i8.CashCostApprovalRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i9.CntrAgeingRepository>(
      () => _i9.CntrAgeingRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i10.CntrHaulageRepository>(() =>
      _i10.CntrHaulageRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i11.CustomerDashBoardRepository>(() =>
      _i11.CustomerDashBoardRepository(
          client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i12.CustomerHaulageDailyRepository>(() =>
      _i12.CustomerHaulageDailyRepository(
          client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i13.CustomerHaulageOverviewRepository>(() =>
      _i13.CustomerHaulageOverviewRepository(
          client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i14.CustomerIOSRepository>(() =>
      _i14.CustomerIOSRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i15.CustomerInventoryRepository>(() =>
      _i15.CustomerInventoryRepository(
          client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i16.CustomerOOSRepository>(() =>
      _i16.CustomerOOSRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i17.CustomerProfileRepository>(() =>
      _i17.CustomerProfileRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i18.CustomerTOSRepository>(() =>
      _i18.CustomerTOSRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i19.DeliveryStatusRepository>(() =>
      _i19.DeliveryStatusRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i20.DriverCheckInRepository>(() =>
      _i20.DriverCheckInRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i21.DriverSalaryRepository>(() =>
      _i21.DriverSalaryRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i22.EquipmentsRepository>(
      () => _i22.EquipmentsRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i23.GoodsReceiptRepository>(() =>
      _i23.GoodsReceiptRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i24.HistoryTodoRepository>(() =>
      _i24.HistoryTodoRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i25.InboundPhotoRepository>(() =>
      _i25.InboundPhotoRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i26.InventoryRepository>(
      () => _i26.InventoryRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i27.LoadingStatusRepository>(() =>
      _i27.LoadingStatusRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i28.LoginRepository>(
      () => _i28.LoginRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i29.ManualDriverClosingRepository>(() =>
      _i29.ManualDriverClosingRepository(
          client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i30.NotificationRepository>(() =>
      _i30.NotificationRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i31.PalletRelocationRepository>(() =>
      _i31.PalletRelocationRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i32.PutAwayRepository>(
      () => _i32.PutAwayRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i33.RelocationRepository>(
      () => _i33.RelocationRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i34.RepairRequestRepository>(() =>
      _i34.RepairRequestRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i35.ShipmentStatusRepository>(() =>
      _i35.ShipmentStatusRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i36.ShuttleOverviewRepository>(() =>
      _i36.ShuttleOverviewRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i37.ShuttleTripRepository>(() =>
      _i37.ShuttleTripRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i38.SiteStockCheckRepository>(() =>
      _i38.SiteStockCheckRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i39.SiteTrailerRepository>(() =>
      _i39.SiteTrailerRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i40.StaffsRepository>(
      () => _i40.StaffsRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i41.StockCountRepository>(
      () => _i41.StockCountRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i42.TaskHistoryRepository>(() =>
      _i42.TaskHistoryRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i43.ToDoHaulageRepository>(() =>
      _i43.ToDoHaulageRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i44.ToDoTripRepository>(
      () => _i44.ToDoTripRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i45.TrackAndTraceRepository>(() =>
      _i45.TrackAndTraceRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i46.TransportOverviewRepository>(() =>
      _i46.TransportOverviewRepository(
          client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i47.UserProfileRepository>(() =>
      _i47.UserProfileRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i48.UsersRepository>(
      () => _i48.UsersRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i49.PickingRepository>(
      () => _i49.PickingRepository(client: gh<_i7.AbstractDioHttpClient>()));
  gh.factory<_i50.TransactionReportRepository>(() =>
      _i50.TransactionReportRepository(
          client: gh<_i7.AbstractDioHttpClient>()));

  gh.factory<_i51.TimesheetRepository>(
      () => _i51.TimesheetRepository(client: gh<_i7.AbstractDioHttpClient>()));

  gh.factory<_i52.LeaveRepository>(
      () => _i52.LeaveRepository(client: gh<_i7.AbstractDioHttpClient>()));
  return getIt;
}

class _$RegisterModule extends _i5.RegisterModule {}
