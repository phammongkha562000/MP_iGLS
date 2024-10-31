part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<UsersResponse> userList;
  final List<UsersResponse> userListSearch;
  final bool isDeletedData;
  const UsersSuccess(
      {required this.userList,
      required this.isDeletedData,
      required this.userListSearch});
  @override
  List<Object?> get props => [userList, isDeletedData, userListSearch];

  UsersSuccess copyWith(
      {List<UsersResponse>? userList,
      List<UsersResponse>? userListSearch,
      bool? isDeletedData}) {
    return UsersSuccess(
        userList: userList ?? this.userList,
        isDeletedData: isDeletedData ?? this.isDeletedData,
        userListSearch: userListSearch ?? this.userListSearch);
  }
}

class UsersFailure extends UsersState {
  final String message;
  final int? errorCode;
  const UsersFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class UserCopySuccessFully extends UsersState {
  final String userIDNew;
  const UserCopySuccessFully({required this.userIDNew});
  @override
  List<Object?> get props => [userIDNew];
}

class UserResetPWDActiveSuccessfully extends UsersState {}
