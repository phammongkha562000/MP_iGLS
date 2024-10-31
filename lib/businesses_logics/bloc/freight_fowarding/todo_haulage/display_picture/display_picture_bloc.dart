import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'display_picture_event.dart';
part 'display_picture_state.dart';

class DisplayPictureBloc
    extends Bloc<DisplayPictureEvent, DisplayPictureState> {
  final _todoLaugaleRepo = getIt<ToDoHaulageRepository>();

  DisplayPictureBloc() : super(DisplayPictureInitial()) {
    on<DisplayPictureViewLoaded>(_mapViewLoadedToState);
    on<DisplayPictureSaved>(_mapSavedToState);
  }
  void _mapViewLoadedToState(DisplayPictureViewLoaded event, emit) {
    try {
      emit(DisplayPictureSuccess(
          files: event.files,
          docRefType: event.docRefType,
          refNoType: event.refNoType,
          refNoValue: event.refNoValue));
    } catch (e) {
      emit(DisplayPictureFailure(message: e.toString()));
    }
  }

  Future<void> _mapSavedToState(DisplayPictureSaved event, emit) async {
    try {
      for (var element in event.files) {
        final sharedPref = await SharedPreferencesService.instance;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        String base64Image = base64Encode(element.readAsBytesSync());
        final fileName =
            '${formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss])}.png';
        final content = UploadDocumentEntryRequest(
            fileName: fileName,
            docRefType: event.docRefType,
            refNoType: event.refNoType,
            refNoValue: event.refNoValue,
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            stringData: base64Image);
        //check
        final apiResult = await _todoLaugaleRepo.updateUploadDocumentEntry(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        getIt<AbstractDioHttpClient>()
            .addOptions(BaseOptions(baseUrl: sharedPref.serverAddress!));
        if (apiResult.isFailure) {
          emit(DisplayPictureFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        emit(DisplayPictureSaveSuccess());
      }
    } catch (e) {
      emit(DisplayPictureFailure(message: e.toString()));
    }
  }
}
