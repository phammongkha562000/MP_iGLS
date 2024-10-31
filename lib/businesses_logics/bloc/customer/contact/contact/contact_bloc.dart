import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<ContactViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(ContactViewLoaded event, emit) async {
    try {
      double appSize = await getAppSize();
      emit(ContactSuccess(appSize: appSize));
    } catch (e) {
      emit(ContactFailure(message: e.toString()));
    }
  }

  Future<double> getAppSize() async {
    Directory appDirectory = Platform.isIOS ? await getTemporaryDirectory() : await getApplicationDocumentsDirectory();
    int size = await _getTotalAppSize(appDirectory);
    log('Dung lượng của ứng dụng: ${size / (1024 * 1024)} MB');
    return size / (1024 * 1024);
  }


  Future<int> _getTotalAppSize(Directory dir) async {
    int totalSize = 0;
    if (await dir.exists()) {
      await for (FileSystemEntity entity
          in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    return totalSize;
  }
}
