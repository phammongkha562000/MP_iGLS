import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/users/user_copy_request.dart';
import 'package:igls_new/data/models/users/user_reset_pwd_request.dart';
import 'package:igls_new/data/models/users/users_response.dart';
import 'package:igls_new/data/repository/admin/users/users_repository.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:tiengviet/tiengviet.dart';

import '../../../../../data/services/services.dart';
import '../../../general/general_bloc.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final _usersRepo = getIt<UsersRepository>();

  UsersBloc() : super(UsersInitial()) {
    on<UsersViewLoaded>(_mapViewLoadedToState);
    on<UsersSearch>(_mapSearchToState);
    on<UsersQuickSearch>(_mapQuickSearchToState);
    on<UserCopy>(_mapCopyToState);
    on<UserResetPWD>(_mapResetPWDToState);
    on<UserActive>(_mapActiveToState);
  }
  Future<void> _mapViewLoadedToState(UsersViewLoaded event, emit) async {
    emit(UsersLoading());
    try {
      
      emit(const UsersSuccess(
          userList: [], userListSearch: [], isDeletedData: false));
    } catch (e) {
      emit( UsersFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchToState(UsersSearch event, emit) async {
    try {
      final currentState = state;
      if (currentState is UsersSuccess) {
        emit(UsersLoading());
      UserInfo userInfo = event.generalBloc.generalUserInfo?? UserInfo();

        final apiResultSearch = await _usersRepo.getUsers(
            userId: event.userId,
            subsidiary: userInfo.subsidiaryId ?? '',
            isDeleted: event.isDeletedData == true ? 1 : 0);
        if (apiResultSearch.isFailure) {
          emit(
            UsersFailure(
                message: apiResultSearch.getErrorMessage(),
                errorCode: apiResultSearch.errorCode)
          );
          return;
        }
        List<UsersResponse> userList = apiResultSearch.data;
        emit(currentState.copyWith( userList: userList,
            userListSearch: userList, isDeletedData: event.isDeletedData));
      }
    } catch (e) {
           emit( UsersFailure(message: e.toString()));

    }
  }

  Future<void> _mapCopyToState(UserCopy event, emit) async {
    try {
      final currentState = state;
      if (currentState is UsersSuccess) {
        emit(UsersLoading());
        final content = UserCopyRequest(
            userNameOld: event.userNameOld,
            createUser:  event.generalBloc.generalUserInfo?.userId??'',
            userIdNew: event.userIdNew,
            userName: event.userName,
            email: event.email,
            password: constants.passwordDefault);
        final apiResultCopy = await _usersRepo.copyUser(content: content);
        if (apiResultCopy.isFailure) {
          emit(UsersFailure(
              message: apiResultCopy.getErrorMessage(),
              errorCode: apiResultCopy.errorCode));
          return;
        }
        emit(UserCopySuccessFully(userIDNew: event.userIdNew));
      }
    } catch (e) {
     emit(UsersFailure(message: e.toString()));

    }
  }

  Future<void> _mapResetPWDToState(UserResetPWD event, emit) async {
    try {
      final currentState = state;
      if (currentState is UsersSuccess) {
        emit(UsersLoading());

        final content = UserResetPwdRequest(
          userId: event.userId,
          password: constants.passwordDefault,
          updateUser:  event.generalBloc.generalUserInfo?.userId??'',
        );
        final apiResultResetPwd =
            await _usersRepo.resetPWDUser(content: content);
        if (apiResultResetPwd.isFailure) {
          emit(UsersFailure(
              message: apiResultResetPwd.getErrorMessage(),
              errorCode: apiResultResetPwd.errorCode));
          return;
        }
        emit(UserResetPWDActiveSuccessfully());
        emit(currentState);
      }
    } catch (e) {
      emit( UsersFailure(message: e.toString()));
    }
  }

  Future<void> _mapActiveToState(UserActive event, emit) async {
    try {
      final currentState = state;
      if (currentState is UsersSuccess) {
        emit(UsersLoading());
     
        UserInfo userInfo = event.generalBloc.generalUserInfo?? UserInfo();

        final apiResultActive = await _usersRepo.activeUser(
            userId: event.userId,
            updateUser:  event.generalBloc.generalUserInfo?.userId??'',
            subsidiary: userInfo.subsidiaryId ?? '');
        if (apiResultActive.isFailure) {
          emit(UsersFailure(
              message: apiResultActive.getErrorMessage(),
              errorCode: apiResultActive.errorCode));
          return;
        }
        emit(UserResetPWDActiveSuccessfully());
        emit(currentState);
      }
    } catch (e) {
     emit( UsersFailure(message: e.toString()));

    }
  }

  void _mapQuickSearchToState(UsersQuickSearch event, emit) {
    try {
      final currentState = state;
      if (currentState is UsersSuccess) {
        final quickSearch = event.textSearch == ''
            ? currentState.userList
            : currentState.userList
                .where((element) =>
                        (TiengViet.parse(element.userName.toString())
                            .toUpperCase()
                            .contains(TiengViet.parse(event.textSearch)
                                .toUpperCase())) ||
                        (TiengViet.parse(element.userId.toString())
                            .toUpperCase()
                            .contains(TiengViet.parse(event.textSearch)
                                .toUpperCase())) || (TiengViet.parse(element.email.toString())
                            .toUpperCase()
                            .contains(TiengViet.parse(event.textSearch)
                                .toUpperCase())) || (TiengViet.parse(element.mobileNo.toString())
                            .toUpperCase()
                            .contains(TiengViet.parse(event.textSearch)
                                .toUpperCase())) ||(TiengViet.parse(element.empCode.toString())
                            .toUpperCase()
                            .contains(TiengViet.parse(event.textSearch)
                                .toUpperCase()))
                    
                    )
                .toList();
    emit(currentState.copyWith(userListSearch: quickSearch));
      }
    } catch (e) {
    emit( UsersFailure(message: e.toString()));

    }
  }
}
