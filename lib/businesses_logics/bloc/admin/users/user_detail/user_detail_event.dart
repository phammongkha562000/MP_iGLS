part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class UserDetailViewLoaded extends UserDetailEvent {
  final String userId;
  final GeneralBloc generalBloc;
  const UserDetailViewLoaded({required this.userId, required this.generalBloc});
  @override
  List<Object> get props => [userId, generalBloc];
}

class UserDetailUpdate extends UserDetailEvent {
  final String userId;
  final String userName;
  final String email;
  final String phone;
  final String lang;
  final String empCode;
  final String userRole;
  final GeneralBloc generalBloc;
  const UserDetailUpdate(
      {required this.userId,
      required this.userName,
      required this.email,
      required this.phone,
      required this.lang,
      required this.empCode,
      required this.userRole,
      required this.generalBloc});
  @override
  List<Object> get props =>
      [userId, userName, email, phone, lang, empCode, userRole, generalBloc];
}
