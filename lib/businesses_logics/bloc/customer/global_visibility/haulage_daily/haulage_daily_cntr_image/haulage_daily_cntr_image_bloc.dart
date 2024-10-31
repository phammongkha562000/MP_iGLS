import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/image_todohaulage_response.dart';
import 'package:igls_new/data/repository/freight_fowarding/to_do_haulage/to_do_haulage_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

part 'haulage_daily_cntr_image_event.dart';
part 'haulage_daily_cntr_image_state.dart';

class HaulageDailyCNTRImageBloc
    extends Bloc<HaulageDailyCNTRImageEvent, HaulageDailyCNTRImageState> {
  final _todoHaulageRepo = getIt<ToDoHaulageRepository>();

  HaulageDailyCNTRImageBloc() : super(HaulageDailyCNTRImageInitial()) {
    on<HaulageDailyCNTRImageViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      HaulageDailyCNTRImageViewLoaded event, emit) async {
    emit(HaulageDailyCNTRImageLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: 'https://pro.igls.vn:8186/'));
      final apiImage = await _todoHaulageRepo.getImageTodoHaulage(
          docRefType: 'WO',
          refNoType: 'FETASKD',
          refNoValue: /* '51C78000' */ event.customerWoTaskID,
          subsidiaryId: 'S1');
      for (var element in apiImage) {
        final a = await checkIsImage(
            urlImage: element.filePath!.replaceAll(
                "D:\\LE\\DS_FILES\\S1", 'https://pro.igls.vn/uploads'));
        a == false ? log('not image') : log('is image');
      }

      emit(HaulageDailyCNTRImageSuccess(imageList: apiImage));
      getIt<AbstractDioHttpClient>().addOptions(
          BaseOptions(baseUrl: sharedPref.serverAddress.toString()));
    } catch (e) {
      emit(HaulageDailyCNTRImageFailure());
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
