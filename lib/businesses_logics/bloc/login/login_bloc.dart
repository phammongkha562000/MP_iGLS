import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/config/serverconfig.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_req.dart';
import 'package:igls_new/data/models/customer/login/customer_login_req.dart';
import 'package:igls_new/data/repository/repository.dart';
import 'package:igls_new/data/services/local_auth/biometrics_helper.dart';
import 'package:igls_new/data/services/local_auth/local_auth_helper.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:r_get_ip/r_get_ip.dart';
import '../../../data/services/services.dart';
import '../customer/customer_bloc/customer_bloc.dart';
import '../general/general_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repoLogin = getIt<LoginRepository>();
  final _iosRepo = getIt<CustomerIOSRepository>();
  final _customerInventoryRepo = getIt<CustomerInventoryRepository>();
  final _tosRepo = getIt<CustomerTOSRepository>();

  LoginBloc() : super(LoginInitial()) {
    on<LoginPressed>(_mapLoginPressedToState);
    on<CustomerLoginPressed>(_mapCustomerLoginPressedToState);
    on<LoginViewLoaded>(_mapViewLoadedToState);
    on<LoginChangeServer>(_mapChangeServerToState);
    on<LoginRemember>(_mapRememberToState);
    on<LoginLanguage>(_mapLanguageToState);
    on<AuthLocalEvent>(_mapAuthLocalToState);
  }
  Future<void> _mapViewLoadedToState(LoginViewLoaded event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      // check device biometrics
      String biometrics = await LocalAuthHelper.checkBiometrics();
      if (biometrics == BiometricsHelper.notBiometrics) {
        sharedPref.setIsBiometrics(false);
        sharedPref.setIsAllowBiometrics(false);
      } else {
        sharedPref.setIsBiometrics(true);
      }

      final remember = sharedPref.remember ?? true;
      final mode = sharedPref.mode ?? constants.modeDriver;
      final userName = remember == true ? sharedPref.userName ?? '' : '';
      final password = remember == true ? sharedPref.password ?? '' : '';
      final serverMode = remember == true
          ? (sharedPref.serverCode ?? ServerMode.prod)
          : ServerMode.prod;

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      globalApp.setVersion = packageInfo.version;
      globalApp.setVersionBuild = packageInfo.buildNumber;
      globalApp.setIsInitLang = true;

      emit(LoginLoadSuccess(
          password: password,
          userName: userName,
          serverMode: serverMode,
          isRemember: remember,
          isBiometric: sharedPref.isBiometrics ?? false,
          biometrics: biometrics,
          mode: mode));
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
    }
  }

  Future<void> _mapLoginPressedToState(LoginPressed event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      final remember = event.remember;
      final serverMode = event.serverMode;
      final username = event.username;
      final password = event.password;
      {
        final currentState = state;
        if (currentState is LoginLoadSuccess) {
          if (event.username.trim().isEmpty || event.password.trim().isEmpty) {
            emit(LoginFailure(message: '5041'.tr()));
            emit(currentState.copyWith(
                mode: constants.modeDriver,
                password: password,
                userName: username,
                serverMode: serverMode,
                isRemember: remember));
            return;
          }
          emit(LoginLoading());
          ServerInfo serverInfo;
          if (event.username == 'nangpham') {
            serverInfo = ServerConfig.getAddressServerInfo('QA');
          } else {
            serverInfo = ServerConfig.getAddressServerInfo(event.serverMode);
          }

          final currentVersion = globalApp.version;
          final externalIP = await RGetIp.externalIP;
          final dataToken = DataLoginRequestModel(
            username: event.username.trim(),
            password: event.password.trim(),
            ip: externalIP ?? '',
            systemId: constants.systemId,
            version: globalApp.getVersion.toString(),
            serverType: event.serverMode,
          );

          final apiResultLogin = await _repoLogin.login(
              dataLogin: dataToken, baseUrl: serverInfo.serverAddress ?? '');
          if (apiResultLogin.isFailure) {
            emit(LoginFailure(
                message: apiResultLogin.getErrorMessage(),
                errorCode: apiResultLogin.errorCode));
            return;
          }
          LoginResponse apiLogin = apiResultLogin.data;
          if (apiLogin.payload == null) {
            //khi api trả về null -> show mess
            emit(LoginFailure(
                message: '7'.tr(), errorCode: constants.errorNotExits));

            emit(currentState.copyWith(
                mode: constants.modeDriver,
                serverMode: serverMode,
                isRemember: remember,
                userName: username,
                password: password));
            return;
          } else {
            UserLogin user = UserLogin.fromJson(jsonDecode(apiLogin.payload!));
            log(user.toString());

            if (user.currentVersion != currentVersion) {
              emit(LoginVersionOld());
              emit(currentState.copyWith(
                  mode: constants.modeDriver,
                  password: password,
                  userName: username,
                  serverMode: serverMode,
                  isRemember: remember));
              return;
            }
            UserInfo userInfo = user.userInfo ?? UserInfo();
            event.generalBloc.generalUserInfo = userInfo;
            event.generalBloc.refreshToken = user.refreshToken?.refreshToken;
            log(user.accessToken?.token ?? '');
            globalApp.setToken = user.accessToken?.token ?? '';

            sharedPref.setIsCheckVersion(false);

            emit(LoginSuccess(isDefaultPass: user.useDefaultPass ?? false));

            globalApp.setIsLogin = true;
            sharedPref.setUserName(event.username);
            sharedPref.setPassword(event.password);
            sharedPref.setServerCode(serverInfo.serverCode ?? "");
            sharedPref.setRemember(event.remember);

            globalApp.setServerHub = serverInfo.serverHub ?? '';
            sharedPref.setServerWcf(serverInfo.serverWcf ?? "");
            sharedPref.setServerAddress(serverInfo.serverAddress ?? "");
            sharedPref.setServerSalary(serverInfo.serverSalary ?? "");
            sharedPref.setServerHub(serverInfo.serverHub ?? "");
            sharedPref.setServerMPi(serverInfo.serverMPi ?? "");
            sharedPref.setMode(constants.modeDriver);
          }
        }
      }
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
      final sharedPref = await SharedPreferencesService.instance;
      final remember = sharedPref.remember ?? false;
      final username = remember == true ? sharedPref.userName ?? '' : '';
      final password = remember == true ? sharedPref.password ?? '' : '';
      final serverMode = remember == true
          ? (sharedPref.serverCode ?? ServerMode.prod)
          : ServerMode.prod;
      emit(LoginLoadSuccess(
          serverMode: serverMode,
          isRemember: remember,
          userName: username,
          password: password,
          mode: constants.modeDriver));
    }
  }

  Future<void> _mapChangeServerToState(LoginChangeServer event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadSuccess) {
        final sharedPref = await SharedPreferencesService.instance;

        sharedPref.setServerCode(event.serverMode);
        emit(currentState.copyWith(
          isRemember: event.remember,
          userName: event.username,
          password: event.password,
          serverMode: event.serverMode,
          mode: event.mode == 1 ? constants.modeDriver : constants.modeCustomer,
        ));
      }
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
    }
  }

  void _mapRememberToState(LoginRemember event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadSuccess) {
        emit(currentState.copyWith(
          userName: event.username,
          password: event.password,
          isRemember: !event.remember,
          serverMode: event.serverMode,
          mode: event.mode == 1 ? constants.modeDriver : constants.modeCustomer,
        ));
      }
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
    }
  }

  void _mapLanguageToState(LoginLanguage event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadSuccess) {
        emit(currentState.copyWith(
          isRemember: currentState.isRemember!,
          userName: event.username,
          password: event.password,
          serverMode: event.serverMode,
          mode: event.mode == 1 ? constants.modeDriver : constants.modeCustomer,
        ));
      }
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
    }
  }

  Future<void> _mapAuthLocalToState(AuthLocalEvent event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadSuccess) {
        final sharedPref = await SharedPreferencesService.instance;

        if (sharedPref.isAllowBiometrics == true) {
          if (sharedPref.userName == null ||
              sharedPref.password == null ||
              sharedPref.userName == "" ||
              sharedPref.password == "") {
            emit(LoginFailure(
              message: strings.errInitLogin,
              errorCode: constants.errCodeInitLogin,
            ));
          } else {
            if (event.username != sharedPref.userName &&
                event.username.isNotEmpty) {
              sharedPref.setIsAllowBiometrics(false);
              emit(LoginFailure(
                message: strings.errFirstAccLoginWithBiometrics,
              ));
              return;
            }

            int check = await LocalAuthHelper.isAuthenticated();

            if (check == BiometricsHelper.authenticateSuccess) {
              add(LoginPressed(
                  mode: event.mode,
                  remember: sharedPref.remember ?? false,
                  username: sharedPref.userName!,
                  password: sharedPref.password!,
                  serverMode: sharedPref.serverCode ?? ServerMode.prod,
                  generalBloc: event.generalBloc));
            } else if (check == BiometricsHelper.cancelAuthenticate) {
              emit(currentState);
            } else {
              sharedPref.setIsAllowBiometrics(false);

              emit(LoginFailure(
                message: strings.errBiometrics,
                errorCode: constants.errCodeBiometrics,
              ));
            }
          }
        } else {
          emit(LoginFailure(
            message: strings.errIsNotAllowBiometric,
            errorCode: constants.errCodeNotAllowBiometrics,
          ));
          emit(currentState.copyWith(
            userName: event.username,
            password: event.password,
            serverMode: event.serverMode,
            isRemember: event.remember,
            mode:
                event.mode == 1 ? constants.modeDriver : constants.modeCustomer,
          ));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _mapCustomerLoginPressedToState(
      CustomerLoginPressed event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadSuccess) {
        emit(LoginLoading());
        final sharedPref = await SharedPreferencesService.instance;
        if (event.username.trim().isEmpty || event.password.trim().isEmpty) {
          emit(LoginFailure(message: '5041'.tr()));
          emit(currentState.copyWith(
              password: event.password,
              userName: event.username,
              serverMode: event.serverMode,
              isRemember: event.remember,
              mode: constants.modeCustomer));
          return;
        }
        ServerInfo serverInfo;
        if (event.username == 'nangpham') {
          serverInfo = ServerConfig.getAddressServerInfo('QA');
        } else {
          serverInfo = ServerConfig.getAddressServerInfo(event.serverMode);
        }

        final externalIP = await RGetIp.externalIP;
        final content = CustomerLoginReq(
            ip: externalIP.toString(),
            passWord: event.password,
            systemId: constants.systemIdWebPortal,
            userName: event.username);
        final apiLogin = await _repoLogin.loginCustomer(
            content: content, baseUrl: serverInfo.serverAddress ?? '');
        final LoginResponse response = apiLogin.data;
        if (apiLogin.isSuccess) {
          if (response.payload == null) {
            emit(LoginFailure(
                message: '7'.tr(), errorCode: constants.errorNotExits));
            emit(currentState.copyWith(
                serverMode: event.serverMode,
                isRemember: event.remember,
                userName: event.username,
                password: event.password,
                mode: constants.modeCustomer));
            return;
          }
          UserLogin user =
              UserLogin.fromJson(jsonDecode(response.payload ?? ''));
          event.customerBloc.userLoginRes = user;
          event.customerBloc.refreshToken = user.refreshToken?.refreshToken;
          globalApp.setToken = user.accessToken?.token ?? '';
          log(globalApp.token ?? '');
          globalApp.isLogin = true;
          emit(CustomerLoginSuccess());
          sharedPref.setUserName(event.username);
          sharedPref.setPassword(event.password);
          sharedPref.setServerCode(serverInfo.serverCode ?? '');
          sharedPref.setRemember(event.remember);

          globalApp.setServerHub = serverInfo.serverHub ?? '';
          sharedPref.setServerWcf(serverInfo.serverWcf ?? "");
          sharedPref.setServerAddress(serverInfo.serverAddress ?? "");
          sharedPref.setServerSalary(serverInfo.serverSalary ?? "");
          sharedPref.setServerHub(serverInfo.serverHub ?? "");
          sharedPref.setMode(constants.modeCustomer);

//call api STD background
          final contentCompany = CustomerCompanyReq(
              companyCode: '',
              companyName: '',
              companyType: '',
              contactCode: user.userInfo?.defaultClient ?? '');
          //hardcode Future.wait
          final results = await Future.wait([
            //std
            _iosRepo.getStdCode(
                stdCodeType: constants.customerSTDOOS,
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),
            _iosRepo.getStdCode(
                stdCodeType: constants.customerSTDOOSStatus,
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),
            //contact std
            _customerInventoryRepo.getContactStd(
                stdType: constants.customerSTDGrade,
                contactCode: user.userInfo?.defaultClient ?? '',
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),
            _customerInventoryRepo.getContactStd(
                stdType: constants.customerSTDItemsStatus,
                contactCode: user.userInfo?.defaultClient ?? '',
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),

            _iosRepo.getStdCode(
                stdCodeType: constants.customerSTDIOS,
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),
            _iosRepo.getStdCode(
                stdCodeType: constants.customerSTDNotify,
                subsidiaryId: user.userInfo?.subsidiaryId ?? ''),
            _tosRepo.getCompany(
                content: contentCompany,
                subsidiaryId: user.userInfo?.subsidiaryId ?? '')
          ]);

          ApiResult outbounddateser = results[0];
          ApiResult ordStatus = results[1];
          ApiResult contactStdGrade = results[2];
          ApiResult contactStdItemStatus = results[3];
          ApiResult iosStd = results[4];
          ApiResult notifyStd = results[5];
          ApiResult company = results[6];

          event.customerBloc.stdOUTBOUNDDATESER = outbounddateser.data;
          event.customerBloc.stdOrdStatus = ordStatus.data;
          event.customerBloc.contactStdGrade = contactStdGrade.data;
          event.customerBloc.contactStdItemStatus = contactStdItemStatus.data;
          event.customerBloc.contactStdItemStatus = contactStdItemStatus.data;
          event.customerBloc.stdInboundDateSer = iosStd.data;
          event.customerBloc.stdNotify = notifyStd.data;
          event.customerBloc.companyLst = company.data;

          return;
        }
        emit(LoginFailure(
            message: apiLogin.getErrorMessage(),
            errorCode: apiLogin.errorCode));
      }
    } catch (e) {
      emit(const LoginFailure(message: strings.messError));
      final sharedPref = await SharedPreferencesService.instance;
      final remember = sharedPref.remember ?? false;
      final username = remember == true ? sharedPref.userName ?? '' : '';
      final password = remember == true ? sharedPref.password ?? '' : '';
      final serverMode = remember == true
          ? (sharedPref.serverCode ?? ServerMode.prod)
          : ServerMode.prod;
      emit(LoginLoadSuccess(
          serverMode: serverMode,
          isRemember: remember,
          userName: username,
          password: password,
          mode: constants.modeCustomer));
    }
  }
}
