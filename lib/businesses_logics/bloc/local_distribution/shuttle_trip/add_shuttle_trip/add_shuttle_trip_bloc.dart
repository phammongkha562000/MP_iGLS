import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/std_code/std_code_type.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../data/repository/repository.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/services/services.dart';
import '../../../general/general_bloc.dart';

part 'add_shuttle_trip_event.dart';
part 'add_shuttle_trip_state.dart';

class AddShuttleTripBloc
    extends Bloc<AddShuttleTripEvent, AddShuttleTripState> {
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  final _shuttleTripRepo = getIt<ShuttleTripRepository>();
  AddShuttleTripBloc() : super(AddShuttleTripInitial()) {
    on<AddShuttleTripViewLoaded>(_mapViewLoadedToState);
    on<AddShuttleTripStart>(_mapStartToState);
    on<AddShuttleTripDone>(_mapDoneToState);
  }
  Future<void> _mapViewLoadedToState(
      AddShuttleTripViewLoaded event, emit) async {
    emit(AddShuttleTripLoading());
    try {
      final ShuttleTripsResponse? itemShuttleTrip = event.shuttleTripPending;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      var status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        final sharedPref = await SharedPreferencesService.instance;

        final content = GetCompanysbyTypeRequest(
            contactCode: userInfo.defaultClient ?? '',
            companyCode: '',
            companyName: '',
            companyType: '');
        final apiCompany = await _shuttleTripRepo.getCompanysbyType(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');

        if (apiCompany.isFailure) {
          emit(AddShuttleTripFailure(
              message: apiCompany.getErrorMessage(),
              errorCode: apiCompany.errorCode));
          return;
        }
        List<CompanyResponse> listCompany = apiCompany.data;
        final results = await Future.wait([
          _getListFreq(
            defaultClient: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? "",
            defaultCenter: userInfo.defaultCenter ?? '',
            companyType: 'FROM',
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
          ),
          _getListFreq(
            defaultClient: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? "",
            defaultCenter: userInfo.defaultCenter ?? '',
            companyType: 'TO',
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
          )
        ]);

        ApiResult getListFreqCompanyFrom = results[0];
        if (getListFreqCompanyFrom.isFailure) {
          emit(AddShuttleTripFailure(
              message: getListFreqCompanyFrom.getErrorMessage(),
              errorCode: getListFreqCompanyFrom.errorCode));
          return;
        }

        List<CompanyFreqResponse> apiCompanyFreqFrom =
            getListFreqCompanyFrom.data;

        ApiResult getListFreqCompanyTo = results[1];
        if (getListFreqCompanyTo.isFailure) {
          emit(AddShuttleTripFailure(
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
            emit(AddShuttleTripFailure(message: apiStdCode.getErrorMessage()));
            return;
          }
          List<StdCode> listStd = apiStdCode.data;
          event.generalBloc.listStdShuttle = listStd;
          listStdShuttle = listStd;
        }
        List<StdCode> freqTripModeList = [];
        List<StdCode> freq4TripModeList = [];
        final stdString = sharedPref.stdTripModeFreq;

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

        if (itemShuttleTrip != null) {
          emit(AddShuttleTripSuccess(
              listStdFreq: freq4TripModeList,
              companyList: listCompany,
              listStd: listStdShuttle,
              shuttleTrip: itemShuttleTrip,
              companyFreqFrom: apiCompanyFreqFrom,
              companyFreqTo: apiCompanyFreqTo,
              equipmentCode: sharedPref.equipmentNo ?? ''));
        } else {
          emit(AddShuttleTripSuccess(
              companyList: listCompany,
              listStdFreq: freq4TripModeList,
              listStd: listStdShuttle,
              companyFreqFrom: apiCompanyFreqFrom,
              companyFreqTo: apiCompanyFreqTo,
              equipmentCode: sharedPref.equipmentNo ?? ''));
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      emit(AddShuttleTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapStartToState(AddShuttleTripStart event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddShuttleTripSuccess) {
        emit(AddShuttleTripLoading());

        var location = await LocationHelper.getLatitudeAndLongitude();
        double lat = location[0];
        double lon = location[1];
        final sharedPref = await SharedPreferencesService.instance;

        final startLoc = event.fromId;
        final endLoc = event.toId;
        final startTime =
            DateFormat(constants.formatMMddyyyyHHmm).format(DateTime.now());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = SaveShuttleTripRequest(
            dCCode: userInfo.defaultCenter ?? '',
            contactCode: userInfo.defaultClient ?? '',
            startLoc: startLoc,
            startTime: startTime,
            invoiceNo: event.invoiceNo,
            itemNote: event.sealNo,
            qty: double.parse(event.quantity),
            shipmentNo: event.shipmentNo,
            tripMode: event.tripModeId,
            endLoc: endLoc,
            createUser: event.generalBloc.generalUserInfo?.userId ?? '',
            equipmentCode: sharedPref.equipmentNo!,
            sLat: lat.toString(),
            sLon: lon.toString());
        final apiResultAdd = await _shuttleTripRepo.saveShuttleTrip(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultAdd.isFailure) {
          emit(AddShuttleTripFailure(
              message: apiResultAdd.getErrorMessage(),
              errorCode: apiResultAdd.errorCode));
          return;
        }
        StatusResponse apiAdd = apiResultAdd.data;

        if (apiAdd.isSuccess != true) {
          emit(const AddShuttleTripFailure(message: strings.messError));
          emit(currentState);
          return;
        }
        final stID = apiAdd.valueReturn;
        final apiResult = await _getShuttleTrips(
          defaultClient: userInfo.defaultClient ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? "",
          defaultCenter: userInfo.defaultCenter ?? '',
          dateTime: DateTime.now(),
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(AddShuttleTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<ShuttleTripsResponse> apiResponse = apiResult.data;
        final ShuttleTripsResponse shuttleTripNew = apiResponse
            .where((element) => element.stId == int.parse(stID!))
            .single;

        List<StdCode> freqTripModeList = [];
        final stdString = sharedPref.stdTripModeFreq;

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
          freqTripModeList =
              List<StdCode>.from(a.map((e) => StdCode.fromJson(e)));
          final aa = freqTripModeList2.reversed;
          //và lấy 4 phần tử đầu tiên
          freq4TripModeList2 = aa.take(4).toList();
        } else {
          freqTripModeList2 = [];
        }
        emit(currentState.copyWith(
            isSuccess: true,
            shuttleTrip: shuttleTripNew,
            listStdFreq: freq4TripModeList2));
      }
    } catch (e) {
      emit(AddShuttleTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapDoneToState(AddShuttleTripDone event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddShuttleTripSuccess) {
        emit(AddShuttleTripLoading());

        if (DateTime.now().isAfter(DateTime.parse(
                FormatDateConstants.convertyyyyMMddHHmm(
                    currentState.shuttleTrip!.startTime!))
            .add(const Duration(minutes: constants.minuteComplete)))) {
          var location = await LocationHelper.getLatitudeAndLongitude();
          double lat = location[0];
          double lon = location[1];
          UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

          final sharedPref = await SharedPreferencesService.instance;

          final startLoc = event.fromId;
          final endLoc = event.toId;
          final doneTime =
              DateFormat(constants.formatMMddyyyyHHmm).format(DateTime.now());
          final content = SaveShuttleTripRequest(
              sTId: currentState.shuttleTrip!.stId,
              dCCode: userInfo.defaultCenter ?? '',
              contactCode: userInfo.defaultClient ?? '',
              startTime: FormatDateConstants.convertMMddyyyyHHmm(
                  currentState.shuttleTrip!.startTime!),
              endTime: doneTime,
              endLoc: endLoc,
              startLoc: startLoc,
              updateUser: event.generalBloc.generalUserInfo?.userId ?? '',
              invoiceNo: event.invoiceNo,
              itemNote: event.sealNo,
              shipmentNo: event.shipmentNo,
              tripMode: event.tripModeId,
              qty: double.parse(event.quantity),
              equipmentCode: sharedPref.equipmentNo!,
              sLat: currentState.shuttleTrip!.sLat,
              sLon: currentState.shuttleTrip!.sLon,
              eLat: lat.toString(),
              eLon: lon.toString());
          final apiResultUpdate = await _shuttleTripRepo.updateShuttleTrip(
              content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultUpdate.isFailure) {
            emit(AddShuttleTripFailure(
                message: apiResultUpdate.getErrorMessage(),
                errorCode: apiResultUpdate.errorCode));

            return;
          }
          StatusResponse apiUpdate = apiResultUpdate.data;
          if (apiUpdate.isSuccess != true) {
            emit(const AddShuttleTripFailure(message: strings.messError));
            emit(currentState);
            return;
          }
          final stID = currentState.shuttleTrip!.stId;
          final apiResult = await _getShuttleTrips(
            defaultClient: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? "",
            defaultCenter: userInfo.defaultCenter ?? '',
            dateTime: DateTime.now(),
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
          );
          if (apiResult.isFailure) {
            emit(AddShuttleTripFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }
          List<ShuttleTripsResponse> apiResponseList = apiResult.data;
          final ShuttleTripsResponse shuttleTripNew =
              apiResponseList.where((element) => element.stId == stID!).single;

          //lưu tripmode nếu có update khi done

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

          emit(currentState.copyWith(
              isSuccess: true,
              shuttleTrip: shuttleTripNew,
              listStdFreq: freq4TripModeList2));
        } else {
          emit(currentState.copyWith(
              isSuccess: false,
              expectedTime: DateTime.parse(
                      FormatDateConstants.convertyyyyMMddHHmm(
                          currentState.shuttleTrip!.startTime!))
                  .add(const Duration(minutes: constants.minuteComplete))));
        }
      }
    } catch (e) {
      emit(AddShuttleTripFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getShuttleTrips(
      {required DateTime dateTime,
      required String userId,
      required String defaultCenter,
      required String subsidiaryId,
      required String defaultClient}) async {
    final dateFirst = dateTime.firstDayOfMonth;
    final dateLast = dateTime.lastDayOfMonth;
    final dTF = DateFormat(constants.formatyyyyMMdd).format(dateFirst);
    final dTT = DateFormat(constants.formatyyyyMMdd).format(dateLast);

    final content = ShuttleTripRequest(
        isPosted: null,
        dTF: dTF,
        dTT: dTT,
        contactCode: defaultClient,
        dCCode: defaultCenter,
        from: null,
        to: null,
        driverID: userId);
    return await _shuttleTripRepo.getListShuttleTrip(
        content: content, subsidiaryId: subsidiaryId);
  }

  Future<ApiResult> _getListFreq({
    required String companyType,
    required String userId,
    required String defaultCenter,
    required String subsidiaryId,
    required String defaultClient,
  }) async {
    final content = CompanyFreqRequest(
        driverId: userId,
        dcCode: defaultCenter,
        contactCode: defaultClient,
        companyType: companyType);
    return await _shuttleTripRepo.getCompanysFreq(
        content: content, subsidiaryId: subsidiaryId);
  }
}
