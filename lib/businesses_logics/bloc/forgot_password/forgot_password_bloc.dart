import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';
import '../../../data/shared/preference/share_pref_service.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      ForgotPasswordViewLoaded event, emit) async {
    emit(ForgotPasswordLoading());
    try {
      Map<String, String> mapNavigateDriver = {
        ServerMode.prod:
            'https://pro.igls.vn/${endpoints.forgotPasswordMB}${event.username}',
        ServerMode.dev:
            'https://dev.igls.vn:8083/${endpoints.forgotPasswordMB}${event.username}',
        ServerMode.qa:
            'https://qa.igls.vn/${endpoints.forgotPasswordMB}${event.username}'
      };
      Map<String, String> mapNavigateWP = {
        ServerMode.prod:
            'https://pro.igls.vn/${endpoints.forgotPasswordWP}${event.username}',
        ServerMode.dev:
            'https://dev.igls.vn:8083/${endpoints.forgotPasswordWP}${event.username}',
        ServerMode.qa:
            'https://qa.igls.vn/${endpoints.forgotPasswordWP}${event.username}'
      };
      String? url = '';
      final sharedPref = await SharedPreferencesService.instance;
      url = event.tabMode == 1
          ? mapNavigateDriver[sharedPref.serverCode]
          : mapNavigateWP[sharedPref.serverCode];
      emit(ForgotPasswordSuccess(url: url ?? ''));
    } catch (e) {
      emit(ForgotPasswordFailure(message: e.toString()));
    }
  }
}
