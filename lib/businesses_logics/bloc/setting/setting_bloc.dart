import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../../data/global/global.dart';
import '../../../data/services/services.dart';
import '../../../data/shared/shared.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<LogOut>(_mapLogOutToState);
    on<SettingViewLoaded>(_mapViewLoadedToState);
    on<BiometricChanged>(_mapBiometricChangedToState);
  }
  Future<void> _mapViewLoadedToState(SettingViewLoaded event, emit) async {
    emit(SettingLoading());
    final sharedPref = await SharedPreferencesService.instance;
    // if (event.pageId != null && event.pageName != null) {
    //   String accessDatetime = DateTime.now().toString().split('.').first;
    //   final contentQuickMenu = FrequentlyVisitPageRequest(
    //       userId:  event.generalBloc.generalUserInfo?.userId??'',
    //       subSidiaryId:  userInfo.subsidiaryId?? '',
    //       pageId: event.pageId!,
    //       pageName: event.pageName!,
    //       accessDatetime: accessDatetime,
    //       systemId: constants.systemId);
    //   final addFreqVisitResult =
    //       await _loginRepo.saveFreqVisitPage(content: contentQuickMenu);
    //   if (addFreqVisitResult.isFailure) {
    //     emit(SettingFailure(
    //         message: addFreqVisitResult.getErrorMessage(),
    //         errorCode: addFreqVisitResult.errorCode));
    //     return;
    //   }
    // }
    final isAllowBiometric = sharedPref.isAllowBiometrics ?? false;
    final isBiometric = sharedPref.isBiometrics ?? false;
    emit(SettingSuccess(
        isAllowBiometric: isAllowBiometric, isBiometric: isBiometric));
  }

  Future<void> _mapLogOutToState(LogOut event, emit) async {
    try {
      globalApp.setIsLogin = false;
      // HiveBoxHelper.deleteAllDataFromHive();

      emit(SettingLogOutSuccess());
    } catch (e) {
      emit(SettingFailure(message: e.toString()));
    }
  }

  Future<void> _mapBiometricChangedToState(BiometricChanged event, emit) async {
    try {
      final currentState = state;
      if (currentState is SettingSuccess) {
        final isAllowBiometric = event.isAllowBiometric;
        final sharedPref = await SharedPreferencesService.instance;
        sharedPref.setIsAllowBiometrics(isAllowBiometric);
        emit(currentState.copyWith(isAllowBiometric: isAllowBiometric));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
