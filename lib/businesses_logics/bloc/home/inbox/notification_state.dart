part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPagingLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationItem> notificationList;
  final int quantity;

  const NotificationSuccess(
      {required this.notificationList, required this.quantity});
  @override
  List<Object?> get props => [notificationList, quantity];

  NotificationSuccess copyWith(
      {List<NotificationItem>? notificationList, int? quantity}) {
    return NotificationSuccess(
      notificationList: notificationList ?? this.notificationList,
      quantity: quantity ?? this.quantity,
    );
  }
}

class NotificationPagingSuccess extends NotificationState {
  final List<NotificationItem> notificationList;

  const NotificationPagingSuccess({required this.notificationList});
  @override
  List<Object?> get props => [notificationList];
}

class NotificationFailure extends NotificationState {
  final String message;
  final int? errorCode;
  const NotificationFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class NotificationUpdateSuccessfully extends NotificationState {}
