import 'package:equatable/equatable.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/ha_transaction_report/transaction_request.dart';
import 'package:igls_new/data/models/freight_fowarding/ha_transaction_report/transaction_response.dart';
import 'package:igls_new/data/repository/freight_fowarding/transaction_report/transaction_report_repository.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/services/services.dart';

part 'transaction_report_event.dart';
part 'transaction_report_state.dart';

class TransactionReportBloc
    extends Bloc<TransactionReportEvent, TransactionReportState> {
  final _transactionRepo = getIt<TransactionReportRepository>();
  TransactionReportBloc() : super(TransactionReportInitial()) {
    on<TransactionReportViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      TransactionReportViewLoaded event, emit) async {
    emit(TransactionReportLoading());
    try {
      DateTime dateTime = event.dateTime ?? DateTime.now();
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final content = _content(userInfo: userInfo, dateTime: dateTime);
      final api = await _transactionRepo.getTransactionReport(
          content: content, subsidiaryId: userInfo.subsidiaryId ?? '');
      if (api.isFailure) {
        emit(TransactionReportFailure(message: api.getErrorMessage()));
        return;
      }
      emit(TransactionReportSuccess(report: api.data, dateTime: dateTime));
    } catch (e) {
      emit(TransactionReportFailure(message: e.toString()));
    }
  }

  TransactionReportRequest _content(
      {required UserInfo userInfo, required DateTime dateTime}) {
    final dateFirst = dateTime.firstDayOfMonth;
    final dateLast = dateTime.lastDayOfMonth;
    final dTF = DateFormat(constants.formatyyyyMMdd).format(dateFirst);
    final dTT = DateFormat(constants.formatyyyyMMdd).format(dateLast);
    return TransactionReportRequest(
        branchCode: userInfo.defaultBranch ?? '',
        dateF: dTF,
        dateT: dTT,
        transactionType: null,
        refDocNo: null,
        staffId: userInfo.empCode ?? '',
        reportType: 'DETAIL',
        roleType: '',
        dcCode: userInfo.defaultCenter ?? '');
  }
}
