import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:igls_new/data/repository/ware_house/inventory/inventory_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'inventory_detail_event.dart';
part 'inventory_detail_state.dart';

class InventoryDetailBloc
    extends Bloc<InventoryDetailEvent, InventoryDetailState> {
  final _inventoryRepo = getIt<InventoryRepository>();

  InventoryDetailBloc() : super(InventoryDetailInitial()) {
    on<InventoryDetailLoaded>(_mapViewToState);
  }

  void _mapViewToState(InventoryDetailLoaded event, emit) async {
    emit(InventoryDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final dataInventoryDetail = InventoryDetailRequest(
        sbNo: event.sbNo,
        contactCode: event.contactCode,
        dcCode: event.dcCode,
        companyId: userInfo.subsidiaryId ?? '',
      );
      final apiResultDetail =
          await _inventoryRepo.getInventoryDetail(content: dataInventoryDetail);
      if (apiResultDetail.isFailure) {
        emit(InventoryDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      InventoryDetailResponse getInventoryDetail = apiResultDetail.data;
      if (getInventoryDetail.stockReserves == null) {
        List<ReservedDetailResponse> listReservedDetail = [];
        emit(InventoryDetailSuccess(
          inventory: getInventoryDetail,
          listReserved: listReservedDetail,
        ));
      } else {
        log("${getInventoryDetail.stockReserves}");
        final listReservedDetail = List<ReservedDetailResponse>.from(
            jsonDecode(getInventoryDetail.stockReserves!)
                .map((x) => ReservedDetailResponse.fromMap((x))));

        emit(InventoryDetailSuccess(
          inventory: getInventoryDetail,
          listReserved: listReservedDetail,
        ));
      }
    } catch (e) {
      emit(InventoryDetailFailure(message: e.toString()));
    }
  }
}
