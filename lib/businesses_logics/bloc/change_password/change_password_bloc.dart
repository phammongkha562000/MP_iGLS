import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../general/general_bloc.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final _userRepo = getIt<UserProfileRepository>();

  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordLoaded>(_mapViewToState);
    on<UpdatePassword>(_mapChangePassToState);
  }

  void _mapViewToState(ChangePasswordLoaded event, emit) async {
    try {
      emit(ChangePasswordLoading());
      final sharedPref = await SharedPreferencesService.instance;
      final currentPass = sharedPref.password;
      emit(ChangePasswordSuccess(currentPasword: currentPass));
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangePassToState(UpdatePassword event, emit) async {
    try {
      emit(ChangePasswordLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final dataChange = ChangePassRequest(
        oldPassword: event.currentPasword,
        password: event.newPassword,
        userId: userInfo.userId ?? '',
        updateUser: userInfo.userId ?? '',
      );
      final getChangePass = await _userRepo.changePass(
        content: dataChange,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (getChangePass.isSuccess == true) {
        emit(ChangePasswordSuccess(
            changePassSuccess: true, currentPasword: event.newPassword));
      } else {
        emit(const ChangePasswordFailure(message: "2349"));
      }
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }
}
