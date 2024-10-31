// ignore_for_file: unused_element

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/freight_fowarding/shipment_status/shipment_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'shipment_status_detail_event.dart';
part 'shipment_status_detail_state.dart';

class ShipmentStatusDetailBloc
    extends Bloc<ShipmentStatusDetailEvent, ShipmentStatusDetailState> {
  final _shipmentStatusRepo = getIt<ShipmentStatusRepository>();

  ShipmentStatusDetailBloc() : super(ShipmentStatusDetailInitial()) {
    on<ShipmentStatusDetailLoaded>(_mapViewToState);
  }

  Future<void> _mapViewToState(ShipmentStatusDetailLoaded event, emit) async {
    try {
      emit(ShipmentStatusDetailLoading());

    UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final getDetail = await _shipmentStatusRepo.getDetailShipmentStatus(
        woNo: event.woNo,
        cntrNo: event.cntrNo,
        itemNo: event.itemNo,
        subsidiaryId:  userInfo.subsidiaryId?? '',
      );

      final listEquipTask = getDetail.equipTasks;
      final listOrderEquipment = getDetail.orderEquipments;

      emit(ShipmentStatusDetailSuccess(
        bcNo: event.bcNO,
        equipmentType: event.equipmentType,
        listEquipTasks: listEquipTask,
        listOrderEquipments: listOrderEquipment,
      ));
    } catch (e) {
      emit(ShipmentStatusDetailFailure(message: e.toString()));
    }
  }
}
