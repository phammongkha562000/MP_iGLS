import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/repository/repository.dart';
import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'update_shuttle_trip_event.dart';
part 'update_shuttle_trip_state.dart';

class UpdateShuttleTripBloc
    extends Bloc<UpdateShuttleTripEvent, UpdateShuttleTripState> {
  final _shuttleTripRepo = getIt<ShuttleTripRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  UpdateShuttleTripBloc() : super(UpdateShuttleTripInitial()) {
    on<UpdateShuttleTripViewLoaded>(_mapViewLoadedToState);
    on<UpdateShuttleTripPressed>(_mapPressedToState);
    on<UpdateShuttleTripDelete>(_mapDeleteToState);
  }
  Future<void> _mapViewLoadedToState(
      UpdateShuttleTripViewLoaded event, emit) async {
    emit(UpdateShuttleTripLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final sharedPref = await SharedPreferencesService.instance;

      final content = GetCompanysbyTypeRequest(
          contactCode: userInfo.defaultClient ?? '',
          companyCode: '',
          companyName: '',
          companyType: '');
      final apiCompany = await _shuttleTripRepo.getCompanysbyType(
          content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiCompany.isFailure) {
        emit(UpdateShuttleTripFailure(
            message: apiCompany.getErrorMessage(),
            errorCode: apiCompany.errorCode));
        return;
      }
      List<CompanyResponse> listCompany = apiCompany.data;
      final results = await Future.wait([
        _getListFreq(
          userInfo: userInfo,
          companyType: 'FROM',
          userId: userInfo.userId ?? '',
        ),
        _getListFreq(
          userInfo: userInfo,
          companyType: 'TO',
          userId: userInfo.userId ?? '',
        )
      ]);

      ApiResult getListFreqCompanyFrom = results[0];
      if (getListFreqCompanyFrom.isFailure) {
        emit(UpdateShuttleTripFailure(
            message: getListFreqCompanyFrom.getErrorMessage(),
            errorCode: getListFreqCompanyFrom.errorCode));
        return;
      }

      List<CompanyFreqResponse> apiCompanyFreqFrom =
          getListFreqCompanyFrom.data;

      ApiResult getListFreqCompanyTo = results[1];
      if (getListFreqCompanyTo.isFailure) {
        emit(UpdateShuttleTripFailure(
            message: getListFreqCompanyTo.getErrorMessage(),
            errorCode: getListFreqCompanyTo.errorCode));
        return;
      }
      List<CompanyFreqResponse> apiCompanyFreqTo = getListFreqCompanyTo.data;

      List<StdCode> listStdShuttle = event.generalBloc.listStdShuttle;
      if (listStdShuttle.isEmpty || listStdShuttle == []) {
        final apiStdCode = await _toDoTripRepo.getStdCode(
            stdCode: StdCodeType.shuttleTripCodetype,
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiStdCode.isFailure) {
          emit(UpdateShuttleTripFailure(message: apiStdCode.getErrorMessage()));
          return;
        }
        List<StdCode> listStd = apiStdCode.data;
        event.generalBloc.listStdShuttle = listStd;
        listStdShuttle = listStd;
      }

      final stdString = sharedPref.stdTripModeFreq;
      List<StdCode> freqTripModeList = [];
      List<StdCode> freq4TripModeList = [];
      if (stdString != null && stdString != '') {
        final a = jsonDecode(stdString);
        freqTripModeList =
            List<StdCode>.from(a.map((e) => StdCode.fromJson(e)));
        final aa = freqTripModeList.reversed;
        //và lấy 4 phần tử đầu tiên
        freq4TripModeList = aa.take(4).toList();
      } else {
        freqTripModeList = [];
      }

      final ShuttleTripsResponse shuttleTrip = event.shuttleTrip;
      emit(UpdateShuttleTripSuccess(
          dateTime: event.dateTime ?? DateTime.now(),
          listStdFreq: freq4TripModeList,
          companyList: listCompany,
          listStd: listStdShuttle,
          shuttleTrip: shuttleTrip,
          companyFreqFrom: apiCompanyFreqFrom,
          companyFreqTo: apiCompanyFreqTo));
    } catch (e) {
      emit(UpdateShuttleTripFailure(message: e.toString()));
    }
  }

  void _mapPressedToState(UpdateShuttleTripPressed event, emit) async {
    try {
      final currentState = state;
      if (currentState is UpdateShuttleTripSuccess) {
        emit(UpdateShuttleTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
        final startTime = '${event.startDate} ${event.startTime}';
        final endTime = '${event.endDate} ${event.endTime}';
        final sharedPref = await SharedPreferencesService.instance;
        final shuttleTrip = currentState.shuttleTrip;
        final startLoc = event.fromId;
        final endLoc = event.toId;

        final content = SaveShuttleTripRequest(
            sTId: shuttleTrip.stId,
            dCCode: shuttleTrip.dcCode!,
            contactCode: shuttleTrip.contactCode!,
            startLoc: startLoc,
            qty: double.parse(event.quantity),
            invoiceNo: event.invoiceNo,
            itemNote: event.sealNo,
            shipmentNo: event.shipmentNo,
            tripMode: event.tripModeId,
            endLoc: endLoc,
            startTime: startTime,
            endTime: endTime,
            isPosted: shuttleTrip.isPosted,
            updateUser: userInfo.userId ?? '',
            equipmentCode: sharedPref.equipmentNo!,
            sLat: currentState.shuttleTrip.sLat,
            sLon: currentState.shuttleTrip.sLon,
            eLat: currentState.shuttleTrip.eLat,
            eLon: currentState
                .shuttleTrip.eLon); //Chưa thay đổi location start, end

        final apiResultUpdate = await _shuttleTripRepo.updateShuttleTrip(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultUpdate.isFailure) {
          emit(UpdateShuttleTripFailure(
              message: apiResultUpdate.getErrorMessage(),
              errorCode: apiResultUpdate.errorCode));
          return;
        }
        StatusResponse apiUpdate = apiResultUpdate.data;
        if (apiUpdate.isSuccess != true) {
          emit(UpdateShuttleTripFailure(message: apiUpdate.message ?? ''));
          emit(currentState);
          return;
        }
        final stID = currentState.shuttleTrip.stId;
        final apiResultList = await _getShuttleTrips(
          userInfo: userInfo,
          dateTime: currentState.dateTime,
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
        );
        if (apiResultList.isFailure) {
          emit(UpdateShuttleTripFailure(
              message: apiResultList.getErrorMessage(),
              errorCode: apiResultList.errorCode));
          return;
        }
        List<ShuttleTripsResponse> apiResponseList = apiResultList.data;
        final ShuttleTripsResponse shuttleTripNew =
            apiResponseList.where((element) => element.stId == stID!).single;

        final stdString = sharedPref.stdTripModeFreq;
        List<StdCode> freqTripModeList = [];
        if (stdString != null && stdString != '') {
          final a = jsonDecode(stdString);
          freqTripModeList =
              List<StdCode>.from(a.map((e) => StdCode.fromJson(e)));
        } else {
          freqTripModeList = [];
        }

        final tripModeIsExits = freqTripModeList
                .where((element) => element.codeId == event.tripModeId)
                .isEmpty
            ? false
            : true;
        if (!tripModeIsExits) {
          freqTripModeList.add(currentState.listStd
              .where((element) => element.codeId == event.tripModeId)
              .first);
          final stdEndcode = jsonEncode(freqTripModeList);
          sharedPref.setStdTripModeFreq(stdEndcode);
        }
        final stdString2 = sharedPref.stdTripModeFreq;
        List<StdCode> freqTripModeList2 = [];
        List<StdCode> freq4TripModeList2 = [];
        if (stdString2 != null && stdString2 != '') {
          final a = jsonDecode(stdString2);
          freqTripModeList2 =
              List<StdCode>.from(a.map((e) => StdCode.fromJson(e)));
          final aa = freqTripModeList2.reversed;
          //và lấy 4 phần tử đầu tiên
          freq4TripModeList2 = aa.take(4).toList();
        } else {
          freqTripModeList2 = [];
        }
        emit(UpdateShuttleTripSuccess(
            dateTime: currentState.dateTime,
            shuttleTrip: shuttleTripNew,
            companyList: currentState.companyList,
            listStd: currentState.listStd,
            companyFreqFrom: currentState.companyFreqFrom,
            companyFreqTo: currentState.companyFreqTo,
            listStdFreq: freq4TripModeList2,
            isSuccess: true,
            isDelete: false));
      }
    } catch (e) {
      emit(UpdateShuttleTripFailure(message: e.toString()));
    }
  }

  void _mapDeleteToState(UpdateShuttleTripDelete event, emit) async {
    try {
      final currentState = state;
      if (currentState is UpdateShuttleTripSuccess) {
        emit(UpdateShuttleTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = DeleteShuttleTripRequest(
            stId: currentState.shuttleTrip.stId!,
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '');
        final apiResult = await _shuttleTripRepo.deleteShuttleTrip(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(UpdateShuttleTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResult.data;
        if (apiResponse.isSuccess != true) {
          emit(UpdateShuttleTripFailure(message: apiResponse.message ?? ''));
          return;
        }

        emit(currentState.copyWith(isDelete: true, isSuccess: false));
      }
    } catch (e) {
      emit(UpdateShuttleTripFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getShuttleTrips(
      {required DateTime dateTime,
      required String userId,
      required UserInfo userInfo}) async {
    final dateFirst = dateTime.firstDayOfMonth;
    final dateLast = dateTime.lastDayOfMonth;
    final dTF = DateFormat(constants.formatyyyyMMdd).format(dateFirst);
    final dTT = DateFormat(constants.formatyyyyMMdd).format(dateLast);

    final content = ShuttleTripRequest(
        isPosted: null,
        dTF: dTF,
        dTT: dTT,
        contactCode: userInfo.defaultClient ?? '',
        dCCode: userInfo.defaultCenter ?? '',
        from: null,
        to: null,
        driverID: userId);
    return await _shuttleTripRepo.getListShuttleTrip(
        content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
  }

  Future<ApiResult> _getListFreq(
      {required String companyType,
      required String userId,
      required UserInfo userInfo}) async {
    final content = CompanyFreqRequest(
        driverId: userId,
        dcCode: userInfo.defaultCenter ?? '',
        contactCode: userInfo.defaultClient ?? '',
        companyType: companyType);
    return await _shuttleTripRepo.getCompanysFreq(
        content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
  }
}
