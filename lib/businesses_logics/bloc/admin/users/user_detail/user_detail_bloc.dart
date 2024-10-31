import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/models/users/user_update_request.dart';

import '../../../../../data/models/std_code/std_code_2_response.dart';
import '../../../../../data/models/users/user_detail_response.dart';
import '../../../../../data/repository/admin/users/users_repository.dart';
import '../../../../../data/services/services.dart';
import '../../../general/general_bloc.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final _usersRepo = getIt<UsersRepository>();

  UserDetailBloc() : super(UserDetailInitial()) {
    on<UserDetailViewLoaded>(_mapViewLoadedToState);
    on<UserDetailUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(UserDetailViewLoaded event, emit) async {
    {
      emit(UserDetailLoading());
      try {
        List<StdCode2Response> langList = event.generalBloc.listStdLang;
        if (langList.isEmpty || langList == []) {
          final apiStdCode = await _usersRepo.getStdCode2(
              codeGroup: StdCodeType.languageCodetype);
          if (apiStdCode.isFailure) {
            emit(UserDetailFailure(message: apiStdCode.getErrorMessage()));
            return;
          }
          langList = apiStdCode.data;
          event.generalBloc.listStdLang = langList;
        }

        List<StdCode2Response> userRoleList = event.generalBloc.listUserRole;
        if (userRoleList.isEmpty || userRoleList == []) {
          final apiStdCode = await _usersRepo.getStdCode2(
              codeGroup: StdCodeType.userRoleCodetype);
          if (apiStdCode.isFailure) {
            emit(UserDetailFailure(message: apiStdCode.getErrorMessage()));
            return;
          }
          userRoleList = apiStdCode.data;
          event.generalBloc.listUserRole = userRoleList;
        }
        final apiDetail = await _usersRepo.getUserDetail(userId: event.userId);

        if (apiDetail.isFailure) {
          emit(UserDetailFailure(
              message: apiDetail.getErrorMessage(),
              errorCode: apiDetail.errorCode));
          return;
        }
        UserDetailResponse detail = apiDetail.data;
        emit(UserDetailSuccess(
            langList: langList,
            userRoleList: userRoleList,
            userDetailResponse: detail));
      } catch (e) {
        emit(UserDetailFailure(message: e.toString()));
      }
    }
  }

  Future<void> _mapUpdateToState(UserDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is UserDetailSuccess) {
        UserDetailResponse userDetail = currentState.userDetailResponse;
        UserGetDetail detail = userDetail.getDetail![0];
        UserGetDetail1 detail1 = userDetail.getDetail1![0];
        final content = UserDetailUpdateRequest(
            userId: detail.userId!,
            userName: event.userName,
            email: event.email,
            mobileNo: event.phone,
            language: event.lang,
            defaultSystem: detail1.defaultSystem ?? '',
            defaultSubsidiary: detail1.defaultSubsidiary ?? '',
            defaultContact: detail1.defaultClient ?? '',
            defaultDc: detail1.defaultCenter ?? '',
            defaultBarnch: detail1.defaultBranch ?? '',
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
            empCode: event.empCode,
            userRole: event.userRole,
            cyCode: null,
            dirverId: null);

        final apiResultUpdate = await _usersRepo.updateUser(content: content);
        if (apiResultUpdate.isFailure) {
          emit(UserDetailFailure(
              message: apiResultUpdate.getErrorMessage(),
              errorCode: apiResultUpdate.errorCode));
          return;
        }
        emit(UserDetailUpdadateSuccessfully());
      }
    } catch (e) {
      emit(UserDetailFailure(message: e.toString()));
    }
  }
}
