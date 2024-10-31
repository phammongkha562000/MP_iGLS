import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../data/repository/repository.dart';
import '../../../../../data/services/services.dart';
import '../../../general/general_bloc.dart';

part 'staffs_event.dart';
part 'staffs_state.dart';

class StaffsBloc extends Bloc<StaffsEvent, StaffsState> {
  final _staffRepo = getIt<StaffsRepository>();
  final _userProfileRepo = getIt<UserProfileRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  StaffsBloc() : super(StaffsInitial()) {
    on<StaffsViewLoaded>(_mapViewLoadedToState);
    on<StaffsSearch>(_mapSearchToState);
    on<StaffsQuickSearch>(_mapQuickSearchToState);
  }
  Future<void> _mapViewLoadedToState(StaffsViewLoaded event, emit) async {
    emit(StaffsLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final dcLocal = userInfo.defaultCenter ?? '';

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

      List<StdCode> roleTypeList = [
        StdCode(codeDesc: '', codeId: '', codeType: '')
      ];

      List<StdCode> stdRoleTypeList = event.generalBloc.listRoleType;
      if (stdRoleTypeList.isEmpty || stdRoleTypeList == []) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.staffCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(StaffsFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        stdRoleTypeList = apiStdCode.data;
        event.generalBloc.listRoleType = stdRoleTypeList;
      }
      roleTypeList.addAll(stdRoleTypeList);

      final dcLocalSearch =
          dcLocalList.where((element) => element.dcCode == dcLocal).single;
      emit(StaffsSuccess(
          staffList: const [],
          staffListSearch: const [],
          dcList: dcList,
          roleTypeList: roleTypeList,
          staffIDSearch: '',
          staffNameSearch: '',
          dcLocalSearch: dcLocalSearch,
          roleTypeSearch: roleTypeList.first,
          isDeleted: false));
    } catch (e) {
      emit(StaffsFailure(message: e.toString()));
    }
  }

  Future<void> _mapSearchToState(StaffsSearch event, emit) async {
    try {
      final currentState = state;
      if (currentState is StaffsSuccess) {
        emit(StaffsLoading());
        final dcCode = event.dcCode;
        final staffName = event.staffName;
        final staffUserId = event.staffID;
        final roleType = event.roleType;
        final isDeleted = event.isDeleted ? 1 : 0;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = StaffsRequest(
            dcCode: dcCode == null ? '' : dcCode.dcCode ?? '',
            staffName: staffName,
            staffUserId: staffUserId,
            roleType: roleType == null ? '' : roleType.codeId ?? '',
            mobileNo: '',
            isDeleted: isDeleted);
        final apiResult = await _staffRepo.getStaff(
            content: content, subsidiary: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(StaffsFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }

        List<StaffsResponse> staffList = apiResult.data;
        emit(currentState.copyWith(
            staffListSearch: staffList,
            staffList: staffList,
            staffNameSearch: staffName,
            staffIDSearch: staffUserId,
            dcLocalSearch: dcCode,
            roleTypeSearch: roleType,
            isDeleted: event.isDeleted));
      }
    } catch (e) {
      emit(StaffsFailure(message: e.toString()));
    }
  }

  void _mapQuickSearchToState(StaffsQuickSearch event, emit) {
    try {
      final currentState = state;
      if (currentState is StaffsSuccess) {
        final quickSearch = event.textSearch == ''
            ? currentState.staffList
            : currentState.staffList
                .where((element) =>
                    (TiengViet.parse(element.staffUserId.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())) ||
                    (TiengViet.parse(element.staffName.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())) ||
                    (TiengViet.parse(element.defaultEquipment.toString())
                        .toUpperCase()
                        .contains(
                            TiengViet.parse(event.textSearch).toUpperCase())))
                .toList();
        emit(currentState.copyWith(staffListSearch: quickSearch));
      }
    } catch (e) {
      emit(StaffsFailure(message: e.toString()));
    }
  }
}
