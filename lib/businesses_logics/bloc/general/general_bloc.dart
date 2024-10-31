import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/global/global.dart';
import 'package:igls_new/data/models/customer/customer_profile/subsidiary_res.dart';
import 'package:igls_new/data/models/login/refresh_token_req.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../data/models/notification/firebase_noti_model.dart';
import '../../../data/models/std_code/std_code_2_response.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../data/repository/repository.dart';
import '../../../data/services/services.dart';

part 'general_event.dart';
part 'general_state.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  UserInfo? generalUserInfo;
  String? refreshToken;
  List<CySiteResponse> listCY = [];
  List<PageMenuPermissions> listMenu = [];
  List<LocationStockCountResponse> listLocation = [];
  List<DcLocal> listDC = [];
  List<ItemCodeResponse> listItemCode = [];
  List<ContactLocal> listContactLocal = [];
  List<StdCode> listStdShuttle = [];
  List<ContactResponse> listContactResponse = [];
  List<StdCode> listRoleType = [];
  List<StdCode> listWorkingStatus = [];
  List<EquipmentResponse> listEquipmentRes = [];
  List<StdCode2Response> listStdLang = [];
  List<StdCode2Response> listUserRole = [];
  List<StdCode> listOwnership = [];
  List<StdCode> listEquipmentGroup = [];
  bool isGetTokenFcm = false;
  String? token;
  SubsidiaryRes? subsidiaryRes;

  GeneralBloc() : super(GeneralInitial()) {
    on<GeneralLogout>(_mapLogoutToState);
    on<LoginToHub>(_loginToHub);
    on<AddInterceptor>(_mapAddInterceptorToState);
  }
  static final _userProfileRepo = getIt<UserProfileRepository>();

  void _mapLogoutToState(GeneralLogout event, emit) async {
    try {
      if (token != null) {
        final model = NotificationsModel(
          userId: generalUserInfo?.userId.toString() ?? '',
          userName: generalUserInfo?.userName ?? '',
          token: token!,
          platform: constants.systemId,
          status: 1,
        );
        final logoutFromHubResult =
            await _userProfileRepo.logoutFromHub(model: model);
        if (logoutFromHubResult.isSuccess) {
          log('Logged Out');
          isGetTokenFcm = false;
        }
      }
      final sharedPref = await SharedPreferencesService.instance;
      final items = SharedPrefKeys.listKey;
      for (var item in items) {
        await sharedPref.remove(item);
      }

      generalUserInfo = null;
      refreshToken = null;
      listCY.clear();
      listMenu.clear();
      listLocation.clear();
      listDC.clear();
      listItemCode.clear();
      listContactLocal.clear();
      listStdShuttle.clear();
      listContactResponse.clear();
      listRoleType.clear();
      listWorkingStatus.clear();
      listEquipmentRes.clear();
      listStdLang.clear();
      listUserRole.clear();
      listOwnership.clear();
      listEquipmentGroup.clear();
      globalApp.setIsLogin = false;
      globalApp.setCountNotification = null;
      globalApp.setIsAllowance = false;
      getIt<AbstractDioHttpClient>().client.interceptors.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loginToHub(LoginToHub event, emit) async {
    try {
      if (isGetTokenFcm == false) {
        final model = NotificationsModel(
            userId: generalUserInfo?.userId.toString() ?? '',
            userName: generalUserInfo?.userName ?? '',
            platform: constants.systemId,
            token: event.token,
            status: 1,
            userVersion: globalApp.getVersion ?? '');
        token = event.token;
        final loginHubResult = await _userProfileRepo.loginToHub(model: model);
        if (loginHubResult.isFailure) {
          return;
        }
        isGetTokenFcm = true;
        return;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _mapAddInterceptorToState(AddInterceptor event, emit) {
    getIt<AbstractDioHttpClient>()
        .addInterceptor(InterceptorsWrapper(onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (e, handler) async {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return dialogToLogin(text: strings.errMess400);
        }
        if (e.response != null &&
            e.response!.data.toString().contains("ERR007")) {
          final repoLogin = getIt<LoginRepository>();
          RequestOptions requestOptions = e.requestOptions;
          final sharedPref = await SharedPreferencesService.instance;
          final content = RefreshTokenReq(
              userName: sharedPref.userName ?? "",
              systemId: constants.systemId,
              accessToken: globalApp.token ?? '',
              refreshToken: refreshToken ?? '');
          var refreshRes = await repoLogin.refreshToken(content: content);
          if (refreshRes.success == true) {
            if (refreshRes.data?.success != true) {
              log('driver refresh token failure');
              return dialogToLogin();
            } else {
              log('driver refresh token success');
              UserLogin user =
                  UserLogin.fromJson(jsonDecode(refreshRes.data.payload!));

              refreshToken = user.refreshToken?.refreshToken;
              globalApp.setToken = '';
              globalApp.setToken = user.accessToken?.token ?? '';
            }
            try {
              final opts = Options(
                method: requestOptions.method,
                headers: {
                  'Authorization': "Bearer ${globalApp.token}",
                  "Content-Type": "application/json"
                },
              );
              var response = await Dio().request(
                  options: opts,
                  "${requestOptions.baseUrl}${requestOptions.path}",
                  data: requestOptions.data,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  queryParameters: requestOptions.queryParameters);
              if (response.statusCode == 200) {
                handler.resolve(response);
              } else {
                handler.next(e);
              }
              return;
            } catch (e) {
              log(e.toString());
            }
            return;
          }
          return dialogToLogin();
        } else {
          return handler.next(e);
        }
      }
    }));
  }

  dialogToLogin({String? text}) async {
    final navigationService = getIt<NavigationService>();
    return CustomDialog().warning(
        navigationService.navigatorKey.currentContext!,
        message: text ?? 'Hết phiên làm việc, vui lòng đăng nhập lại'.tr(),
        isCancel: false, ok: () {
      add(GeneralLogout());
      navigationService.pushNamed(routes.loginViewRoute);
    });
  }
}
