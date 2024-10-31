part of 'user_detail_bloc.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailSuccess extends UserDetailState {
  final List<StdCode2Response> langList;
  final List<StdCode2Response> userRoleList;
  final UserDetailResponse userDetailResponse;
  const UserDetailSuccess({
    required this.langList,
    required this.userRoleList,
    required this.userDetailResponse,
  });
  @override
  List<Object?> get props => [langList, userRoleList, userDetailResponse];
}

class UserDetailFailure extends UserDetailState {
  final String message;
  final int? errorCode;
  const UserDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class UserDetailUpdadateSuccessfully extends UserDetailState {}
