import 'package:equatable/equatable.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/services/services.dart';

part 'driver_salary_event.dart';
part 'driver_salary_state.dart';

class DriverSalaryBloc extends Bloc<DriverSalaryEvent, DriverSalaryState> {
  DriverSalaryBloc() : super(DriverSalaryInitial()) {
    on<DriverSalaryLoaded>(_mapViewToState);
    on<DriverSalaryCheckPass>(_mapCheckPassToState);
  }

  Future<void> _mapViewToState(DriverSalaryLoaded event, emit) async {
    try {
      emit(DriverSalaryLoading());

      // final sharedPref = await SharedPreferencesService.instance;
      // if (event.pageId != null && event.pageName != null) {
      //   String accessDatetime = DateTime.now().toString().split('.').first;
      //   final contentQuickMenu = FrequentlyVisitPageRequest(
      //       userId:  event.generalBloc.generalUserInfo?.userId??'',
      //       subSidiaryId:  userInfo.subsidiaryId?? '',
      //       pageId: event.pageId!,
      //       pageName: event.pageName!,
      //       accessDatetime: accessDatetime,
      //       systemId: constants.systemId);
      //   final addFreqVisitResult =
      //       await _loginRepo.saveFreqVisitPage(content: contentQuickMenu);
      //   if (addFreqVisitResult.isFailure) {
      //     emit(DriverSalaryFailure(
      //         message: addFreqVisitResult.getErrorMessage(),
      //         errorCode: addFreqVisitResult.errorCode));
      //     return;
      //   }
      // }

      emit(DriverSalarySuccess());
    } catch (e) {
      emit(DriverSalaryFailure(message: e.toString()));
    }
  }

  Future<void> _mapCheckPassToState(DriverSalaryCheckPass event, emit) async {
    try {
      emit(DriverSalaryLoading());
      // Check pass cũ với pass nhập
      final shared = await SharedPreferencesService.instance;
      var oldPassword = shared.password;
      if (event.password != oldPassword) {
        emit(const DriverSalaryFailure(
          message: "5096",
          errorCode: constants.errorOldPass,
        ));
      } else if (event.password == "123456") {
        emit(const DriverSalaryFailure(
          message: "5000",
          errorCode: constants.errorDefaultPass,
        ));
      } else if (!isPasswordValid(event.password)) {
        emit(const DriverSalaryFailure(
          message: "5097",
          errorCode: constants.errorCheckPass,
        ));
      } else {
        emit(DriverSalaryCheckPassSuccess());
      }
      emit(DriverSalarySuccess());
    } catch (e) {
      emit(DriverSalaryFailure(message: e.toString()));
    }
  }

  //* Check pass
  bool isPasswordValid(String password) {
    // *Tối thiểu 6 ký tự, không có khoảng trắng
    RegExp lengthRegExp = RegExp(r'^[^\s]{6,}$');
    if (!lengthRegExp.hasMatch(password)) {
      return false;
    }

    // *Có ký tự in hoa
    RegExp uppercaseRegExp = RegExp(r'[A-Z]');
    if (!uppercaseRegExp.hasMatch(password)) {
      return false;
    }

    //* Có ký tự in thường
    RegExp lowercaseRegExp = RegExp(r'[a-z]');
    if (!lowercaseRegExp.hasMatch(password)) {
      return false;
    }

    //* Có số
    RegExp digitRegExp = RegExp(r'\d');
    if (!digitRegExp.hasMatch(password)) {
      return false;
    }

    // *Có ký tự đặc biệt
    RegExp specialRegExp = RegExp(r'[!@#\$&*~]');
    if (!specialRegExp.hasMatch(password)) {
      return false;
    }

    // *Tất cả các yêu cầu đều được đáp ứng
    return true;
  }
}
