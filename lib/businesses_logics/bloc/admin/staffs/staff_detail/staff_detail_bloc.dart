import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/staffs/staff_update_request.dart';
import 'package:igls_new/data/models/staffs/vendor_request.dart';
import 'package:igls_new/data/models/staffs/vendor_response.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/services/result/api_result.dart';

import '../../../../../data/repository/repository.dart';
import '../../../../../data/services/services.dart';
import '../../../general/general_bloc.dart';

part 'staff_detail_event.dart';
part 'staff_detail_state.dart';

class StaffDetailBloc extends Bloc<StaffDetailEvent, StaffDetailState> {
  final _staffRepo = getIt<StaffsRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  final _taskHistoryRepo = getIt<TaskHistoryRepository>();

  StaffDetailBloc() : super(StaffDetailInitial()) {
    on<StaffDetailViewLoaded>(_mapViewLoadedToState);
    on<StaffDetailUpdate>(_mapUpdateToState);
    on<StaffDetailSelectedRelateDC>(_mapSelectedDCState);
  }
  Future<void> _mapViewLoadedToState(StaffDetailViewLoaded event, emit) async {
    emit(StaffDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final contentVendor = VendorRequest(
          contactCode: '',
          contactName: '',
          contactType: 'TV',
          country: '',
          isUse: 1);
      final results = await Future.wait([
        _staffRepo.getStaffDetailByUserId(
            userId: event.userId, subsidiary: userInfo.subsidiaryId ?? ''),
        _staffRepo.getVendors(
            content: contentVendor, subsidiary: userInfo.subsidiaryId ?? '')
      ]);
      ApiResult apiResultDetail = results[0];
      if (apiResultDetail.isFailure) {
        emit(StaffDetailFailure(
            message: apiResultDetail.getErrorMessage(),
            errorCode: apiResultDetail.errorCode));
        return;
      }
      StaffDetailResponse detail = apiResultDetail.data;

      List<StdCode> listStatusWorking = event.generalBloc.listWorkingStatus;
      if (listStatusWorking.isEmpty || listStatusWorking == []) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.staffStatusWorkingCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(StaffDetailFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        listStatusWorking = apiStdCode.data;
        event.generalBloc.listWorkingStatus = listStatusWorking;
      }

      List<DcLocal> getDcLocalList = event.generalBloc.listDC;
      if (detail.getDetail2 != null && detail.getDetail2 != []) {
        for (var element in detail.getDetail2!) {
          getDcLocalList = getDcLocalList
              .map((e) =>
                  e.dcCode == element.dcCode ? e.copyWith(isSelected: true) : e)
              .toList();
        }
      }

      List<StdCode> stdRoleTypeList = event.generalBloc.listRoleType;
      if (stdRoleTypeList.isEmpty || stdRoleTypeList == []) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.staffCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(StaffDetailFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        stdRoleTypeList = apiStdCode.data;
        event.generalBloc.listRoleType = stdRoleTypeList;
      }

      List<VendorResponse> venderList = [
        VendorResponse(contactCode: '', contactName: '')
      ];
      ApiResult apiVendor = results[1];
      if (apiVendor.isFailure) {
        emit(StaffDetailFailure(
            message: apiVendor.getErrorMessage(),
            errorCode: apiVendor.errorCode));
        return;
      }
      List<VendorResponse> getVendorList = apiVendor.data;
      venderList.addAll(getVendorList);

      List<EquipmentResponse> equipmentList = [
        EquipmentResponse(equipmentCode: '', equipmentDesc: '')
      ];

      List<EquipmentResponse> listEquipmentRes =
          event.generalBloc.listEquipmentRes;
      if (listEquipmentRes.isEmpty || listEquipmentRes == []) {
        final contentEquipment = EquipmentRequest(
            equipmentCode: '',
            equipmentDesc: '',
            equipTypeNo: '',
            ownership: '',
            equipmentGroup: '',
            dcCode: userInfo.defaultCenter ?? '');
        final apiResultEquipment = await _taskHistoryRepo.getEquipment3(
            content: contentEquipment,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultEquipment.isFailure) {
          emit(StaffDetailFailure(
              message: apiResultEquipment.getErrorMessage()));
          return;
        }
        listEquipmentRes = apiResultEquipment.data;
        event.generalBloc.listEquipmentRes = listEquipmentRes;
      }
      equipmentList.addAll(listEquipmentRes);
      emit(StaffDetailSuccess(
          staffDetail: detail,
          statusWorkingList: listStatusWorking,
          dcList: getDcLocalList,
          roleTypeList: stdRoleTypeList,
          venderList: venderList,
          equipmentList: equipmentList,
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          staffName: detail.getDetail1![0].staffName ?? '',
          equipment: detail.getDetail1![0].defaultEquipment ?? '',
          mobileNo: detail.getDetail1![0].mobileNo ?? '',
          remark: detail.getDetail1![0].remark ?? '',
          roleType: detail.getDetail1![0].roleType ?? '',
          statusWorking: detail.getDetail1![0].statusWorking ?? ''));
    } catch (e) {
      emit(StaffDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(StaffDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is StaffDetailSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = event.request;
        final apiUpdate = await _staffRepo.updateStaff(
            content: content, subsidiary: userInfo.subsidiaryId ?? '');
        if (apiUpdate.isFailure) {
          emit(StaffDetailFailure(
              message: apiUpdate.getErrorMessage(),
              errorCode: apiUpdate.errorCode));
          return;
        }
        StatusResponse apiResponse = apiUpdate.data;
        if (apiResponse.isSuccess == false) {
          emit(StaffDetailFailure(message: apiResponse.message));
          return;
        }
        emit(StaffDetailUpdateSuccessfully());
      }
    } catch (e) {
      emit(StaffDetailFailure(message: e.toString()));
    }
  }

  void _mapSelectedDCState(StaffDetailSelectedRelateDC event, emit) {
    try {
      final currentState = state;
      if (currentState is StaffDetailSuccess) {
        final newDC = currentState.dcList
            .map((e) => e.dcCode == event.dcCode
                ? e.copyWith(
                    isSelected: e.isSelected == null ? true : !e.isSelected!)
                : e)
            .toList();
        emit(currentState.copyWith(
          dcList: newDC,
          equipment: event.equipment.equipmentCode,
          mobileNo: event.phone,
          remark: event.remark,
          roleType: event.roleType.codeId,
          staffName: event.staffName,
          statusWorking: event.workingStatus.codeId,
        ));
      }
    } catch (e) {
      emit(StaffDetailFailure(message: e.toString()));
    }
  }
}
