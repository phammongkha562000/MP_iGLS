// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../../../data/shared/shared.dart';
import '../../general/general_bloc.dart';

part 'relocation_event.dart';
part 'relocation_state.dart';

class RelocationBloc extends Bloc<RelocationEvent, RelocationState> {
  final _relocationRepo = getIt<RelocationRepository>();
  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<RelocationResult> reloLst = [];

  RelocationBloc() : super(RelocationInitial()) {
    on<RelocationViewLoaded>(_mapViewLoadedToState);
    on<RelocationPreviousDateLoaded>(_mapPreviousToState);
    on<RelocationNextDateLoaded>(_mapNextToState);
    on<RelocationSave>(_mapSaveToState);
    on<RelocationPickDate>(_mapPickDateToState);
    on<RelocationPaging>(_mapPagingToState);
  }
  Future<ApiResult> _getRelocation(
      {required DateTime eventDate, required UserInfo userInfo}) async {
    final dateFrom = DateFormat('dd/MM/yyyy').format(eventDate);
    final content = RelocationRequest(
        contactCode: userInfo.defaultClient ?? '',
        dcCode: userInfo.defaultCenter ?? '',
        dateFrom: /* "01/01/2020" */ dateFrom,
        dateTo: /*  "01/01/2024" */ dateFrom, //hardcode

        itemCode: '',
        pageNumber: pageNumber,
        pageSize: constants.sizePaging);

    return await _relocationRepo.getRelocation(
        content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
  }

  Future<void> _mapViewLoadedToState(RelocationViewLoaded event, emit) async {
    emit(RelocationLoading());
    try {
      pageNumber = 1;
      endPage = false;
      reloLst.clear();
      quantity = 0;

      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      final apiResultRelocation = await _getRelocation(
        userInfo: userInfo,
        eventDate: event.date,
      );
      if (apiResultRelocation.isFailure) {
        emit(RelocationFailure(
            message: apiResultRelocation.getErrorMessage(),
            errorCode: apiResultRelocation.errorCode));
        return;
      }
      ApiResponse apiRes = apiResultRelocation.data;
      if (apiRes.success == false) {
        emit(RelocationFailure(
            message: apiRes.error?.message,
            errorCode: apiRes.error?.errorCode));
        return;
      }
      RelocationResponse relocaRes = apiRes.payload;
      List<RelocationResult> relocationList = relocaRes.results ?? [];
      reloLst.addAll(relocationList);
      quantity = relocaRes.totalCount ?? 0;
      emit(RelocationSuccess(
          date: event.date,
          relocationList: relocationList,
          quantity: quantity,
          isPagingLoading: false));
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }

  Future<void> _mapPreviousToState(
      RelocationPreviousDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is RelocationSuccess) {
        emit(RelocationLoading());
        pageNumber = 1;
        endPage = false;
        reloLst.clear();
        quantity = 0;

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final previous = currentState.date.findPreviousDate;
        final apiResultRelocation =
            await _getRelocation(eventDate: previous, userInfo: userInfo);
        if (apiResultRelocation.isFailure) {
          emit(RelocationFailure(
              message: apiResultRelocation.getErrorMessage(),
              errorCode: apiResultRelocation.errorCode));
          return;
        }
        ApiResponse apiRes = apiResultRelocation.data;
        if (apiRes.success == false) {
          emit(RelocationFailure(
              message: apiRes.error?.message,
              errorCode: apiRes.error?.errorCode));
          return;
        }
        RelocationResponse relocaRes = apiRes.payload;
        List<RelocationResult> relocationList = relocaRes.results ?? [];
        reloLst.addAll(relocationList);
        quantity = relocaRes.totalCount ?? 0;

        emit(currentState.copyWith(
          quantity: quantity,
          date: previous,
          relocationList: relocationList,
          saveSuccess: false,
        ));
      }
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }

  Future<void> _mapNextToState(RelocationNextDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is RelocationSuccess) {
        emit(RelocationLoading());
        pageNumber = 1;
        endPage = false;
        reloLst.clear();
        quantity = 0;

        final next = currentState.date.findNextDate;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResultRelocation = await _getRelocation(
          userInfo: userInfo,
          eventDate: next,
        );
        if (apiResultRelocation.isFailure) {
          emit(RelocationFailure(
              message: apiResultRelocation.getErrorMessage(),
              errorCode: apiResultRelocation.errorCode));
          return;
        }
        ApiResponse apiRes = apiResultRelocation.data;
        if (apiRes.success == false) {
          emit(RelocationFailure(
              message: apiRes.error?.message,
              errorCode: apiRes.error?.errorCode));
          return;
        }
        RelocationResponse relocaRes = apiRes.payload;
        List<RelocationResult> relocationList = relocaRes.results ?? [];
        reloLst.addAll(relocationList);
        quantity = relocaRes.totalCount ?? 0;

        emit(currentState.copyWith(
          quantity: quantity,
          date: next,
          relocationList: relocationList,
          saveSuccess: false,
        ));
      }
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }

  Future<void> _mapSaveToState(RelocationSave event, emit) async {
    try {
      final item = event.item;
      final currentState = state;

      if (currentState is RelocationSuccess) {
        emit(RelocationLoading());

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = UpdateRelocationRequest(
            id: item.id!,
            dCCode: userInfo.defaultCenter ?? '',
            contactCode: userInfo.defaultClient!,
            plandate: FileUtils.formatDDMMyyyfromString(item.plandate!),
            assignStaff: item.assignStaff ?? '',
            oldLocCode: item.oldLocCode ?? '',
            newLocCode: item.newLocCode ?? '',
            qty: item.qty!,
            isDone: !item.isDone!,
            completeMemo: event.remark,
            updateUser: event.generalBloc.generalUserInfo?.userId ?? '');
        final apiResponse = await _relocationRepo.getUpdateRelocation(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        log(apiResponse.isSuccess.toString());
        if (apiResponse.isSuccess != true) {
          emit(RelocationFailure(message: apiResponse.message));
          emit(currentState);

          return;
        }
        final apiResultRelocation = await _getRelocation(
            eventDate: currentState.date, userInfo: userInfo);
        if (apiResultRelocation.isFailure) {
          emit(RelocationFailure(
              message: apiResultRelocation.getErrorMessage(),
              errorCode: apiResultRelocation.errorCode));
          return;
        }
        ApiResponse apiRes = apiResultRelocation.data;
        if (apiRes.success == false) {
          emit(RelocationFailure(
              message: apiRes.error?.message,
              errorCode: apiRes.error?.errorCode));
          return;
        }
        RelocationResponse relocaRes = apiRes.payload;
        List<RelocationResult> relocationList = relocaRes.results ?? [];
        reloLst.addAll(relocationList);
        quantity = relocaRes.totalCount ?? 0;

        emit(currentState.copyWith(
            saveSuccess: true,
            relocationList: relocationList,
            quantity: quantity));
      }
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }

  Future<void> _mapPickDateToState(RelocationPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is RelocationSuccess) {
        pageNumber = 1;
        endPage = false;
        reloLst.clear();
        quantity = 0;

        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        emit(RelocationLoading());
        final date = event.date;
        final apiResultRelocation =
            await _getRelocation(eventDate: date, userInfo: userInfo);
        if (apiResultRelocation.isFailure) {
          emit(RelocationFailure(
              message: apiResultRelocation.getErrorMessage(),
              errorCode: apiResultRelocation.errorCode));
          return;
        }
        ApiResponse apiRes = apiResultRelocation.data;
        if (apiRes.success == false) {
          emit(RelocationFailure(
              message: apiRes.error?.message,
              errorCode: apiRes.error?.errorCode));
          return;
        }
        RelocationResponse relocaRes = apiRes.payload;
        List<RelocationResult> relocationList = relocaRes.results ?? [];
        reloLst.addAll(relocationList);
        quantity = relocaRes.totalCount ?? 0;

        emit(currentState.copyWith(
          date: date,
          relocationList: relocationList,
          saveSuccess: false,
          quantity: quantity,
        ));
      }
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }

  Future<void> _mapPagingToState(RelocationPaging event, emit) async {
    try {
      final currentState = state;
      if (currentState is RelocationSuccess) {
        if (endPage == false) {
          emit(currentState.copyWith(isPagingLoading: true));
          pageNumber++;

          UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
          final apiResultRelocation = await _getRelocation(
            userInfo: userInfo,
            eventDate: currentState.date,
          );
          if (apiResultRelocation.isFailure) {
            emit(RelocationFailure(
                message: apiResultRelocation.getErrorMessage(),
                errorCode: apiResultRelocation.errorCode));
            return;
          }
          ApiResponse apiRes = apiResultRelocation.data;
          if (apiRes.success == false) {
            emit(RelocationFailure(
                message: apiRes.error?.message,
                errorCode: apiRes.error?.errorCode));
            return;
          }
          RelocationResponse relocaRes = apiRes.payload;
          List<RelocationResult> relocationList = relocaRes.results ?? [];
          if (relocationList != [] && relocationList.isNotEmpty) {
            reloLst.addAll(relocationList);
          } else {
            endPage = true;
          }

          emit(currentState.copyWith(
              relocationList: reloLst, isPagingLoading: false));
        }
      }
    } catch (e) {
      emit(const RelocationFailure(message: strings.messError));
    }
  }
}
