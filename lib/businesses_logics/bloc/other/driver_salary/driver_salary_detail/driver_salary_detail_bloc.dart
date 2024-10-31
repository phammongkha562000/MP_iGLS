import 'dart:developer';
import 'dart:io';

// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/server/constants.dart';

import 'package:igls_new/data/models/driver_salary/driver_salary_response.dart';
import 'package:igls_new/data/repository/other/driver_salary/driver_salary_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:path_provider/path_provider.dart';


import '../../../../../presentations/common/constants.dart' as constants;
import '../../../general/general_bloc.dart';

part 'driver_salary_detail_event.dart';
part 'driver_salary_detail_state.dart';

class DriverSalaryDetailBloc
    extends Bloc<DriverSalaryDetailEvent, DriverSalaryDetailState> {
  final _repoSalary = getIt<DriverSalaryRepository>();
  // final _logger = Logger(GlobalApp.logz.toString());

  DriverSalaryDetailBloc() : super(DriverSalaryDetailInitial()) {
    on<DriverSalaryDetailLoaded>(_mapViewToState);
    on<DriverSalaryDownAndGetFile>(_mapDownAndGetFile);
  }
  Future<void> _mapViewToState(DriverSalaryDetailLoaded event, emit) async {
    try {
      emit(DriverSalaryDetailLoading());
      final sharedPref = await SharedPreferencesService.instance;

      var empCode = event.generalBloc.generalUserInfo?.empCode ?? '';
      final sv = sharedPref.serverSalary;
      final apiResult = await _repoSalary.getFileSalary(
        empCode: empCode.toString(),
        baseUrl: sv.toString(),
      );
      if (apiResult.isFailure) {
        emit(DriverSalaryDetailFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      DriverSalaryResponse getSalary = apiResult.data;

      String url = "";
      switch (sharedPref.serverCode) {
        case ServerMode.dev:
          url = "https://dev.mpi.mplogistics.vn:9099/uploads/";
          // url = "https://dev.igls.vn:9099/uploads/";
          break;
        case ServerMode.qa:
          url = "http://192.168.70.135:8088/uploads";
          // ?? ": https://qa.mpi.mplogistics.vn:8088/uploads";
          break;
        case ServerMode.prod:
          url = "https://mpi.mplogistics.vn/uploads";
          break;
        default:
      }

      if (getSalary.success == true) {
        emit(DriverSalaryDetailSuccess(
          listDriverSalary: getSalary.payload ?? [],
          // *Test
          // listDriverSalry: [],
          url: url,
        ));
        getIt<AbstractDioHttpClient>().addOptions(
            BaseOptions(baseUrl: sharedPref.serverAddress.toString()));
        log("OK");
      } else {
        emit(const DriverSalaryDetailFailure(message: "Load fails"));
      }
    } catch (e) {
      // _logger.severe("Driver Salary Fails", e.toString());
      emit(DriverSalaryDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapDownAndGetFile(
      DriverSalaryDownAndGetFile event, emit) async {
    try {
      final currentState = state;
      if (currentState is DriverSalaryDetailSuccess) {
        var pathNew = event.filePath.replaceAll("\\", "/");

        // * Đặt tên cho file
        var fileName = "salary_${event.item.yyyymm}";
        var fileLocation = "";
        switch (checkFileType(pathNew)) {
          case "PDF":
            fileName = "$fileName.pdf";
            break;
          case "XLSX":
            fileName = "$fileName.xlsx";

            break;
          default:
            break;
        }
        try {
          var downloadFile =
              await downloadFilePDF(pathNew: pathNew, fileName: fileName);

          if (downloadFile == true) {
            fileLocation = await getPathFile(fileName: fileName);
            emit(
              DriverSalaryDownFileSuccessfully(
                fileLocation: fileLocation,
                fileType: checkFileType(pathNew),
              ),
            );
          }
        } catch (e) {
          emit(
            DriverSalaryDetailFailure(
                message: "download_file_error".tr(),
                errorCode: constants.errDownloadAndGet),
          );
        }

        emit(currentState);
      }
    } catch (e) {
      emit(
        DriverSalaryDetailFailure(
            message: "download_file_error".tr(),
            errorCode: constants.errDownloadAndGet),
      );
    }
  }

  Future<bool> downloadFilePDF({
    required String pathNew,
    required String fileName,
  }) async {
    try {
      void showDownloadProgress(received, total) {
        if (total != -1) {
          log((received / total * 100).toStringAsFixed(0) + "%");
        }
      }

      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory(); //FOR iOS
      final path = '${directory!.path}/$fileName';
      final dio = Dio();
      
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      //     (HttpClient client) {
      //   client.badCertificateCallback =
      //       (X509Certificate cert, String host, int port) => true;
      //   return client;
      // };
      final response = await dio.get(
        pathNew,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          contentType: "application/pdf",
        ),
      );
      // log("${response.headers}");
      final file = File(path);
      // log(file.toString());
      await file.writeAsBytes(response.data, flush: true);
      await file.exists();
      return true;
    } catch (e) {
      log("ERR: $e");
      return false;
    }
  }

  Future<String> getPathFile({
    required String fileName,
  }) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS

    // final file = File(fileName).path;
    return '${directory!.path}/$fileName';
  }

  String checkFileType(String fileString) {
    // Extract the file extension
    String fileExtension = fileString.split('.').last;

    Map<String, String> fileTypeMap = {
      'pdf': 'PDF',
      'xlsx': 'XLSX',
    };
    String fileType = fileTypeMap[fileExtension] ?? 'Unknown file type';

    return fileType;
  }
}
