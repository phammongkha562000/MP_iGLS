import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetHelpers on Widget {
  Widget get center => Center(child: this);

  Widget get sliverBox => SliverToBoxAdapter(child: this);

  //* ------------------  MARGIN  ------------------
  Widget marginAll(double margin) =>
      Container(margin: REdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
        margin:
            REdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
        margin: REdgeInsets.only(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);

  //* ------------------  PADDING  ------------------
  Widget paddingAll(double padding) =>
      RPadding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      RPadding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      RPadding(
        padding:
            EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
        child: this,
      );

  Widget paddingFromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) =>
      RPadding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);

  //* ------------------  SCROLLVIEW  ------------------
  Widget get toScrollView => LayoutBuilder(
        builder: (_, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: this,
              ),
            ),
          );
        },
      );

  Widget get ctl => Align(alignment: Alignment.centerLeft, child: this);
}

extension ImagePath on String {
  String get toWebp => 'assets/images/$this.webp';
  String get toSvg => 'assets/icons/$this.svg';
}

// extension Crypto on String? {
//   String? get toEncrypt => this == null ? null : md5.convert(utf8.encode(this!)).toString();
// }

extension EmptyPadding on num {
  SizedBox get ph => verticalSpace;
  SizedBox get pw => horizontalSpace;
  RSizedBox get wh => RSizedBox(
        width: toDouble(),
        height: toDouble(),
      );

  bool get isInt => this is int || this == roundToDouble();
}

extension GetSizeBox on List<num?> {
  RSizedBox get wh => RSizedBox(
        width: first?.toDouble(),
        height: last?.toDouble(),
      );
}

extension DateUtil on DateTime {
  String get formatted {
    return '$year/$month/$day';
  }

  int? get timeExpired {
    try {
      final today = DateTime.now();
      int? timeDiff;
      if (today.day == day - 1 && today.month == month && today.year == year) {
        timeDiff = today.difference(this).inHours;
      }
      return timeDiff?.abs();
    } catch (e) {
      return null;
    }
  }
}

extension BoolParsing on String? {
  bool parseBool() {
    return this?.toLowerCase() == 'true';
  }
}

extension BoolHelpers on bool? {
  bool get isTrue => this ?? false;
}

extension Unwrap<T> on Future<T?> {
  Future<T> unwrap() => then(
        (value) => value != null ? Future<T>.value(value) : Future.any([]),
      );
}

extension Filter<K, V> on Map<K, V> {
  Iterable<MapEntry<K, V>> filter(
    bool Function(MapEntry<K, V> entry) f,
  ) sync* {
    for (final entry in entries) {
      if (f(entry)) {
        yield entry;
      }
    }
  }
}

extension StringEx on String {
  String toHiding() {
    var newVal = '';
    for (var i = 0; i < length; i++) {
      final el = this[i];
      if (i == 0) {
        newVal += el;
      } else if (el == ' ') {
        newVal += ' ${this[++i]}';
        continue;
      } else {
        newVal += '*';
      }
    }
    return newVal;
  }
}

extension ToMultipart on String {}

extension Override on String? {
  bool get isEmptyOrFalse => this?.isEmpty ?? false;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;
}

extension OverrideList on List<dynamic>? {
  bool get isEmptyOrFalse => this?.isEmpty ?? false;
  bool get isNotEmptyOrFalse => this?.isNotEmpty ?? false;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;
}

extension JoinString on List<String?>? {
  String? showResultJoin() {
    var rs = '';
    if (this?.isNotEmpty ?? false) {
      for (final el in this!) {
        final index = this!.indexOf(el);
        if ((el?.isNotEmpty ?? false) && (index + 1 != this?.length)) {
          rs += '$el, ';
        } else if (index + 1 == this?.length) {
          rs += el ?? '';
        }
      }
    }
    return rs.isEmpty ? null : rs;
  }
}

extension Commons on dynamic {
  T? tryCast<T>({T? defaultValue}) {
    try {
      return this as T;
    } catch (_) {
      return defaultValue;
    }
  }
}
