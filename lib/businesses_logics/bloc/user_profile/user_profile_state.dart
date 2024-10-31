part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final String? phone;
  final String? driverId;
  final String? equipment;
  final String? contactCode;
  final String? dcCode;
  final String? cyCode;
  final bool? isSuccess;
  final String? role;

  final List<ContactLocal>? listContactLocal;
  final List<DcLocal>? listDCLocal;
  final List<CySiteResponse>? listCY;
  const UserProfileSuccess({
    this.isSuccess,
    this.phone,
    this.driverId,
    this.equipment,
    this.contactCode,
    this.dcCode,
    this.cyCode,
    this.listContactLocal,
    this.listDCLocal,
    this.listCY,
    this.role,
  });
  @override
  List<Object?> get props =>
      [contactCode, listContactLocal, listDCLocal, listCY, isSuccess, role];

  UserProfileSuccess copyWith({
    String? phone,
    String? driverId,
    String? equipment,
    String? contactCode,
    String? dcCode,
    String? cyCode,
    bool? isSuccess,
    String? role,
    List<ContactLocal>? listContactLocal,
    List<DcLocal>? listDCLocal,
    List<CySiteResponse>? listCY,
  }) {
    return UserProfileSuccess(
      phone: phone ?? this.phone,
      driverId: driverId ?? this.driverId,
      equipment: equipment ?? this.equipment,
      contactCode: contactCode ?? this.contactCode,
      dcCode: dcCode ?? this.dcCode,
      cyCode: cyCode ?? this.cyCode,
      isSuccess: isSuccess ?? this.isSuccess,
      role: role ?? this.role,
      listContactLocal: listContactLocal ?? this.listContactLocal,
      listDCLocal: listDCLocal ?? this.listDCLocal,
      listCY: listCY ?? this.listCY,
    );
  }
}

// class UserProfileUpdateSuccess extends UserProfileState {}

class UserProfileFailure extends UserProfileState {
  final String message;
  final int? errorCode;
  const UserProfileFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
