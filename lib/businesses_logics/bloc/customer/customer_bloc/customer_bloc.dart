import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/data/models/customer/customer_profile/subsidiary_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/models/login/refresh_token_req.dart';
import 'package:igls_new/data/repository/login/login_repository.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import '../../../../data/services/services.dart';
import '../../../../data/shared/shared.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  UserLogin? userLoginRes;
  String? refreshToken;
  CustomerPermissionRes? cusPermission;
  SubsidiaryRes? subsidiaryRes;
  List<ContactCodeRes>? contactList;
  List<GetStdCodeRes>? stdOUTBOUNDDATESER;
  List<GetStdCodeRes>? stdOrdStatus;
  List<GetStdCodeRes>? contactStdGrade;
  List<GetStdCodeRes>? contactStdItemStatus;
  List<GetStdCodeRes>? stdInboundDateSer;
  List<GetStdCodeRes>? stdNotify;
  List<CustomerCompanyRes>? companyLst;

  CustomerBloc() : super(CustomerInitial()) {
    on<LogoutEvent>(_logOut);
    on<CustomerAddIntercepter>(_mapAddInterceptorToState);
  }
  Future _logOut(LogoutEvent event, emit) async {
    getIt<AbstractDioHttpClient>().client.interceptors.clear();
    stdOUTBOUNDDATESER = null;
    stdOrdStatus = null;
    contactStdGrade = null;
    contactStdItemStatus = null;
    stdInboundDateSer = null;
    stdNotify = null;
    companyLst = null;
    cusPermission = null;
    refreshToken = null;
    userLoginRes = null;
    emit(LogoutState());
  }

  void _mapAddInterceptorToState(CustomerAddIntercepter event, emit) {
    getIt<AbstractDioHttpClient>()
        .addInterceptor(InterceptorsWrapper(onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (e, handler) async {
      if (e.response == null) {
        return handler.next(e);
      }

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
            systemId: constants.systemIdWebPortal,
            accessToken: globalApp.getToken ?? '',
            refreshToken: refreshToken ?? '');
        var refreshRes = await repoLogin.refreshToken(content: content);
        if (refreshRes.success) {
          if (refreshRes.data?.success != true) {
            log('customer refresh token failure');

            return dialogToLogin();
          } else {
            log('customer refresh token success');
            UserLogin user =
                UserLogin.fromJson(jsonDecode(refreshRes.data.payload));
            refreshToken = user.refreshToken?.refreshToken;
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
          } catch (e) {
            log(e.toString());
          }
          return;
        }
      } else {
        return dialogToLogin();
      }
    }));
  }

  dialogToLogin({String? text}) async {
    final navigationService = getIt<NavigationService>();
    return CustomDialog().warning(
        navigationService.navigatorKey.currentContext!,
        message: text ?? 'Hết phiên làm việc, vui lòng đăng nhập lại'.tr(),
        isCancel: false, ok: () {
      add(LogoutEvent());
      navigationService.pushNamed(routes.loginViewRoute);
    });
  }
}
