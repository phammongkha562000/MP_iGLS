import 'package:equatable/equatable.dart';
import 'package:igls_new/data/repository/local_distribution/loading_status/loading_status_repository.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../../data/services/services.dart';

import '../../../general/general_bloc.dart';

part 'loading_status_event.dart';
part 'loading_status_state.dart';

class LoadingStatusBloc extends Bloc<LoadingStatusEvent, LoadingStatusState> {
  final _loadingStatusRepo = getIt<LoadingStatusRepository>();
  LoadingStatusBloc() : super(LoadingStatusInitial()) {
    on<LoadingStatusViewLoaded>(_mapViewLoadedToState);
    on<LoadingStatusChangeDate>(_mapChangeDateToState);
  }
  Future<void> _mapViewLoadedToState(
      LoadingStatusViewLoaded event, emit) async {
    emit(LoadingStatusLoading());
    try {
      final dateTime = event.etp ?? DateTime.now();
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult = await _getLoadingStatus(
          subsidiaryId: userInfo.subsidiaryId ?? "",
          dateTime: dateTime,
          defaultCenter: userInfo.defaultCenter ?? '');
      if (apiResult.isFailure) {
        emit(LoadingStatusFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<LoadingStatusResponse> apiResponse = apiResult.data;
      // if (event.pageId != null && event.pageName != null) {
      //   final sharedPref = await SharedPreferencesService.instance;
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
      //     emit(LoadingStatusFailure(
      //         message: addFreqVisitResult.getErrorMessage(),
      //         errorCode: addFreqVisitResult.errorCode));
      //     return;
      //   }
      // }
      emit(LoadingStatusSuccess(
          loadingStatusList: apiResponse, dateTime: dateTime));
    } catch (e) {
      emit(const LoadingStatusFailure(message: strings.messError));
    }
  }

  Future<void> _mapChangeDateToState(
      LoadingStatusChangeDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoadingStatusSuccess) {
        emit(LoadingStatusLoading());
        final dateTime = event.dateTime;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await _getLoadingStatus(
            subsidiaryId: userInfo.subsidiaryId ?? "",
            dateTime: dateTime,
            defaultCenter: userInfo.defaultCenter ?? '');
        if (apiResult.isFailure) {
          emit(LoadingStatusFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        List<LoadingStatusResponse> apiResponse = apiResult.data;
        emit(currentState.copyWith(
            dateTime: dateTime, loadingStatusList: apiResponse));
      }
    } catch (e) {
      emit(const LoadingStatusFailure(message: strings.messError));
    }
  }

  Future<ApiResult> _getLoadingStatus(
      {required DateTime dateTime,
      required String defaultCenter,
      required String subsidiaryId}) async {
    final String etpf = DateFormat(constants.formatyyyyMMdd).format(dateTime);
    final String etpt = DateFormat(constants.formatyyyyMMdd).format(dateTime);
    final content = LoadingStatusRequest(
        tripNo: '',
        equipmentCode: '',
        etpf: etpf,
        etpt: etpt,
        dcCode: defaultCenter);
    return await _loadingStatusRepo.getLoadingStatus(
        content: content, subsidiaryId: subsidiaryId);
  }
}
