import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/data/enum/status_enum.dart';

class TextByTypeStatus extends StatelessWidget {
  const TextByTypeStatus({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Text(
      fromCodetoString(status).toLowerCase().tr().toUpperCase(),
      style: TextStyle(
        color: StatusEnum.from(status).toColor(),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

  String fromCodetoString(String code) {
    switch (code) {
      case 'MANUALPOST':
        return '5687';
      case 'CAN':
        return '5688';
      case 'NEW':
        return '5689';
      case 'INPR':
        return '5690';
      case 'CLOS':
      case 'CLOSED':
        return '5691';
      case 'DROP':
        return '5692';
      case 'DRAF':
        return '5693';

      default:
        return 'undefined';
    }
  }
}
