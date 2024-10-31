import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_detail_response.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_update_request.dart';

import '../../../../../data/models/models.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import '../../../general/general_bloc.dart';

part 'equipment_detail_event.dart';
part 'equipment_detail_state.dart';

class EquipmentDetailBloc
    extends Bloc<EquipmentDetailEvent, EquipmentDetailState> {
  final _equipmentsRepo = getIt<EquipmentsRepository>();
  final _staffRepo = getIt<StaffsRepository>();
  static final _userProfileRepo = getIt<UserProfileRepository>();

  EquipmentDetailBloc() : super(EquipmentDetailInitial()) {
    on<EquipmentDetailViewLoaded>(_mapViewLoadedToState);
    on<EquipmentDetailSelectedRelateDC>(_mapSelectedDCState);
    on<EquipmentDetailUpdate>(_mapUpdateState);
  }
  Future<void> _mapViewLoadedToState(
      EquipmentDetailViewLoaded event, emit) async {
    emit(EquipmentDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final apiResultDetail = await _equipmentsRepo.getEquipmentDetail(
          subsidiary: userInfo.subsidiaryId ?? '',
          equipmentCode: event.equipmentCode);
      if (apiResultDetail.isFailure) {
        emit(EquipmentDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      EquipmentDetailResponse detail = apiResultDetail.data;
      List<StaffsResponse> staffList = [
        StaffsResponse(staffName: '', staffUserId: '')
      ];
      for (var element in detail.getDataDetail1!) {
        final content = StaffsRequest(
          dcCode: element.dcCode ?? '',
          staffName: '',
          staffUserId: '',
          roleType: '',
          mobileNo: '',
          isDeleted: event.isDeleted,
        );
        final apiResultStaff = await _staffRepo.getStaff(
            content: content, subsidiary: userInfo.subsidiaryId ?? '');

        if (apiResultStaff.isFailure) {
          emit(EquipmentDetailFailure(
              message: apiResultStaff.getErrorMessage(),
              errorCode: apiResultStaff.errorCode));
          return;
        }
        staffList.addAll(apiResultStaff.data);
      }

      List<DcLocal> getDcLocalList = event.generalBloc.listDC;
      if (getDcLocalList == [] || getDcLocalList.isEmpty) {
        final apiResult = await _userProfileRepo.getLocal(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId!);
        if (apiResult.isFailure) {
          emit(EquipmentDetailFailure(message: apiResult.getErrorMessage()));
          return;
        }
        getDcLocalList = apiResult.data;
        event.generalBloc.listDC = getDcLocalList;
      }

      if (detail.getDataDetail1 != null && detail.getDataDetail1 != []) {
        for (var element in detail.getDataDetail1!) {
          getDcLocalList = getDcLocalList
              .map((e) =>
                  e.dcCode == element.dcCode ? e.copyWith(isSelected: true) : e)
              .toList();
        }
      }

      emit(EquipmentDetailSuccess(
          dcList: getDcLocalList,
          detail: apiResultDetail.data,
          staffList: staffList));
    } catch (e) {
      emit(EquipmentDetailFailure(message: e.toString()));
    }
  }

  void _mapSelectedDCState(EquipmentDetailSelectedRelateDC event, emit) {
    try {
      final currentState = state;
      if (currentState is EquipmentDetailSuccess) {
        final newDC = currentState.dcList
            .map((e) => e.dcCode == event.dcCode
                ? e.copyWith(
                    isSelected: e.isSelected == null ? true : !e.isSelected!)
                : e)
            .toList();
        emit(currentState.copyWith(dcList: newDC));
      }
    } catch (e) {
      emit(EquipmentDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateState(EquipmentDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is EquipmentDetailSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final detail = currentState.detail.getDataDetail![0];
        final content = EquipmentUpdateRequest(
            equipmentCode: detail.equipmentCode ?? '',
            equipmentDesc: detail.equipmentDesc ?? '',
            equipTypeNo: detail.equipTypeNo ?? '',
            ownership: detail.ownership ?? "",
            brand: detail.brand ?? '',
            model: detail.model ?? '',
            color: detail.color ?? '',
            refEquipCode: detail.refEquipCode ?? '',
            assetCode: detail.assetCode ?? '',
            serialNumber: detail.serialNumber ?? '',
            latestMileage: detail.latestMileage ?? 0,
            purchaseAmt: detail.purchaseAmt ?? 0,
            purchaseDate: detail.purchaseDate ?? '',
            rentalAmtPerMonth: detail.rentalAmtPerMonth ?? 0,
            soldDate: detail.soldDate,
            soldAmt: detail.soldAmt ?? 0,
            dcCode: detail.dcCode ?? '',
            createUser: detail.createUser ?? '',
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
            currency: detail.currency ?? '',
            defaultStaffId: event.staffId,
            listDcCode: currentState.dcList
                .where((e) => e.isSelected == true)
                .map((e) => e.dcCode)
                .join(',')
                .toString(),
            fuelConsumption: detail.fuelNorm,
            gpsVendor: detail.gpsVendor,
            remarks: event.remark,
            equipStatus: detail.equipStatus);

        final apiResultUpdate = await _equipmentsRepo.updateEquipment(
            subsidiary: userInfo.subsidiaryId ?? '', content: content);
        if (apiResultUpdate.isFailure) {
          emit(EquipmentDetailFailure(
              message: apiResultUpdate.getErrorMessage(),
              errorCode: apiResultUpdate.errorCode));
          return;
        }
        emit(EquipmentDetailUpdateSuccessfully());
      }
    } catch (e) {
      emit(EquipmentDetailFailure(message: e.toString()));
    }
  }
}
