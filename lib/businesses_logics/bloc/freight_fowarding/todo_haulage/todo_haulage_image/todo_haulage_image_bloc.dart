import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/image_todohaulage_response.dart';
import 'package:igls_new/data/models/login/user.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

part 'todo_haulage_image_event.dart';
part 'todo_haulage_image_state.dart';

class TodoHaulageImageBloc
    extends Bloc<TodoHaulageImageEvent, TodoHaulageImageState> {
  final _todoHaulageRepo = getIt<ToDoHaulageRepository>();

  TodoHaulageImageBloc() : super(TodoHaulageImageInitial()) {
    on<TodoHaulageImageViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      TodoHaulageImageViewLoaded event, emit) async {
    emit(TodoHaulageImageLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      getIt<AbstractDioHttpClient>().addOptions(
          BaseOptions(baseUrl: sharedPref.serverAddress.toString()));
      final apiImage = await _todoHaulageRepo.getImageTodoHaulage(
          docRefType: 'OT',
          refNoType: 'EQ',
          refNoValue: event.trailerNo,
          /* '51C78000' */
          subsidiaryId: event.userInfo.subsidiaryId ?? '');
      for (var element in apiImage) {
        final a = await checkIsImage(
            urlImage: element.filePath!.replaceAll("D:\\LE\\DS_FILES\\S1",
                '${event.userInfo.webPortalURL}uploads'));
        a == false ? log('not image') : log('is image');
      }

      emit(TodoHaulageImageSuccess(imageList: apiImage));
      getIt<AbstractDioHttpClient>().addOptions(
          BaseOptions(baseUrl: sharedPref.serverAddress.toString()));
    } catch (e) {
      emit(TodoHaulageImageFailure());
    }
  }
}

Future<bool> checkIsImage({required String urlImage}) async {
  try {
    final response = await Dio().head(urlImage);
    log(urlImage);
    final headers = response.headers.map;
    final contentType = headers['content-type']?.first;
    if (contentType?.startsWith('image/') == true) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
