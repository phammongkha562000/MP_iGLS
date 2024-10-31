// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/models/register/data_register.dart';
import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../data/services/injection/injection_igls.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _repoLogin = getIt<LoginRepository>();

  RegisterBloc() : super(const RegisterInitial(isError: false)) {
    on<RegisterPressed>(_mapLoginPressedToState);
  }
  void _mapLoginPressedToState(RegisterPressed event, emit) async {
    emit(RegisterLoading());
    try {
      //thay đổi server
      final dataRegister = DataRegister(
        firstname: event.firstname,
        lastname: event.lastname,
        employeeName: event.employeeName,
        username: event.username,
        password: event.password,
        phone: event.phone,
        email: event.email,
      );
      final response = await _repoLogin.register(
        dataRegister: dataRegister,
        baseUrl: "https://fmbp.enterprise.vn:9110/",
      );

      if (response.payload == null) {
        emit(const RegisterInitial(
            isError: true, error: strings.erRegisterFail));
        return;
      }
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
