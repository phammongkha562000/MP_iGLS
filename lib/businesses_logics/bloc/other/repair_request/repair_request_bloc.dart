import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/global/global_user.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';

part 'repair_request_event.dart';
part 'repair_request_state.dart';

class RepairRequestBloc extends Bloc<RepairRequestEvent, RepairRequestState> {
  final _repairRepo = getIt<RepairRequestRepository>();
  // final _logger = Logger(GlobalApp.logz.toString());

  RepairRequestBloc() : super(RepairRequestInitial()) {
    on<RepairRequestViewLoaded>(_mapViewLoadedToState);
    on<RepairRequestSave>(_mapSaveToState);
  }
  Future<void> _mapViewLoadedToState(
      RepairRequestViewLoaded event, emit) async {
    emit(RepairRequestLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final equipmentNo = sharedPref.equipmentNo;
      final driverId = event.generalBloc.generalUserInfo?.empCode ?? '';
      if (equipmentNo == null || equipmentNo == "" || driverId == "") {
        emit(const RepairRequestFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        return;
      }
      final String driverName = globalUser.getFullname!;

      // if (event.pageId != null && event.pageName != null) {
      //   String accessDatetime = DateTime.now().toString().split('.').first;
      //   final contentQuickMenu = FrequentlyVisitPageRequest(
      //       userId:  event.generalBloc.generalUserInfo?.userId??'',
      //       subSidiaryId:  userInfo.subsidiaryId?? '',
      //       pageId: event.pageId!,
      //       pageName: event.pageName!,
      //       accessDatetime: accessDatetime,
      //       systemId: constants.systemId);
      //   final addFreqVisitResult =
      //       await _loginRepo.saveFreqVisitPage(content: contentQuickMenu);
      //   if (addFreqVisitResult.isFailure) {
      //     emit(RepairRequestFailure(
      //         message: addFreqVisitResult.getErrorMessage(),
      //         errorCode: addFreqVisitResult.errorCode));
      //     return;
      //   }
      // }

      emit(RepairRequestSuccess(
          equipmentNo: equipmentNo, driverName: driverName));
    } catch (e) {
      emit(const RepairRequestFailure(message: strings.messError));
    }
  }

  Future<void> _mapSaveToState(RepairRequestSave event, emit) async {
    try {
      final currentState = state;
      if (currentState is RepairRequestSuccess) {
        emit(RepairRequestLoading());

        final sharedPref = await SharedPreferencesService.instance;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = RepairRequestRequest(
          dcCode: userInfo.defaultCenter ?? '',
          equipmentCode: sharedPref.equipmentNo!,
          staffUserId: userInfo.empCode ?? '',
          currentMileage: int.parse(event.currentMileage),
          issueDesc: event.issueDesc,
          createUser: userInfo.userId ?? '',
        );
        final apiResult = await _repairRepo.saveRepairRequest(
            content: content, subsidiary:  userInfo.subsidiaryId?? '');
        if (apiResult.isFailure) {
          emit(RepairRequestFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResult.data;
        if (apiResponse.isSuccess != true) {
          emit(const RepairRequestFailure(message: strings.messError));
          emit(currentState);
          // _logger.severe(
          //   "Error",
          //   content.toMap(),
          // );
          return;
        }
        emit(currentState.copyWith(isSuccess: true));
      }
    } catch (e) {
      emit(const RepairRequestFailure(message: strings.messError));
    }
  }
}
