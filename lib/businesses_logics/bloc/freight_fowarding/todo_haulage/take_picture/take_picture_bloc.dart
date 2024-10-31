// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'take_picture_event.dart';
part 'take_picture_state.dart';

class TakePictureBloc extends Bloc<TakePictureEvent, TakePictureState> {
  final _todoLaugaleRepo = getIt<ToDoHaulageRepository>();
  TakePictureBloc() : super(TakePictureInitial()) {
    on<TakePictureViewLoaded>(_mapViewLoadedToState);
    on<TakePictureTakeCamera>(_mapTakePictureToState);
    on<TakePicturePickGallery>(_mapPickGalleryToState);
  }
  Future<void> _mapViewLoadedToState(TakePictureViewLoaded event, emit) async {
    emit(TakePictureLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResult = await _todoLaugaleRepo.getUploadImage(
        refNoValue: event.refNoValue,
        refNoType: event.refNoType,
        docRefType: event.docRefType,
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (apiResult.isFailure) {
        emit(TakePictureFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      List<DocumentDTO> listImage = apiResult.data;

      emit(TakePictureSuccess(imageListGet: listImage));
    } catch (e) {
      emit(TakePictureFailure(message: e.toString()));
    }
  }

  Future<void> _mapTakePictureToState(TakePictureTakeCamera event, emit) async {
    try {
      var status = await Permission.camera.status;
      if (status.isGranted) {
        XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 100,
            maxHeight: 100000,
            maxWidth: 100000);

        final currentState = state;
        if (currentState is TakePictureSuccess) {
          if (pickedFile != null) {
            List<XFile>? xFiles = [];
            xFiles.add(pickedFile);
            // GallerySaver.saveImage(pickedFile.path);

            emit(currentState.copyWith(imageFiles: xFiles));
          }
          //check
          else {
            emit(currentState);
          }
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      emit(TakePictureFailure(message: e.toString()));
    }
  }

  Future<void> _mapPickGalleryToState(
      TakePicturePickGallery event, emit) async {
    try {
      var status = Platform.isIOS
          ? await Permission.photos.status
          : await Permission.storage.status;
      log(status.name);
      if (status.isGranted) {
        List<XFile?>? pickedFiles = await ImagePicker().pickMultiImage();
        final currentState = state;
        if (currentState is TakePictureSuccess) {
          emit(TakePictureLoading());
          if (pickedFiles.isNotEmpty) {
            emit(currentState.copyWith(imageFiles: pickedFiles));
            return;
          }
          //check
          emit(currentState);
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      emit(TakePictureFailure(message: e.toString()));
    }
  }

  Future<void> rotateImage(String path) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    await File(path).writeAsBytes(img.encodeJpg(orientedImage));
  }
}
