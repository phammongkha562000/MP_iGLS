import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/models/inbox/inbox.dart';
import 'package:igls_new/data/models/inbox/notification_delete_request.dart';

import '../../../../data/repository/notification/notification_repository.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/shared.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  int numberOfPage = 1;
  bool endPage = false;
  int quantity = 0;

  static const int numberOfRow = 20;
  final _notificationRepo = getIt<NotificationRepository>();
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationViewLoaded>(_mapViewLoadedToState);
    on<NotificationChecked>(_mapCheckedToState);
    on<NotificationUnCheckedMultiple>(_mapUnCheckedToState);
    //read
    on<NotificationUpdateStatus>(_mapUpdateStatusToState);
    on<NotificationUpdateMultiple>(_mapUpdateMultipleToState);
    on<NotificationUpdateAll>(_mapUpdateAllToState);
    //delete
    on<NotificationDeleteNotification>(_mapDeleteToState);
    on<NotificationDeleteMultiple>(_mapDeleteMultipleToState);
    on<NotificationDeleteAll>(_mapDeleteAllToState);

    //paging
    on<NotificationPaging>(_mapPagingToState);
  }

  Future<void> _mapViewLoadedToState(NotificationViewLoaded event, emit) async {
    try {
      endPage = false;
      numberOfPage = 1;
      final sharedPref = await SharedPreferencesService.instance;

      final apiResult = await _notificationRepo.getNotification(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          sourceType: constants.systemId,
          messageType: constants.inboxNotification,
          numberOfPage: numberOfPage.toString(),
          numberOfRow: numberOfRow.toString(),
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub ?? '');
      if (apiResult.isFailure) {
        emit(NotificationFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      NotificationResponse notificationRes = apiResult.data;
      quantity = notificationRes.totalRecord ?? 0;
      emit(NotificationSuccess(
          notificationList: notificationRes.result ?? [], quantity: quantity));
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  void _mapCheckedToState(NotificationChecked event, emit) {
    try {
      final currentState = state;
      if (currentState is NotificationSuccess) {
        final newList = currentState.notificationList
            .map((e) => e.reqId == event.reqId
                ? e.copyWith(isSelected: event.isChecked)
                : e)
            .toList();
        emit(currentState.copyWith(notificationList: newList));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateStatusToState(
      NotificationUpdateStatus event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final content = NotificationUpdateRequest(
          username: event.generalBloc.generalUserInfo?.userId ?? '',
          finalStatusMessage: event.status,
          reqIds: event.reqIds);
      final apiResult = await _notificationRepo.updateNotification(
          content: content,
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub ?? '');
      if (apiResult.isFailure) {
        emit(NotificationFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      final countNotification = await _notificationRepo.getTotalNotifications(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          sourceType: constants.systemId,
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub.toString());
      if (countNotification.isFailure) {
        emit(NotificationFailure(
            message: countNotification.getErrorMessage(),
            errorCode: countNotification.errorCode));
        return;
      }
      globalApp.setCountNotification = int.parse(countNotification.data);
      emit(NotificationUpdateSuccessfully());
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteToState(
      NotificationDeleteNotification event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiDelete = await _notificationRepo.deleteNotification(
          content: NotificationDeleteRequest(
              strReqIds: event.reqId.toString(),
              strSoueceType: constants.systemId,
              notifyType: 'NOTIFICATION',
              isDelAll: false),
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub.toString());
      if (apiDelete.isFailure) {
        emit(NotificationFailure(
            message: apiDelete.getErrorMessage(),
            errorCode: apiDelete.errorCode));
        return;
      }
      final countNotification = await _notificationRepo.getTotalNotifications(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          sourceType: constants.systemId,
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub.toString());
      if (countNotification.isFailure) {
        emit(NotificationFailure(
            message: countNotification.getErrorMessage(),
            errorCode: countNotification.errorCode));
        return;
      }
      globalApp.setCountNotification = int.parse(countNotification.data);
      emit(NotificationUpdateSuccessfully());
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateMultipleToState(
      NotificationUpdateMultiple event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is NotificationSuccess) {
        final listSelected = currentState.notificationList
            .where((element) => element.isSelected == true)
            .toList();
        final listReq = listSelected.map((e) => e.reqId).join(',');
        final content = NotificationUpdateRequest(
            username: event.generalBloc.generalUserInfo?.userId ?? '',
            finalStatusMessage: constants.inboxRead,
            reqIds: listReq.toString());
        final apiRead = await _notificationRepo.updateNotification(
            content: content,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiRead.isFailure) {
          emit(NotificationFailure(
              message: apiRead.getErrorMessage(),
              errorCode: apiRead.errorCode));
          return;
        }
        final countNotification = await _notificationRepo.getTotalNotifications(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            sourceType: constants.systemId,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(NotificationFailure(
              message: countNotification.getErrorMessage(),
              errorCode: countNotification.errorCode));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);

        emit(NotificationUpdateSuccessfully());
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateAllToState(NotificationUpdateAll event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is NotificationSuccess) {
        final listReq =
            currentState.notificationList.map((e) => e.reqId).join(',');
        final content = NotificationUpdateRequest(
            username: event.generalBloc.generalUserInfo?.userId ?? '',
            finalStatusMessage: constants.inboxRead,
            reqIds: listReq.toString());
        final apiResultUpdateAll = await _notificationRepo.updateNotification(
            content: content,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiResultUpdateAll.isFailure) {
          emit(NotificationFailure(
              message: apiResultUpdateAll.getErrorMessage(),
              errorCode: apiResultUpdateAll.errorCode));
          return;
        }
        final countNotification = await _notificationRepo.getTotalNotifications(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            sourceType: constants.systemId,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(NotificationFailure(
              message: countNotification.getErrorMessage(),
              errorCode: countNotification.errorCode));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);

        emit(NotificationUpdateSuccessfully());
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteMultipleToState(
      NotificationDeleteMultiple event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is NotificationSuccess) {
        final listSelected = currentState.notificationList
            .where((element) => element.isSelected == true)
            .toList();
        final listReq = listSelected.map((e) => e.reqId).join(',');

        final apiDelete = await _notificationRepo.deleteNotification(
            content: NotificationDeleteRequest(
                strReqIds: listReq,
                strSoueceType: constants.systemId,
                notifyType: constants.inboxNotification,
                isDelAll: false),
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiDelete.isFailure) {
          emit(NotificationFailure(
              message: apiDelete.getErrorMessage(),
              errorCode: apiDelete.errorCode));
          return;
        }
        final countNotification = await _notificationRepo.getTotalNotifications(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            sourceType: constants.systemId,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(NotificationFailure(
              message: countNotification.getErrorMessage(),
              errorCode: countNotification.errorCode));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);
        emit(NotificationUpdateSuccessfully());
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteAllToState(NotificationDeleteAll event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is NotificationSuccess) {
        final apiDelete = await _notificationRepo.deleteNotification(
            content: NotificationDeleteRequest(
                strReqIds: event.generalBloc.generalUserInfo?.userId ?? '',
                strSoueceType: constants.systemId,
                notifyType: constants.inboxNotification,
                isDelAll: true),
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiDelete.isFailure) {
          emit(NotificationFailure(
              message: apiDelete.getErrorMessage(),
              errorCode: apiDelete.errorCode));
          return;
        }

        final countNotification = await _notificationRepo.getTotalNotifications(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            sourceType: constants.systemId,
            baseUrl: sharedPref.serverAddress ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(NotificationFailure(
              message: countNotification.getErrorMessage(),
              errorCode: countNotification.errorCode));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);
        emit(NotificationUpdateSuccessfully());
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  void _mapUnCheckedToState(NotificationUnCheckedMultiple event, emit) {
    try {
      final currentState = state;
      if (currentState is NotificationSuccess) {
        final newList = currentState.notificationList
            .map((e) => e.copyWith(isSelected: false))
            .toList();
        emit(currentState.copyWith(notificationList: newList));
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(NotificationPaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is NotificationSuccess) {
        if (currentState.notificationList.length == quantity) {
          endPage = true;
          return;
        }
        if (endPage == false) {
          numberOfPage++;
          emit(NotificationPagingLoading());
          final sharedPref = await SharedPreferencesService.instance;

          final apiResult = await _notificationRepo.getNotification(
              userId: event.userId,
              sourceType: constants.systemId,
              messageType: constants.inboxNotification,
              numberOfPage: numberOfPage.toString(),
              numberOfRow: numberOfRow.toString(),
              baseUrl: sharedPref.serverAddress ?? '',
              serverHub: sharedPref.serverHub ?? '');
          if (apiResult.isFailure) {
            emit(NotificationFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }

          NotificationResponse notificationRes = apiResult.data;
          if (notificationRes.result != [] &&
              notificationRes.result != null &&
              notificationRes.result!.isNotEmpty) {
            emit(currentState.copyWith(notificationList: [
              ...currentState.notificationList,
              ...notificationRes.result ?? [],
            ]));
          } else {
            endPage = true;
            emit(currentState);
          }
        }
      }
    } catch (e) {
      emit(NotificationFailure(message: e.toString()));
    }
  }
}
