part of 'delivery_status_bloc.dart';

abstract class DeliveryStatusState extends Equatable {
  const DeliveryStatusState();

  @override
  List<Object?> get props => [];
}

class DeliveryStatusInitial extends DeliveryStatusState {}

class DeliveryStatusLoading extends DeliveryStatusState {}

class DeliveryStatusSuccess extends DeliveryStatusState {
  final List<ContactLocal> contactList;
  final DeliveryStatusResponse deliveryStatus;
  final String contactCode;
  const DeliveryStatusSuccess(
      {required this.contactList,
      required this.deliveryStatus,
      required this.contactCode});
  @override
  List<Object> get props => [contactList, deliveryStatus, contactCode];

  DeliveryStatusSuccess copyWith(
      {List<ContactLocal>? contactList,
      DeliveryStatusResponse? deliveryStatus,
      String? contactCode}) {
    return DeliveryStatusSuccess(
        contactList: contactList ?? this.contactList,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        contactCode: contactCode ?? this.contactCode);
  }
}

class DeliveryStatusFailure extends DeliveryStatusState {
  final int? errorCode;
  final String message;
  const DeliveryStatusFailure({
    this.errorCode,
    required this.message,
  });
  @override
  List<Object?> get props => [errorCode, message];
}
