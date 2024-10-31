part of 'shipment_status_bloc.dart';

abstract class ShipmentStatusState extends Equatable {
  const ShipmentStatusState();

  @override
  List<Object?> get props => [];
}

class ShipmentStatusInitial extends ShipmentStatusState {}

class ShipmentStatusLoading extends ShipmentStatusState {}

class ShipmentStatusSuccess extends ShipmentStatusState {
  final bool? isLoading;
  final DateTime date;
  final List<ShipmentStatusResponse>? listShipmentStatus;
  const ShipmentStatusSuccess({
    this.isLoading,
    required this.date,
    this.listShipmentStatus,
  });

  @override
  List<Object?> get props => [isLoading, date, listShipmentStatus];

  ShipmentStatusSuccess copyWith({
    bool? isLoading,
    DateTime? date,
    List<ShipmentStatusResponse>? listShipmentStatus,
  }) {
    return ShipmentStatusSuccess(
      isLoading: isLoading ?? this.isLoading,
      date: date ?? this.date,
      listShipmentStatus: listShipmentStatus ?? this.listShipmentStatus,
    );
  }
}

class ShipmentStatusFailure extends ShipmentStatusState {
  final String message;
  final int? errorCode;
  const ShipmentStatusFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
