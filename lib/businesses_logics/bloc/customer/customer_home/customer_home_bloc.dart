import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/customer/customer_profile/subsidiary_res.dart';
import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/data/services/services.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../data/models/customer/home/customer_permission_res.dart';
import '../../../../data/models/customer/home/os_get_today_respone.dart';
import '../../../../data/repository/customer/dashboard/dashboard_repository.dart';
import '../../../../data/services/result/api_result.dart';
import '../customer_bloc/customer_bloc.dart';

part 'customer_home_event.dart';
part 'customer_home_state.dart';

class CustomerHomeBloc extends Bloc<CustomerHomeEvent, CustomerHomeState> {
  CustomerHomeBloc() : super(CustomerHomeInitial()) {
    on<CustomerHomeLoaded>(_homeLoad);
    on<CustomerLogOut>(_logOut);
  }
  final _repoDashBoard = getIt<CustomerDashBoardRepository>();
  final _loginRepo = getIt<LoginRepository>();

  Future<void> _homeLoad(CustomerHomeLoaded event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      SubsidiaryRes? subsidiaryRes = event.customerBloc.subsidiaryRes;
      if (subsidiaryRes == null) {
        final apiSubsidiary = await _loginRepo.getSubsidiary(
            subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiSubsidiary.isFailure) {
          emit(CustomerHomeFailure(message: apiSubsidiary.getErrorMessage()));
          return;
        }
        subsidiaryRes = apiSubsidiary.data ?? SubsidiaryRes();
        event.customerBloc.subsidiaryRes = subsidiaryRes;
      }
//hardcode Future.wait
      final results = await Future.wait([
        _repoDashBoard.getCustomerPermission(
            userId: userInfo.userId ?? '',
            lan: userInfo.language ?? '',
            sysid: SystemId.iglsWebPortal),
        _repoDashBoard.getCustomerOsToday(
          subsidiary: userInfo.subsidiaryId ?? '',
          contactCode: userInfo.defaultClient ?? '',
          dcCode: userInfo.defaultCenter ?? '',
        ),
      ]);
      ApiResult cusPermissionResult = results[0];

      if (cusPermissionResult.isFailure) {
        emit(CustomerHomeFailure(message: cusPermissionResult.error));
        return;
      }
      CustomerPermissionRes a = cusPermissionResult.data;
      List<UserSubsidaryResult> b = a.userSubsidaryResult ?? [];
      final c = b[0].contactCode!;
      final d = jsonDecode(c);
      List<ContactCodeRes> contactList =
          List<ContactCodeRes>.from(d.map((e) => ContactCodeRes.fromJson(e)));
      event.customerBloc.contactList = contactList;
      event.customerBloc.cusPermission = cusPermissionResult.data;
      ApiResult osTodayResult = results[1];
      if (osTodayResult.isFailure) {
        emit(CustomerHomeFailure(message: osTodayResult.getErrorMessage()));
        return;
      }

      final lstGroupName = cusPermissionResult.data.getMenuResult
          .where((element) =>
              element.isGroup != false && element.menuId != "W00001")
          .toList();
      final listMenuQuick = cusPermissionResult.data.getMenuResult!
          .where((element) => element.isGroup == false)
          .toList();
      final menuGroupBy = groupBy(
        listMenuQuick,
        (GetMenuResult elm) => elm.parentsMenu,
      );
      final lstMenuGroupBy =
          menuGroupBy.entries.map((entry) => entry.value).toList();
      emit(CustomerHomeSuccess(
          server: sharedPref.serverCode!,
          userName: userInfo.userName ?? '',
          premissionRes: cusPermissionResult.data,
          osTodayRes: osTodayResult.data,
          listGroupName: lstGroupName,
          lstMenuGroupBy: lstMenuGroupBy));
    } catch (e) {
      emit(CustomerHomeFailure(message: e.toString()));
    }
  }

  Future _logOut(CustomerLogOut event, emit) async {}
}
