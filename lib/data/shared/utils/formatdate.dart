import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

class FormatDateConstants {
  static const String dateTimeSearch = "yyyyMMdd";

  // -> dd/mm/yyyy
  static String getYYYYMMDDHHMMSStoMMDDYYYY(String strDate) {
    if (strDate.isEmpty) return "";
    var date = DateFormat("yyyy-MM-dd hh:mm:ss").parse(strDate);
    var result = formatDate(date, [dd, '/', mm, '/', yyyy]);
    return result;
  }

  // ->dd/mm HH:mm
  static String getDDMMHHMMFromStringDate2(String strDate) {
    if (strDate.isEmpty) return "";
    var date = DateFormat("dd/MM/yyyy HH:mm").parse(strDate);
    var result = formatDate(date, [dd, '/', mm, ' ', HH, ':', nn]);
    return result;
  }

  // -> mm/dd/yyyy
  static String getMMDDYYFromSDDMMYYYStringDate(String strDate) {
    if (strDate.isEmpty) return "";
    var date = DateFormat('yyyy-MM-dd').parse(strDate);
    var result = formatDate(date, [mm, '/', dd, '/', yyyy]);
    return result;
  }

  // -> mm/dd/yyyy HH:mm
  static String getCurrentDate() {
    var result = formatDate(
      DateTime.now(),
      [mm, '/', dd, '/', yyyy, ' ', HH, ':', nn],
    );
    return result;
  }

  static String getCurrentDate2() {
    var date = DateFormat("MM/dd/yyyy HH:mm", 'en').format(DateTime.now());
    log(date);
    return date;
  }

  // -> dd/MM HH:mm
  static String convertddMMHHmm(String strDate) {
    if (strDate.isEmpty) return "";

    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("dd/MM HH:mm").format(inputFormat);
  }

  //  -> dd/MM:
  static String convertddMM(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en") //hh: 12h
        .parse(strDate); //HH -> hh: 10/4/2023
    // Trả về kết quả theo format
    return DateFormat("dd/MM").format(inputFormat);
  }

  // -> Conver MM/dd/YYYY
  static String convertMMddyyyy(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("MM/dd/yyyy").format(inputFormat);
  }

  static String convertddMMyyyyDate(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("dd/MM/yyyy").format(inputFormat);
  }

  // -> Conver MM/dd/YYYY HH:mm
  static String convertMMddyyyyHHmm(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("MM/dd/yyyy HH:mm").format(inputFormat);
  }

  static String convertyyyyMMddHHmm(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(inputFormat);
  }

  static String convertyyyyMMddHHmmToHHmm(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("HH:mm").format(inputFormat);
  }

  static String convertMMddyyyy2(String strDate) {
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    var date = DateFormat("MM/dd/yyyy", "en").format(inputFormat);
    return date;
  }

  static String convertddMMyyyy(String strDate) {
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    var date = DateFormat("dd/MM/yyyy", "en").format(inputFormat);
    return date;
  }

  static String convertHHmm(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("HH:mm", "en").format(inputFormat);
  }

  static String convertddMMyyyyHHmm2(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("dd/MM/yyyy HH:mm", "en").format(inputFormat);
  }

  static String convertMMddyyyhhmm(String strDate) {
    if (strDate.isEmpty) return "";
    //12/7/2022 4:32:21 PM
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    // Trả về kết quả theo format
    return DateFormat("MM/dd/yyyy hh:mm:ss").format(inputFormat);
  }

  static String convertStringFromDateTime(DateTime dateTime) {
    var outFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").format(dateTime);
    // Trả về kết quả theo format
    return outFormat;
  }

  static String convertMMddyyyy3(String strDate) {
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    var date = DateFormat("MM/dd/yyyy", "en").format(inputFormat);
    log(date);
    return date;
  }

  static DateTime convertToDateTimeMMddyyyy(String strDate) {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(
        DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate).toString());
    log(tempDate.toString());
    return tempDate;
  }

  static DateTime convertToDateTimeMMddyyyy2(String strDate) {
    DateTime tempDate = DateFormat(constants.formatyyyyMMddHHmm, "en")
        .parse(DateFormat('MM/dd/yyyy HH:mm', "en").parse(strDate).toString());
    log(tempDate.toString());
    return tempDate;
  }

  static String convertMMddyyyy4(DateTime dateTime) {
    var dateString = DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime);
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    var date = DateFormat("dd/MM/yyyy", "en").format(tempDate);
    return date;
  }

  static String convertddMMyyyyHHmm(DateTime dateTime) {
    var dateString = DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime);
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    var date = DateFormat("dd/MM/yyyy HH:mm", "en").format(tempDate);
    return date;
  }

  static String convertToddMMyyyy(String strDate) {
    var inputFormat = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    var date = DateFormat("dd/MM/yyyy HH:mm", "en").format(inputFormat);
    return date;
  }

  static String formatddMMyyyyToMMddyyyy(String ddyyyy) {
    var inputFormat = DateFormat('dd/MM/yyyy', "en").parse(ddyyyy);
    var date = DateFormat("MM/dd/yyyy", "en").format(inputFormat);
    return date;
  }
}

class DateFormatLocal {
  static String formatddMMyyyy(String strDate) {
    if (strDate.isEmpty) return "";
    var input = DateFormat('MM/dd/yyyy hh:mm:ss a', "en").parse(strDate);
    return DateFormat("dd/MM/yyyy").format(input);
  }
}

int dateTimeToTicks(DateTime dateTime) =>
    ((DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch)
                .millisecondsSinceEpoch *
            (constants.toMilliseconds)) +
        constants.ticksFormSinceEpoch);
