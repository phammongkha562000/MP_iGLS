import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/repository/notification/notification_repository.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../data/models/models.dart';
import '../general/general_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repoLogin = getIt<LoginRepository>();
  final _notificationRepo = getIt<NotificationRepository>();

  HomeBloc() : super(HomeInitial()) {
    on<HomeLoaded>(_mapHomeLoadedToState);
    on<HomeAnnouncementLoaded>(_mapHomeAnnouncementLoadedToState);
    on<LogOut>(_mapLogOutToState);
  }
  Future<void> _mapHomeLoadedToState(HomeLoaded event, emit) async {
    emit(HomeLoading());
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final sharedPref = await SharedPreferencesService.instance;

      final contentMenu = MenuRequest(
        uid: userInfo.userId ?? '',
        systemId: constants.systemId,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );

      final apiResultAnn = await _repoLogin.getAnnouncements(
          baseUrl: sharedPref.serverAddress ?? '',
          branchCode: userInfo.defaultBranch ?? '',
          dcCode: userInfo.defaultCenter ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
          userId: userInfo.userId ?? '');
      if (apiResultAnn.isFailure) {
        emit(HomeFailure(
            message: apiResultAnn.getErrorMessage(),
            errorCode: apiResultAnn.errorCode));
        return;
      }
      final apiAnnouncement = apiResultAnn.data;

      final apiSubsidiary = await _repoLogin.getSubsidiary(
          subsidiaryId: userInfo.subsidiaryId ?? '');

      if (apiSubsidiary.isFailure) {
        emit(HomeFailure(
            message: apiSubsidiary.getErrorMessage(),
            errorCode: apiSubsidiary.errorCode));
        return;
      }
      event.generalBloc.subsidiaryRes = apiSubsidiary.data;

      List<PageMenuPermissions> listMenu = event.generalBloc.listMenu;

      if (listMenu == [] || listMenu.isEmpty) {
        final apiResultMenu = await _repoLogin.getMenu(menu: contentMenu);

        if (apiResultMenu.isFailure) {
          emit(HomeFailure(
              message: apiResultMenu.getErrorMessage(),
              errorCode: apiResultMenu.errorCode));
          return;
        }
        List<PageMenuPermissions> listMenuApi = apiResultMenu.data;

        listMenu = listMenuApi;
        event.generalBloc.listMenu = listMenu;

        if (listMenu.isEmpty) {
          emit(HomeFailure(
              message: '5507'.tr(), errorCode: constants.errorNoPermissionMb));
          return;
        }
      }
      final searchManualDriverClosing = listMenu
          .where((element) =>
              element.tagVariant == constants.caseManualDriverClosing)
          .toList();
      if (searchManualDriverClosing.isNotEmpty) {
        globalApp.setIsAllowance = true;
        listMenu.removeWhere((element) =>
            element.tagVariant == constants.caseManualDriverClosing);
      }
      final menuGroupBy = groupBy(
        listMenu,
        (PageMenuPermissions elm) => elm.parentsMenu,
      );
      final menuGroupByList =
          menuGroupBy.entries.map((entry) => entry.value).toList();

      final listMenuQuick =
          listMenu.where((element) => element.quickMenuSeq != 0).toList();
      if (listMenuQuick.isNotEmpty) {
        listMenuQuick
            .sort((a, b) => a.quickMenuSeq!.compareTo(b.quickMenuSeq!));
      }
      final countNotification = await _notificationRepo.getTotalNotifications(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          sourceType: constants.systemId,
          baseUrl: sharedPref.serverAddress.toString(),
          serverHub: sharedPref.serverHub.toString());

      if (countNotification.isSuccess) {
        int countNoti = int.parse(countNotification.data);
        globalApp.setCountNotification = countNoti;
        emit(CountNotification(countNoti: countNoti));
      }
      emit(HomeSuccess(
          server: sharedPref.serverCode!,
          listMenuGroup: menuGroupByList,
          listMenuQuick: listMenuQuick,
          driverName: userInfo.userName ?? '',
          version: version,
          listAnnouncement: apiAnnouncement));

      final apiResultStaff = await _repoLogin.getStaffDetail(
        empCode: userInfo.empCode ?? '',
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (apiResultStaff.isFailure) {
        emit(HomeFailure(
            message: apiResultStaff.getErrorMessage(),
            errorCode: apiResultStaff.errorCode));
        return;
      }
      StaffResponse staff = apiResultStaff.data;
      final equipmentCode = staff.defaultEquipment;
      sharedPref.setEquipmentNo(equipmentCode ?? '');

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        sharedPref.setDeviceId('${androidInfo.id}${userInfo.empCode}');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        sharedPref
            .setDeviceId('${iosInfo.identifierForVendor}${userInfo.empCode}');
      }
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }

  Future<void> _mapHomeAnnouncementLoadedToState(
      HomeAnnouncementLoaded event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      ApiResult apiResult = await _repoLogin.getAnnouncements(
          baseUrl: sharedPref.serverAddress ?? '',
          branchCode: event.generalBloc.generalUserInfo?.defaultBranch ?? '',
          dcCode: userInfo.defaultCenter ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
          userId: event.generalBloc.generalUserInfo?.userId ?? '');
      if (apiResult.isFailure) {
        emit(HomeFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<AnnouncementResponse> apiAnnouncement = apiResult.data;
      emit(GetAnnouncement(listAnnouncement: apiAnnouncement));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }

  Future _mapLogOutToState(LogOut event, emit) async {
    emit(HomeLoading());
    try {
      emit(LogOutSuccess());
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }
}
