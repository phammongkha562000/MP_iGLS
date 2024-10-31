part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingSuccess extends SettingState {
  final bool isBiometric;
  final bool isAllowBiometric;
  const SettingSuccess(
      {required this.isAllowBiometric, required this.isBiometric});
  @override
  List<Object?> get props => [isAllowBiometric, isBiometric];

  SettingSuccess copyWith({
    bool? isAllowBiometric,
    bool? isBiometric,
  }) {
    return SettingSuccess(
      isAllowBiometric: isAllowBiometric ?? this.isAllowBiometric,
      isBiometric: isBiometric ?? this.isBiometric,
    );
  }
}

class SettingLogOutSuccess extends SettingState {}

class SettingFailure extends SettingState {
  final String message;
  final int? errorCode;
  const SettingFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
