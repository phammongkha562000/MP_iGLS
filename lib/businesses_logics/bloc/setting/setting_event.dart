part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class SettingViewLoaded extends SettingEvent {
  final String? pageId;
  final String? pageName;
  const SettingViewLoaded({
    this.pageId,
    this.pageName,
  });
  @override
  List<Object?> get props => [pageId, pageName];
}

class LogOut extends SettingEvent {}

class BiometricChanged extends SettingEvent {
  final bool isAllowBiometric;
  const BiometricChanged({
    required this.isAllowBiometric,
  });
  @override
  List<Object?> get props => [isAllowBiometric];
}
