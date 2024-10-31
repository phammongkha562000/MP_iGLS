part of 'delivery_status_bloc.dart';

abstract class DeliveryStatusEvent extends Equatable {
  const DeliveryStatusEvent();

  @override
  List<Object?> get props => [];
}

class DeliveryStatusViewLoaded extends DeliveryStatusEvent {
  final String? contactCode;
  final String? pageId;
  final String? pageName;
  final GeneralBloc generalBloc;

  const DeliveryStatusViewLoaded(
      {this.contactCode,
      this.pageId,
      this.pageName,
      required this.generalBloc});

  @override
  List<Object> get props => [
        [contactCode, pageId, pageName, generalBloc]
      ];
}

class DeliveryStatusChangeContact extends DeliveryStatusEvent {
  final String? contactCode;
  final GeneralBloc generalBloc;
  const DeliveryStatusChangeContact(
      {this.contactCode, required this.generalBloc});
  @override
  List<Object?> get props => [contactCode, generalBloc];
}
