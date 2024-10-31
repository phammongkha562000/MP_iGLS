part of 'shipment_status_detail_bloc.dart';

abstract class ShipmentStatusDetailState extends Equatable {
  const ShipmentStatusDetailState();

  @override
  List<Object?> get props => [];
}

class ShipmentStatusDetailInitial extends ShipmentStatusDetailState {}

class ShipmentStatusDetailLoading extends ShipmentStatusDetailState {}

class ShipmentStatusDetailSuccess extends ShipmentStatusDetailState {
  final String? bcNo;
  final String? blNo;
  final String? cntrNo;
  final String? equipmentType;
  final List<EquipTask>? listEquipTasks;
  final List<OrderEquipment>? listOrderEquipments;
  const ShipmentStatusDetailSuccess({
    this.bcNo,
    this.blNo,
    this.cntrNo,
    this.equipmentType,
    this.listEquipTasks,
    this.listOrderEquipments,
  });
  @override
  List<Object?> get props =>
      [bcNo, blNo, cntrNo, equipmentType, listEquipTasks, listEquipTasks];
}

class ShipmentStatusDetailFailure extends ShipmentStatusDetailState {
  final String message;
  final int? errorCode;
  const ShipmentStatusDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
