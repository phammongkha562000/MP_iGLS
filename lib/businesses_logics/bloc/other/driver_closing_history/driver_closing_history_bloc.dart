import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_request.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_response.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';
part 'driver_closing_history_event.dart';
part 'driver_closing_history_state.dart';

class DriverClosingHistoryBloc
    extends Bloc<DriverClosingHistoryEvent, DriverClosingHistoryState> {
  final _manualDriverClosingRepo = getIt<ManualDriverClosingRepository>();
  static final _userProfileRepo = getIt<UserProfileRepository>();

  DriverClosingHistoryBloc() : super(DriverClosingHistoryInitial()) {
    on<DriverClosingHistoryViewLoaded>(_mapViewLoadedToState);
    on<DriverClosingHistoryPreviousDateLoaded>(_mapPreviousToState);
    on<DriverClosingHistoryNextDateLoaded>(_mapNextToState);
    on<DriverClosingHistoryPickDate>(_mapPickDateToState);
  }
  Future<void> _mapViewLoadedToState(
      DriverClosingHistoryViewLoaded event, emit) async {
    emit(DriverClosingHistoryLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final empCode = event.generalBloc.generalUserInfo?.empCode;
      if (sharedPref.equipmentNo == null ||
          empCode == null ||
          sharedPref.equipmentNo == '' ||
          empCode == '') {
        emit(const DriverClosingHistoryFailure(
            message: strings.messErrorNoEquipment,
            errorCode: constants.errorNullEquipDriverId));
        return;
      }
      final apiResult = await _getDriverClosingHistory(
          contactList: event.generalBloc.listContactLocal,
          userInfo: userInfo,
          eventDate: event.date,
          orderNo: event.orderNo ?? '',
          tripNo: event.tripNo ?? '');
      if (apiResult.isFailure) {
        emit(DriverClosingHistoryFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<DriverClosingHistoryResponse> driverClosingHistoryList =
          apiResult.data;

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
          emit(DriverClosingHistoryFailure(
              message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }

      emit(DriverClosingHistorySuccess(
          historyList: driverClosingHistoryList,
          date: event.date,
          localList: contactLocalList));
    } catch (e) {
      emit(const DriverClosingHistoryFailure(message: strings.messError));
    }
  }

  Future<void> _mapPreviousToState(
      DriverClosingHistoryPreviousDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is DriverClosingHistorySuccess) {
        emit(DriverClosingHistoryLoading());

        final previous = currentState.date.findPreviousDate;
        final apiResult = await _getDriverClosingHistory(
            contactList: event.generalBloc.listContactLocal,
            userInfo: event.generalBloc.generalUserInfo ?? UserInfo(),
            eventDate: previous,
            contactCode: event.contactCode,
            orderNo: '',
            tripNo: '');
        if (apiResult.isFailure) {
          emit(DriverClosingHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<DriverClosingHistoryResponse> driverClosingHistoryList =
            apiResult.data;
        emit(currentState.copyWith(
            date: previous,
            isSuccess: true,
            historyList: driverClosingHistoryList));
      }
    } catch (e) {
      emit(const DriverClosingHistoryFailure(message: strings.messError));
    }
  }

  Future<void> _mapNextToState(
      DriverClosingHistoryNextDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is DriverClosingHistorySuccess) {
        emit(DriverClosingHistoryLoading());

        final next = currentState.date.findNextDate;
        final apiResult = await _getDriverClosingHistory(
            contactList: event.generalBloc.listContactLocal,
            userInfo: event.generalBloc.generalUserInfo ?? UserInfo(),
            eventDate: next,
            contactCode: event.contactCode,
            orderNo: '',
            tripNo: '');
        if (apiResult.isFailure) {
          emit(DriverClosingHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<DriverClosingHistoryResponse> driverClosingHistoryList =
            apiResult.data;
        emit(currentState.copyWith(
            date: next,
            isSuccess: true,
            historyList: driverClosingHistoryList));
      }
    } catch (e) {
      emit(const DriverClosingHistoryFailure(message: strings.messError));
    }
  }

  Future<void> _mapPickDateToState(
      DriverClosingHistoryPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is DriverClosingHistorySuccess) {
        emit(DriverClosingHistoryLoading());

        final date = event.date ?? currentState.date;
        final apiResult = await _getDriverClosingHistory(
            contactList: event.generalBloc.listContactLocal,
            userInfo: event.generalBloc.generalUserInfo ?? UserInfo(),
            eventDate: date,
            orderNo: event.orderNo ?? '',
            contactCode:
                event.contact == null ? '' : event.contact!.contactCode ?? '',
            tripNo: event.tripNo ?? '');
        if (apiResult.isFailure) {
          emit(DriverClosingHistoryFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<DriverClosingHistoryResponse> driverClosingHistoryList =
            apiResult.data;
        emit(currentState.copyWith(
            date: date,
            isSuccess: true,
            historyList: driverClosingHistoryList));
      }
    } catch (e) {
      emit(const DriverClosingHistoryFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getDriverClosingHistory(
      {required DateTime eventDate,
      required String orderNo,
      required String tripNo,
      String? contactCode,
      required UserInfo userInfo,
      required List<ContactLocal> contactList}) async {
    // final date = DateFormat('yyyy/MM/dd').format(eventDate);
    final date = DateFormat('yyyyMMdd').format(eventDate);
    final content = DriverClosingHistoryRequest(
        tripDateF: date,
        tripDateT: date,
        driverTripType: '',
        tripNo: tripNo,
        orderNo: orderNo,
        driverId: userInfo.empCode ?? '',
        closingStatus: '',
        contactCode: contactCode ??
            '' /*  (contactCode == null || contactCode == '')
            ? contactList.map((e) => e.contactCode).toList().join(',')
            : contactCode */
        ,
        companyId: userInfo.subsidiaryId!);
    return await _manualDriverClosingRepo.getDriverClosingHistory(
        content: content);
  }
}
