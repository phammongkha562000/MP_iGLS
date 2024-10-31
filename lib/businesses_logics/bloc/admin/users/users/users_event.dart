part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersViewLoaded extends UsersEvent {}

class UsersSearch extends UsersEvent {
  final bool isDeletedData;
  final String userId;
  final GeneralBloc generalBloc;

  const UsersSearch({
    required this.isDeletedData,
    required this.userId,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [isDeletedData, userId, generalBloc];
}

class UserCopy extends UsersEvent {
  final String userNameOld;
  final String userIdNew;
  final String userName;
  final String email;
  final GeneralBloc generalBloc;
  const UserCopy(
      {required this.userNameOld,
      required this.userIdNew,
      required this.userName,
      required this.email,
      required this.generalBloc});
  @override
  List<Object> get props =>
      [userNameOld, userIdNew, userName, email, generalBloc];
}

class UserResetPWD extends UsersEvent {
  final String userId;
  final GeneralBloc generalBloc;
  const UserResetPWD({required this.userId, required this.generalBloc});
  @override
  List<Object> get props => [userId, generalBloc];
}

class UserActive extends UsersEvent {
  final GeneralBloc generalBloc;
  final String userId;
  const UserActive({required this.userId, required this.generalBloc});
  @override
  List<Object> get props => [userId, generalBloc];
}

class UsersQuickSearch extends UsersEvent {
  final String textSearch;
  const UsersQuickSearch({
    required this.textSearch,
  });
  @override
  List<Object> get props => [textSearch];
}
