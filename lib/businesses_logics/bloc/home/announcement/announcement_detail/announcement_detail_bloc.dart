import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/login/login.dart';
import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import '../../../general/general_bloc.dart';

part 'announcement_detail_event.dart';
part 'announcement_detail_state.dart';

class AnnouncementDetailBloc
    extends Bloc<AnnouncementDetailEvent, AnnouncementDetailState> {
  final _loginRepo = getIt<LoginRepository>();
  AnnouncementDetailBloc() : super(AnnouncementDetailInitial()) {
    on<AnnouncementDetailViewLoaded>(_mapViewLoadedToState);
    on<AnnouncementDetailUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(
      AnnouncementDetailViewLoaded event, emit) async {
    emit(AnnouncementDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiDetail = await _loginRepo.getDetailAnnouncement(
          annId: event.annId, subsidiaryId: userInfo.subsidiaryId ?? '');
      emit(AnnouncementDetailSuccess(detail: apiDetail));
    } catch (e) {
      emit(AnnouncementDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(AnnouncementDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is AnnouncementDetailSuccess) {
        emit(AnnouncementDetailLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = AnnouncementUpdateRequest(
            annId: event.annId,
            agreedUser: event.generalBloc.generalUserInfo?.userId ?? '',
            comment: event.cmt);
        final apiResponse = await _loginRepo.saveUpdateAnnouncement(
            content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResponse.isSuccess != true) {
          emit(AnnouncementDetailFailure(message: apiResponse.message ?? ''));
          return;
        }
        final apiDetail = await _loginRepo.getDetailAnnouncement(
            annId: event.annId, subsidiaryId: userInfo.subsidiaryId ?? '');
        emit(currentState.copyWith(detail: apiDetail, isSuccess: true));
      }
    } catch (e) {
      emit(AnnouncementDetailFailure(message: e.toString()));
    }
  }
}
