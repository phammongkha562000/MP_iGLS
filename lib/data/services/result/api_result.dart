import 'dart:io';

import 'package:dio/dio.dart';

class ApiResult<T> {
  final bool success;
  final T? data;
  final dynamic error;
  final int errorCode;

  ApiResult.success({required this.data})
      : success = true,
        error = null,
        errorCode = 0;

  ApiResult.fail({required this.error, required this.errorCode})
      : success = false,
        data = null;

  bool get isSuccess => success;
  bool get isFailure => !success;

  T getResult() {
    if (success) {
      if (data != null) {
        return data!;
      } else {
        throw Exception("No data available.");
      }
    } else {
      throw Exception("API request failed.");
    }
  }

  String getErrorMessage() {
    if (isFailure && error != null) {
      String errString = 'Đã có lỗi xảy ra';

      if (error is DioException) {
        if (error is SocketException) {
          return 'Kết nối mạng thất bại';
        } else if (error.type == DioExceptionType.badResponse) {
          if (error.response?.statusCode == 401) {
            return '401: Bạn không có quyền truy cập';
          } else if (error.response?.statusCode == 400) {
            return '400: có sự cố xảy ra phía server';
          }
          return 'Lỗi phản hồi từ máy chủ: ${error.response?.statusCode}';
        } else if (error.type == DioExceptionType.unknown) {
          return 'Bạn đang ngoại tuyến, vui lòng kiểm tra lại kết nối internet';
        } else if (error.type == DioExceptionType.connectionTimeout) {
          return 'Lỗi phản hồi từ máy chủ:  ${DioExceptionType.connectionTimeout.name}';
        } else {
          return 'Lỗi: ${error.toString()}';
        }
      }

      return errString;
    } else {
      return "No error message available.";
    }
  }
}
