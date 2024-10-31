import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/equipments_admin/equipment_type_response.dart';
import 'package:igls_new/data/models/equipments_admin/equipments_request.dart';
import 'package:igls_new/data/models/equipments_admin/equipments_response.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/services/services.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../data/repository/repository.dart';
import '../../../general/general_bloc.dart';

part 'equipments_event.dart';
part 'equipments_state.dart';

class EquipmentsBloc extends Bloc<EquipmentsEvent, EquipmentsState> {
  final _equipmentsRepo = getIt<EquipmentsRepository>();
  final _userProfileRepo = getIt<UserProfileRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  EquipmentsBloc() : super(EquipmentsInitial()) {
    on<EquipmentsViewLoaded>(_mapViewLoadedToState);
    on<EquipmentsSearch>(_mapSearchToState);
    on<EquipmentsQuickSearch>(_mapQuickSearchToState);
  }
  Future<void> _mapViewLoadedToState(EquipmentsViewLoaded event, emit) async {
    emit(EquipmentsLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final dcLocal = userInfo.defaultCenter ?? '';
      final apiEquipType = await _equipmentsRepo.getEquipmentType(
          subsidiary: userInfo.subsidiaryId ?? '',
          strEquipTypeNo: '',
          strEquipTypeDesc: '');
      if (apiEquipType.isFailure) {
        emit(EquipmentsFailure(
            message: apiEquipType.getErrorMessage(),
            errorCode: apiEquipType.errorCode));
        return;
      }
      List<EquipmentTypeResponse> equipTypeList = [
        EquipmentTypeResponse(equipTypeDesc: '', equipTypeNo: '')
      ];
      equipTypeList.addAll(apiEquipType.data);
      List<DcLocal> dcList = [
        DcLocal(dcCode: '', dcDesc: '5059'.tr(), branchCode: '')
      ];
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;
      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userProfileRepo.getLocal(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId!);
        if (apiResult.isFailure) {
          emit(HaulageActivityFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }
      dcList.addAll(dcLocalList);
      final dcSearch =
          dcList.firstWhere((element) => element.dcCode == dcLocal);
      List<StdCode> ownershipList = [StdCode(codeDesc: '', codeId: '')];
      List<StdCode> listOwnership = event.generalBloc.listOwnership;
      if (listOwnership == [] || listOwnership.isEmpty) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.ownershipCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(EquipmentsFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        listOwnership = apiStdCode.data;
        event.generalBloc.listOwnership = listOwnership;
      }
      ownershipList.addAll(listOwnership);
      List<StdCode> equipmentGroupList = [StdCode(codeDesc: '', codeId: '')];
      List<StdCode> listEquipmentGroup = event.generalBloc.listEquipmentGroup;
      if (listEquipmentGroup == [] || listEquipmentGroup.isEmpty) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.equipmentGroupCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(EquipmentsFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        listEquipmentGroup = apiStdCode.data;
        event.generalBloc.listEquipmentGroup = listEquipmentGroup;
      }
      equipmentGroupList.addAll(listEquipmentGroup);
      emit(EquipmentsSuccess(
          dcList: dcList,
          equipmentsList: const [],
          equipmentsListSearch: const [],
          ownershipList: ownershipList,
          equipmentGroup: equipmentGroupList,
          equipmentTypeList: equipTypeList,
          dcSearch: dcSearch,
          equipmentGroupSearch: equipmentGroupList.first,
          equipmentTypeSearch: equipTypeList.first,
          ownershipSearch: ownershipList.first,
          assetCode: '',
          equipmentCode: '',
          equipmentDesc: '',
          serialNumber: ''));
    } catch (e) {
      emit(EquipmentsFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchToState(EquipmentsSearch event, emit) async {
    try {
      final currentState = state;
      if (currentState is EquipmentsSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
        emit(EquipmentsLoading());
        final dcCode = event.dcSearch;
        final equipTypeNo = event.equipmentTypeSearch;
        final equipmentCode = event.equipmentCode;
        final equipmentDesc = event.equipmentDesc;
        final ownership = event.ownershipSearch;
        final assetCode = event.assetCode;
        final serialNumber = event.serialNumber;
        final equipmentGroup = event.equipmentGroupSearch;

        final contentEquipments = EquipmentsRequest(
            dcCode: dcCode.dcCode ?? '',
            equipTypeNo: equipTypeNo.equipTypeNo ?? '',
            equipmentCode: equipmentCode,
            equipmentDesc: equipmentDesc,
            ownership: ownership.codeId ?? '',
            assetCode: assetCode,
            serialNumber: serialNumber,
            equipmentGroup: equipmentGroup.codeId ?? '');
        final apiResultSearch = await _equipmentsRepo.getEquipments(
            subsidiary: userInfo.subsidiaryId ?? '',
            content: contentEquipments);
        if (apiResultSearch.isFailure) {
          emit(EquipmentsFailure(
              message: apiResultSearch.getErrorMessage(),
              errorCode: apiResultSearch.errorCode));
          return;
        }
        emit(currentState.copyWith(
            assetCode: assetCode,
            dcSearch: dcCode,
            equipmentCode: equipmentCode,
            equipmentDesc: equipmentDesc,
            equipmentGroupSearch: equipmentGroup,
            equipmentTypeSearch: equipTypeNo,
            ownershipSearch: ownership,
            serialNumber: serialNumber,
            equipmentsList: apiResultSearch.data,
            equipmentsListSearch: apiResultSearch.data));
      }
    } catch (e) {
      emit(EquipmentsFailure(message: e.toString()));
    }
  }

  void _mapQuickSearchToState(EquipmentsQuickSearch event, emit) {
    try {
      final currentState = state;
      if (currentState is EquipmentsSuccess) {
        final quickSearch = event.textSearch == ''
            ? currentState.equipmentsList
            : currentState.equipmentsList
                .where((element) =>
                    (TiengViet.parse(element.equipmentCode.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())) ||
                    (TiengViet.parse(element.staffName.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())) ||
                    (TiengViet.parse(element.defaultStaffId.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())) ||
                    (TiengViet.parse(element.staffName.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())))
                .toList();
        emit(currentState.copyWith(equipmentsListSearch: quickSearch));
      }
    } catch (e) {
      emit(EquipmentsFailure(message: e.toString()));
    }
  }
}
