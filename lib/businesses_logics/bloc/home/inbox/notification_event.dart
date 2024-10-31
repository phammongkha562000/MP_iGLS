part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationViewLoaded extends NotificationEvent {
  final GeneralBloc generalBloc;
  const NotificationViewLoaded({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class NotificationUpdateStatus extends NotificationEvent {
  final GeneralBloc generalBloc;

  final String reqIds;
  final String status;
  final int templateId;
  const NotificationUpdateStatus({
    required this.generalBloc,
    required this.reqIds,
    required this.status,
    required this.templateId,
  });
  @override
  List<Object> get props => [reqIds, status, templateId, generalBloc];
}

class NotificationChecked extends NotificationEvent {
  final int reqId;
  final bool isChecked;
  const NotificationChecked({
    required this.reqId,
    required this.isChecked,
  });
  @override
  List<Object> get props => [reqId, isChecked];
}

class NotificationUpdateMultiple extends NotificationEvent {
  final GeneralBloc generalBloc;
  const NotificationUpdateMultiple({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class NotificationUpdateAll extends NotificationEvent {
  final GeneralBloc generalBloc;
  const NotificationUpdateAll({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class NotificationDeleteNotification extends NotificationEvent {
  final int reqId;
  final GeneralBloc generalBloc;

  const NotificationDeleteNotification({
    required this.reqId,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [reqId, generalBloc];
}

class NotificationDeleteMultiple extends NotificationEvent {
  final GeneralBloc generalBloc;
  const NotificationDeleteMultiple({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class NotificationDeleteAll extends NotificationEvent {
  final GeneralBloc generalBloc;
  const NotificationDeleteAll({
    required this.generalBloc,
  });
  @override
  List<Object> get props => [generalBloc];
}

class NotificationUnCheckedMultiple extends NotificationEvent {}

class NotificationPaging extends NotificationEvent {
  final String userId;
  const NotificationPaging({
    required this.userId,
  });
  @override
  List<Object> get props => [userId];
}
