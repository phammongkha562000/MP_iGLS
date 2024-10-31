import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/customer/customer_profile/update_cus_profile_req.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/repository/customer/customer_profile/customer_profile_repository.dart';
import 'package:igls_new/data/repository/customer/dashboard/dashboard_repository.dart';
import 'package:igls_new/data/services/result/api_result.dart';

import '../../../../data/models/customer/customer_profile/time_line_payload.dart';
import '../../../../data/models/login/user.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/shared/preference/share_pref_service.dart';
import '../../../../presentations/common/constants.dart';
import '../customer_bloc/customer_bloc.dart';

part 'customer_profile_event.dart';
part 'customer_profile_state.dart';

class CustomerProfileBloc
    extends Bloc<CustomerProfileEvent, CustomerProfileState> {
  final _repoDashBoard = getIt<CustomerDashBoardRepository>();

  CustomerProfileBloc() : super(CustomerProfileInitial()) {
    on<UpdateProfileCustomerEvent>(_updateProfileCustomer);
    on<ChangePassCustomerLoadEvent>(_changePassCustomerLoad);
    on<CusChangePasswordEvent>(_changePassword);
    on<GetTimeLineEvent>(_getTimeLine);
  }
  final _cusProfileRepo = getIt<CustomerProfileRepository>();

  Future<void> _updateProfileCustomer(
      UpdateProfileCustomerEvent event, emit) async {
    try {
      emit(ChangeProfileShowLoadingState());
      var result = await _cusProfileRepo.updateCusProfile(model: event.model);

      if (result.isFailure || result.isSuccess != true) {
        emit(UpdateCusProfileFail(message: result.getErrorMessage()));
        return;
      }
      UserInfo userInfo =
          event.customerBloc.userLoginRes?.userInfo ?? UserInfo();
      ApiResult cusPermissionResult =
          await _repoDashBoard.getCustomerPermission(
              userId: userInfo.userId ?? '',
              lan: userInfo.language ?? '',
              sysid: SystemId.iglsWebPortal);
      if (cusPermissionResult.isFailure) {
        emit(UpdateCusProfileFail(message: cusPermissionResult.error));
        return;
      }
      CustomerPermissionRes a = cusPermissionResult.data;
      List<UserSubsidaryResult> b = a.userSubsidaryResult ?? [];
      log(b.toString());
      final c = b[0].contactCode!;
      log(c.toString());
      final d = jsonDecode(c);
      List<ContactCodeRes> contactList =
          List<ContactCodeRes>.from(d.map((e) => ContactCodeRes.fromJson(e)));
      log(contactList.toString());
      event.customerBloc.contactList = contactList;
      event.customerBloc.cusPermission = cusPermissionResult.data;
      userInfo.defaultClient = event.model.defaultClient;
      userInfo.userName = event.model.userName;
      userInfo.email = event.model.email;
      userInfo.userRolePosition = event.model.userRolePosition;
      userInfo.language = event.model.language;
      for (var element in contactList) {
        if (element.clientId == b.first.defaultClient) {
          userInfo.defaultClientSmallLogo = element.smallLogo;
        }
      }
      emit(UpdateCusProfileSuccess());
    } catch (e) {
      emit(UpdateCusProfileFail(message: e.toString()));
    }
  }

  Future<void> _changePassCustomerLoad(
      ChangePassCustomerLoadEvent event, emit) async {
    final sharedPref = await SharedPreferencesService.instance;
    emit(ChangePassCustomerLoaded(currentPass: sharedPref.password ?? ''));
  }

  Future<void> _changePassword(CusChangePasswordEvent event, emit) async {
    try {
      emit(ChangeProfileShowLoadingState());
      var result = await _cusProfileRepo.changePassword(
          userId: event.customerBloc.userLoginRes?.userInfo?.userId ?? '',
          password: event.password,
          systemId: SystemId.iglsWebPortal);

      if (result.isFailure) {
        emit(ChangePassFail(message: result.getErrorMessage()));
        return;
      }
      if (result.data?.success != true) {
        emit(ChangePassFail(message: result.getErrorMessage()));
        return;
      }
      emit(ChangePassSuccess(currentPassword: event.password));
    } catch (e) {
      emit(ChangePassFail(message: e.toString()));
    }
  }

  Future<void> _getTimeLine(GetTimeLineEvent event, emit) async {
    try {
      emit(ChangeProfileShowLoadingState());
      var result = await _cusProfileRepo.getTimeLine(
        userId: event.customerBloc.userLoginRes?.userInfo?.userId ?? '',
      );

      if (result.isFailure) {
        emit(GetTimeLineFail(message: result.getErrorMessage()));
        return;
      }
      if (result.data?.success != true) {
        emit(GetTimeLineFail(message: result.getErrorMessage()));
        return;
      }
      TimeLinePayload timeLine =
          TimeLinePayload.fromJson(jsonDecode(result.data?.payload ?? ''));
      emit(GetTimeLineSuccess(lstTimeLine: timeLine.lstTimeLine ?? []));
    } catch (e) {
      emit(GetTimeLineFail(message: e.toString()));
    }
  }
}
