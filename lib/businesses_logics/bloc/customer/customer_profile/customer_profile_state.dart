part of 'customer_profile_bloc.dart';

sealed class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object?> get props => [];
}

final class CustomerProfileInitial extends CustomerProfileState {}

final class UpdateCusProfileSuccess extends CustomerProfileState {}

final class UpdateCusProfileFail extends CustomerProfileState {
  final String message;
  const UpdateCusProfileFail({required this.message});
  @override
  List<Object> get props => [];
}

final class ChangeProfileShowLoadingState extends CustomerProfileState {}

final class ChangePassCustomerLoaded extends CustomerProfileState {
  final String currentPass;
  const ChangePassCustomerLoaded({required this.currentPass});
  @override
  List<Object> get props => [];
}

final class ChangePassSuccess extends CustomerProfileState {
  final String? currentPassword;

  const ChangePassSuccess({required this.currentPassword});
  @override
  List<Object?> get props => [currentPassword];
}

final class ChangePassFail extends CustomerProfileState {
  final String message;
  const ChangePassFail({required this.message});
  @override
  List<Object> get props => [];
}

final class GetTimeLineSuccess extends CustomerProfileState {
  final List<TimeLine> lstTimeLine;
  const GetTimeLineSuccess({required this.lstTimeLine});
  @override
  List<Object> get props => [];
}

final class GetTimeLineFail extends CustomerProfileState {
  final String message;
  const GetTimeLineFail({required this.message});
  @override
  List<Object> get props => [];
}
