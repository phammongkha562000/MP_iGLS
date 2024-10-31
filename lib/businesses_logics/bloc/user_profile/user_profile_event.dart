part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileLoaded extends UserProfileEvent {
  final String? phone;
  final String? driverId;
  final String? equipment;
  final String? pageId;
  final String? pageName;
  final GeneralBloc generalBloc;
  const UserProfileLoaded(
      {this.phone,
      this.driverId,
      this.equipment,
      this.pageId,
      this.pageName,
      required this.generalBloc});
  @override
  List<Object?> get props =>
      [phone, driverId, equipment, pageId, pageName, generalBloc];
}

class UserProfileUpdate extends UserProfileEvent {
  // final String phone;
  // final String driverId;
  // final String equipment;
  final String defaultContact;
  final String defaultfDC;
  final String defaultCY;
  final GeneralBloc generalBloc;

  const UserProfileUpdate(
      {
      // required this.phone,
      // required this.driverId,
      // required this.equipment,
      required this.defaultContact,
      required this.defaultfDC,
      required this.defaultCY,
      required this.generalBloc});
  @override
  List<Object> get props =>
      [phone, equipment, defaultContact, defaultfDC, defaultCY, generalBloc];
}
