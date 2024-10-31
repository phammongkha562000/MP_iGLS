import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> createFolderInAppDocDir(String folderName) async {
    //App Document Directory + folder name
    final Directory appDocDirFolder =
        Directory('${await _localPath}/$folderName/');

    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<bool> fileExist({required String fileName}) async {
    final file = await _localFile(fileName);

    return file.existsSync();
  }

  static Future<String> readFile({required String fileName}) async {
    try {
      final file = await _localFile(fileName);
      return await file.readAsString();
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> writeFile(
      {required String fileName, required String contents}) async {
    final file = await _localFile(fileName);
    return file.writeAsString(contents);
  }

  static Future<void> deleteFile({required String fileName}) async {
    try {
      final file = await _localFile(fileName);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteFileInPath({required String path}) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      rethrow;
    }
  }

  static String convertMiliSecondToDate(String date) {
    String strDate;
    if (date.isEmpty) {
      strDate = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      strDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000).toString();
    }
    return strDate;
  }

  static String convertDateForHistoryDetailItem(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM/yyyy HH:mm').format(convertDate).toString();
    }

    return format;
  }

  static String convertddMMItem(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringddMMyyyyHHmm(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM/yyyy HH:mm').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringddMMHHmm(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM - HH:mm').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringddMMHHmm2(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM HH:mm').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringdd(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringddMMyyyy(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('dd/MM/yyyy').format(convertDate).toString();
    }

    return format;
  }

  static String converFromDateTimeToStringddMMyyyy2(String date) {
    String format;
    if (date.isEmpty) {
      format = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      final convertDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
      format = DateFormat('yyyy-MM-dd HH:mm:ss').format(convertDate).toString();
    }

    return format;
  }

  static String formatDateTime(DateTime dateTime) {
    var result = DateFormat("yyyy-MM-dd HH:mm").format(dateTime).toString();
    return result;
  }

  static String formatDDMMyyyfromString(String dateTime) {
    var date = DateFormat("MM/dd/yyyy hh:mm:ss zz").parse(dateTime);
    var result = formatDate(date, [dd, '/', mm, '/', yyyy]);
    return result;
  }

  static DateTime formatToDateTimeFromString(String strDate) {
    int miliseconds =
        int.parse(strDate.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
    return DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);
  }

  static DateTime formatToDateTimeFromString2(String strDate) {
    DateTime parseDate =
        DateFormat("MM/dd/yyyy HH:mm:ss a", "en").parse(strDate);
    return parseDate;
  }

  static String formatToStringFromDatetime(DateTime dateTime) {
    String parseDate = DateFormat("MM/dd/yyyy", "en").format(dateTime);
    return parseDate;
  }

  static String formatToStringFromDatetime2(DateTime dateTime) {
    String parseDate = DateFormat("dd/MM/yyyy", "en").format(dateTime);
    return parseDate;
  }

  static DateTime convertMiliSecondToDateTime(String stringDate) {
    DateTime strDate;

    int miliseconds = int.parse(
        stringDate.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
    strDate = DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000);

    return strDate;
  }

  static String formatToStringNoFlashFromDatetime(DateTime dateTime) {
    String parseDate = DateFormat("yyyyMMdd", "en").format(dateTime);
    return parseDate;
  }
}

Future<String> saveImage(BuildContext context, Image image) {
  final completer = Completer<String>();

  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) async {
    final byteData =
        await imageInfo.image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final fileName = pngBytes.hashCode;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);
    completer.complete(filePath);
  }));

  return completer.future;
}
