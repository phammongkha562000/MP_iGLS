import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class StatusEnum {
  const StatusEnum._(this._code);

  final String _code;
  String get code => _code;

  static const StatusEnum undefined = StatusEnum._('');
  static const StatusEnum manualPost = StatusEnum._('MANUALPOST');
  static const StatusEnum cancel = StatusEnum._('CAN');
  static const StatusEnum newStt = StatusEnum._('NEW');
  static const StatusEnum inprogress = StatusEnum._('INPR');

  static const StatusEnum closed = StatusEnum._('CLOS');
  static const StatusEnum closed2 = StatusEnum._('CLOSED');
  static const StatusEnum dropped = StatusEnum._('DROP');
  static const StatusEnum draftSave = StatusEnum._('DRAF');
  static const StatusEnum reply = StatusEnum._('REPLY');

  static const StatusEnum recl = StatusEnum._("RECL");
  static const StatusEnum requ = StatusEnum._("REQU");
  static const StatusEnum reco = StatusEnum._("RECO");
  static const StatusEnum reop = StatusEnum._("REOP");

  factory StatusEnum.from(String code) {
    switch (code) {
      case 'MANUALPOST':
        return manualPost;
      case 'CAN':
        return cancel;
      case 'NEW':
        return newStt;
      case 'INPR':
        return inprogress;
      case 'CLOS':
      case 'CLOSED':
        return closed;
      case 'DROP':
        return dropped;
      case 'DRAF':
        return draftSave;
      case 'REPLY':
        return reply;
      case 'RECL':
        return recl;
      case 'REQU':
        return requ;
      case 'RECO':
        return reco;
      case 'REOP':
        return reop;
      default:
        return undefined;
    }
  }

  Color toColor() {
    switch (_code) {
      case 'MANUALPOST':
        return colors.aliceBlue;
      case 'CAN':
        return colors.outerSpace;
      case 'NEW':
        return colors.textBlue;
      case 'INPR':
      case 'REPLY':
        return colors.amber;
      case 'CLOS':
        return colors.textRed;
      case 'DROP':
        return colors.outerSpace;
      case 'DRAF':
        return colors.outerSpace;
      case 'RECL':
      case 'REQU':
      case 'RECO':
      case 'REOP':
        return colors.outerSpace;

      default:
        return Colors.transparent;
    }
  }
}
