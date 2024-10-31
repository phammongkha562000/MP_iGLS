import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/assets.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../data/models/models.dart';
import '../../../data/repository/repository.dart';
import '../../../data/services/injection/injection_igls.dart';
import '../general/general_bloc.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final _userprofileRepo = getIt<UserProfileRepository>();
  final repoTaskHistory = getIt<TaskHistoryRepository>();
  final _siteStockCheckRepo = getIt<SiteStockCheckRepository>();
  UserProfileBloc() : super(UserProfileInitial()) {
    on<UserProfileLoaded>(_mapViewLoadedToState);
    on<UserProfileUpdate>(_mapUpdateProfileToState);
  }

  void _mapViewLoadedToState(UserProfileLoaded event, emit) async {
    try {
      emit(UserProfileLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final sharedPref = await SharedPreferencesService.instance;
      List<CySiteResponse> listCY = event.generalBloc.listCY;
      if (listCY == [] || listCY.isEmpty) {
        final apiResult = await _siteStockCheckRepo.getCYSite(
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(UserProfileFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        } else {
          listCY = apiResult.data;
        }

        event.generalBloc.listCY = listCY;
      }

      List<ContactLocal> contactList = [
        ContactLocal(contactCode: '', contactName: '')
      ];
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;
      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userprofileRepo.getLocal(
            userId: userInfo.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(UserProfileFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }
      contactList.addAll(contactLocalList);

      final phone = userInfo.mobileNo;
      final driverId = userInfo.empCode ?? '';

      final equipmentCode = sharedPref.equipmentNo;
      log(equipmentCode.toString());
      log("DRIVER ID: ${driverId.toString()}");

      final contact = userInfo.defaultClient;
      final dc = userInfo.defaultCenter;
      final cy = sharedPref.cySite;

      emit(UserProfileSuccess(
        phone: phone,
        driverId: driverId,
        equipment: equipmentCode,
        contactCode: contact,
        dcCode: dc,
        cyCode: cy,
        listContactLocal: contactList,
        listDCLocal: dcLocalList,
        listCY: listCY,
      ));
    } catch (e) {
      emit(const UserProfileFailure(message: strings.messError));
    }
  }

  Future<void> _mapUpdateProfileToState(UserProfileUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is UserProfileSuccess) {
        emit(UserProfileLoading());

        final sharedPref = await SharedPreferencesService.instance;

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
        final dataUpdate = UpdateUserProfileRequest(
          userId: userInfo.userId ?? '',
          userName: userInfo.userName ?? '',
          email: userInfo.email,
          mobileNo: userInfo.mobileNo,
          language: userInfo.language,
          defaultSystem: userInfo.defaultSystem!,
          defaultSubsidiary: userInfo.subsidiaryId!,
          defaultContact: event.defaultContact,
          defaultDc: event.defaultfDC,
          defaultBarnch: userInfo.defaultBranch!,
          updateUser: userInfo.empCode!,
          empCode: userInfo.empCode,
          userRole: userInfo.userRole,
          cyCode: event.defaultCY,
          dirverId: userInfo.empCode,
        );
        // * Cập nhật
        final apiResultUpdate = await _userprofileRepo.updateUserProfile(
          content: dataUpdate,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultUpdate.isFailure) {
          emit(UserProfileFailure(
              message: apiResultUpdate.getErrorMessage(),
              errorCode: apiResultUpdate.errorCode));
          return;
        }
        StatusResponse updateUserProfile = apiResultUpdate.data;
        if (updateUserProfile.isSuccess == true) {
          sharedPref.setCySite(event.defaultCY);
          //sau khi update thì ghi lại userInfo
          final userInfo2 = userInfo.copyWith(
            defaultClient: event.defaultContact,
            defaultCenter: event.defaultfDC,
          );
          event.generalBloc.generalUserInfo = userInfo2;
          event.generalBloc.listLocation.clear();
          event.generalBloc.listItemCode.clear();
          event.generalBloc.listContactResponse.clear();
          emit(currentState.copyWith(
            isSuccess: true,
            contactCode: event.defaultContact,
            dcCode: event.defaultfDC,
            cyCode: event.defaultCY,
          ));
        } else {
          emit(currentState);
        }
      }
    } catch (e) {
      emit(const UserProfileFailure(message: strings.messError));
    }
  }
}
