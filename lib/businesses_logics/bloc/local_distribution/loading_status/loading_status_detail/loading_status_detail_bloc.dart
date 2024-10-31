import 'package:equatable/equatable.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/repository/repository.dart';
import '../../../../../data/services/services.dart';
import '../../../../../data/shared/shared.dart';
import '../../../general/general_bloc.dart';

part 'loading_status_detail_event.dart';
part 'loading_status_detail_state.dart';

class LoadingStatusDetailBloc
    extends Bloc<LoadingStatusDetailEvent, LoadingStatusDetailState> {
  final _loadingStatusRepo = getIt<LoadingStatusRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();
  LoadingStatusDetailBloc() : super(LoadingStatusDetailInitial()) {
    on<LoadingStatusDetailViewLoaded>(_mapViewLoadedToState);
    on<LoadingStatusSave>(_mapSaveToState);
    on<LoadingNormalTripUpdateStatus>(_mapNormalUpdateStatusToState);
    on<LoadingTripDetailUpdateStatus>(_mapSimpleUpdateStatusToState);
  }
  Future<void> _mapViewLoadedToState(
      LoadingStatusDetailViewLoaded event, emit) async {
    emit(LoadingStatusDetailLoading());
    try {
      emit(LoadingStatusDetailSuccess(detail: event.detail, etp: event.etp));
    } catch (e) {
      emit(const LoadingStatusDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapSaveToState(LoadingStatusSave event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoadingStatusDetailSuccess) {
        emit(LoadingStatusDetailLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = LoadingStatusSaveRequest(
            dcCode: userInfo.defaultCenter ?? '',
            tripNo: event.tripNo,
            loadingMemo: event.loadingMemo,
            loadingStart: event.loadingStart,
            loadingEnd: event.loadingEnd ?? '',
            userID: event.generalBloc.generalUserInfo?.empCode ?? '');
        final apiResultSave = await _loadingStatusRepo.saveLoadingStatus(
          content: content,
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResultSave.isFailure) {
          emit(LoadingStatusDetailFailure(
              message: apiResultSave.getErrorMessage(),
              errorCode: apiResultSave.errorCode));
          return;
        }
        StatusResponse apiSave = apiResultSave.data;
        if (apiSave.isSuccess == false) {
          emit(LoadingStatusDetailFailure(
              message: apiSave.message ?? strings.messError));
          emit(currentState);
          return;
        }

        final apiResultDetail = await _getDetail(
            subsidiaryId: userInfo.subsidiaryId ?? "",
            dateTime: currentState.etp,
            tripNo: event.tripNo,
            defaultCenter: userInfo.defaultCenter ?? '');
        if (apiResultDetail.isFailure) {
          emit(LoadingStatusDetailFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        List<LoadingStatusResponse> loadingList = apiResultDetail.data;
        final detail = loadingList
            .where((element) => element.tripNo == event.tripNo)
            .first;
        emit(LoadingStatusSaveSuccess());
        emit(currentState.copyWith(detail: detail));
      }
    } catch (e) {
      emit(const LoadingStatusDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapNormalUpdateStatusToState(
      LoadingNormalTripUpdateStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoadingStatusDetailSuccess) {
        emit(LoadingStatusDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          var location = await LocationHelper.getLatitudeAndLongitude();
          double lat = location[0];
          double lon = location[1];

          final sharedPref = await SharedPreferencesService.instance;

          final userId = event.generalBloc.generalUserInfo?.userId ?? '';
          final ordeId = event.orgItemNo;
          final eventType = event.eventType;
          final tripNo = event.tripNo;
          final eventDate = DateFormat(constants.formatMMddyyyyHHmmss, 'en')
              .format(DateTime.now());
          final remark =
              '$userId - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';
          final content = UpdateNormalTripStatusRequest(
              tripNo: tripNo,
              eventDate: eventDate,
              eventType: eventType,
              placeDesc: '',
              remark: remark,
              longitude: lon.toString(),
              latitude: lat.toString(),
              userId: userId,
              ordeId: ordeId);
          final apiResultUpdate =
              await _toDoTripRepo.updateNormalTripStatusDetail(
                  content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
          if (apiResultUpdate.isFailure) {
            emit(LoadingStatusDetailFailure(
                message: apiResultUpdate.getErrorMessage(),
                errorCode: apiResultUpdate.errorCode));
            return;
          }
          StatusResponse apiResponse = apiResultUpdate.data;
          if (apiResponse.isSuccess != true) {
            emit(LoadingStatusDetailFailure(
                message: apiResponse.message ?? strings.messError));
            emit(currentState);

            return;
          }
          final apiResultDetail = await _getDetail(
              subsidiaryId: userInfo.subsidiaryId ?? "",
              defaultCenter: userInfo.defaultCenter ?? '',
              tripNo: currentState.detail.tripNo ?? '',
              dateTime: currentState.etp);
          if (apiResultDetail.isFailure) {
            emit(LoadingStatusDetailFailure(
                message: apiResultDetail.getErrorMessage(),
                errorCode: apiResultDetail.errorCode));
            return;
          }
          List<LoadingStatusResponse> loadingList = apiResultDetail.data;
          final detail =
              loadingList.where((element) => element.tripNo == tripNo).first;
          emit(LoadingStatusSaveSuccess());
          emit(currentState.copyWith(detail: detail));
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(const LoadingStatusDetailFailure(message: strings.messError));
    }
  }

  Future<void> _mapSimpleUpdateStatusToState(
      LoadingTripDetailUpdateStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoadingStatusDetailSuccess) {
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        emit(LoadingStatusDetailLoading());
        var status = await Permission.locationWhenInUse.status;
        if (status.isGranted) {
          String eventDate = FormatDateConstants.getCurrentDate();

          var location = await LocationHelper.getLatitudeAndLongitude();
          double lat = location[0];
          double lon = location[1];

          final sharedPref = await SharedPreferencesService.instance;
          final remark =
              '${event.generalBloc.generalUserInfo?.userId ?? ''} - ${sharedPref.equipmentNo ?? ''} - ${userInfo.mobileNo ?? ''}';

          final content = UpdateTripStatusRequest(
              tripNo: event.tripNo,
              eventDate: eventDate,
              eventType: event.eventType,
              lon: lon,
              lat: lat, //hard location
              userId: event.generalBloc.generalUserInfo?.userId ?? '',
              deliveryResult: event.deliveryResult ?? '',
              failReason: '',
              remark: remark,
              orgItemNo: event.orgItemNo ?? -1,
              orderId: event.orderId ?? -1);
          final apiResultUpdate = await _getUpdateTrip(
            defaultClient: userInfo.defaultClient ?? '',
            content: content,
            subsidiaryId: userInfo.subsidiaryId ?? "",
          );
          if (apiResultUpdate.isFailure) {
            emit(LoadingStatusDetailFailure(
                message: apiResultUpdate.getErrorMessage(),
                errorCode: apiResultUpdate.errorCode));
            return;
          }
          StatusResponse apiResponse = apiResultUpdate.data;
          if (apiResponse.isSuccess != true) {
            emit(LoadingStatusDetailFailure(
                message: apiResponse.message ?? strings.messError));
            emit(currentState);

            return;
          }
          final apiResultDetail = await _getDetail(
              subsidiaryId: userInfo.subsidiaryId ?? "",
              defaultCenter: userInfo.defaultCenter ?? '',
              tripNo: event.tripNo,
              dateTime: currentState.etp);
          if (apiResultDetail.isFailure) {
            emit(LoadingStatusDetailFailure(
                message: apiResultDetail.getErrorMessage(),
                errorCode: apiResultDetail.errorCode));
            return;
          }
          List<LoadingStatusResponse> loadingList = apiResultDetail.data;
          final detail = loadingList
              .where((element) => element.tripNo == event.tripNo)
              .first;
          emit(LoadingStatusSaveSuccess());

          emit(currentState.copyWith(detail: detail));
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      emit(const LoadingStatusDetailFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getUpdateTrip(
      {required UpdateTripStatusRequest content,
      required String subsidiaryId,
      required String defaultClient}) async {
    return await _toDoTripRepo.getUpdateTripStatusDetail(
        content: content,
        contactCode: defaultClient,
        subsidiaryId: subsidiaryId);
  }

  Future<ApiResult> _getDetail(
      {required String tripNo,
      required DateTime dateTime,
      required String defaultCenter,
      required String subsidiaryId}) async {
    final String etpf = DateFormat(constants.formatyyyyMMdd).format(dateTime);
    final String etpt = DateFormat(constants.formatyyyyMMdd).format(dateTime);
    final content = LoadingStatusRequest(
        tripNo: tripNo,
        equipmentCode: '',
        etpf: etpf,
        etpt: etpt,
        dcCode: defaultCenter);
    return await _loadingStatusRepo.getLoadingStatus(
        content: content, subsidiaryId: subsidiaryId);

    // return apiResultDetail.where((element) => element.tripNo == tripNo).first;
  }
}
