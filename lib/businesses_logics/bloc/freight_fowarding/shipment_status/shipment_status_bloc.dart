import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/freight_fowarding/shipment_status/shipment_status_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../../../data/shared/shared.dart';
import '../../general/general_bloc.dart';

part 'shipment_status_event.dart';
part 'shipment_status_state.dart';

class ShipmentStatusBloc
    extends Bloc<ShipmentStatusEvent, ShipmentStatusState> {
  final _shipmentStatusRepo = getIt<ShipmentStatusRepository>();
  ShipmentStatusBloc() : super(ShipmentStatusInitial()) {
    on<ShipmentStatusLoaded>(_mapViewToState);
    on<ShipmentStatusNextDate>(_mapNextDateToState);
    on<ShipmentStatusPreviousDate>(_mapPreviousDateToState);
    on<ShipmentStatusPickDate>(_mapPickDateToState);
  }

  Future<List<ShipmentStatusResponse>> _getShipmentStatusWithDate(
      {required DateTime eventDate,
      required String blNo,
      required String cntrNo,
      required String subsidiaryId,
      required String defaultClient}) async {
    final contactCode = defaultClient;
    final date = DateFormat(constants.formatyyyyMMdd).format(eventDate);

    final data = ShipmentStatusRequest(
      blNo: blNo,
      contactCode: contactCode,
      date: date,
      cntrNo: cntrNo,
    );

    final getShipment = await _shipmentStatusRepo.getListShipmentStatus(
        content: data, subsidiaryId: subsidiaryId);
    return getShipment;
  }

  void _mapViewToState(ShipmentStatusLoaded event, emit) async {
    emit(ShipmentStatusLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final listShipmentStatus = await _getShipmentStatusWithDate(
          defaultClient: userInfo.defaultClient ?? '',
          eventDate: event.date,
          blNo: event.blNo ?? "",
          cntrNo: event.cntrNo ?? "",
          subsidiaryId: event.generalBloc.generalUserInfo?.subsidiaryId ?? '');

      emit(ShipmentStatusSuccess(
        date: event.date,
        listShipmentStatus: listShipmentStatus,
      ));
    } catch (e) {
      emit(ShipmentStatusFailure(message: e.toString()));
    }
  }

  Future<void> _mapNextDateToState(ShipmentStatusNextDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ShipmentStatusSuccess) {
        emit(ShipmentStatusLoading());
        final nextDate = currentState.date.findNextDate;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final listShipmentStatus = await _getShipmentStatusWithDate(
          defaultClient: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
          eventDate: nextDate,
          blNo: event.blNo ?? "",
          cntrNo: event.cntrNo ?? "",
        );
        emit(currentState.copyWith(
          date: nextDate,
          listShipmentStatus: listShipmentStatus,
        ));
      }
    } catch (e) {
      emit(ShipmentStatusFailure(message: e.toString()));
    }
  }

  void _mapPreviousDateToState(ShipmentStatusPreviousDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ShipmentStatusSuccess) {
        emit(ShipmentStatusLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final previousDate = currentState.date.findPreviousDate;

        final listShipmentStatus = await _getShipmentStatusWithDate(
          defaultClient: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
          eventDate: previousDate,
          blNo: event.blNo ?? "",
          cntrNo: event.cntrNo ?? "",
        );
        emit(currentState.copyWith(
          date: previousDate,
          listShipmentStatus: listShipmentStatus,
        ));
      }
    } catch (e) {
      emit(ShipmentStatusFailure(message: e.toString()));
    }
  }

  void _mapPickDateToState(ShipmentStatusPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ShipmentStatusSuccess) {
        emit(ShipmentStatusLoading());
        final pickdate = event.pickDate;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final listShipmentStatus = await _getShipmentStatusWithDate(
          defaultClient: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
          eventDate: pickdate,
          blNo: event.blNo ?? "",
          cntrNo: event.cntrNo ?? "",
        );
        emit(currentState.copyWith(
          date: pickdate,
          listShipmentStatus: listShipmentStatus,
        ));
      }
    } catch (e) {
      emit(ShipmentStatusFailure(message: e.toString()));
    }
  }
}
