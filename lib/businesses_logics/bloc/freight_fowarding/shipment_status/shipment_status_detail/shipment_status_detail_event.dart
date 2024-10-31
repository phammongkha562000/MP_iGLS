part of 'shipment_status_detail_bloc.dart';

abstract class ShipmentStatusDetailEvent extends Equatable {
  const ShipmentStatusDetailEvent();

  @override
  List<Object> get props => [];
}

class ShipmentStatusDetailLoaded extends ShipmentStatusDetailEvent {
  final String woNo;
  final String cntrNo;
  final String itemNo;
  final String bcNO;
  final String equipmentType;
  final GeneralBloc generalBloc;

  const ShipmentStatusDetailLoaded(
      {required this.woNo,
      required this.cntrNo,
      required this.itemNo,
      required this.bcNO,
      required this.equipmentType,
      required this.generalBloc});
  @override
  List<Object> get props =>
      [woNo, cntrNo, itemNo, bcNO, equipmentType, generalBloc];
}
