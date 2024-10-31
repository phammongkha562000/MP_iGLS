import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/models.dart';
import 'package:igls_new/data/repository/freight_fowarding/cash_cost_approval/cash_cost_approval_repository.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/shared/utils/utils.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:collection/collection.dart';

import '../../../../data/services/result/result.dart';
import '../../general/general_bloc.dart';

part 'cash_cost_approval_event.dart';
part 'cash_cost_approval_state.dart';

class CashCostApprovalBloc
    extends Bloc<CashCostApprovalEvent, CashCostApprovalState> {
  final _cashCostApprovalRepo = getIt<CashCostApprovalRepository>();
  final _userprofileRepo = getIt<UserProfileRepository>();

  int pageNumber = 1;
  bool endPage = false;
  String contact = "";

  CashCostApprovalBloc() : super(CashCostApprovalInitial()) {
    on<CashCostApprovalViewLoaded>(_mapViewLoadedToState);
    on<CashCostApprovalPreviousDateLoaded>(_mapPreviousToState);
    on<CashCostApprovalNextDateLoaded>(_mapNextToState);
    on<CashCostApprovalPickDate>(_mapPickDateToState);
    on<CashCostApprovalSelected>(_mapSelectedToState);
    on<CashCostApprovalUpdate>(_mapUpdateToState);
    on<CashCostApprovalPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(
      CashCostApprovalViewLoaded event, emit) async {
    emit(CashCostApprovalLoading());
    try {
      endPage = false;
      pageNumber = 1;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;
      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userprofileRepo.getLocal(
            userId: userInfo.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResult.isFailure) {
          emit(CashCostApprovalFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }
      List<ContactLocal> contactLst = event.generalBloc.listContactLocal;
      contact = contactLst.map((e) => e.contactCode).toList().join(',');

      final apiResult = await _getCashCost(
        subsidiaryId: userInfo.subsidiaryId ?? '',
        defaultBranch: userInfo.defaultBranch ?? '',
        tradeType: event.tradeType,
        eventDate: event.date,
        userId: userInfo.userId ?? '',
      );
      if (apiResult.isFailure) {
        emit(CashCostApprovalFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(CashCostApprovalFailure(
            message: apiResponse.error?.message,
            errorCode: apiResponse.error?.errorCode));
        return;
      }
      CashCostApprovalResponse cashCostRes = apiResponse.payload;

      List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];
      _groupCarrierBCNo(list: cashCostList);

      emit(CashCostApprovalSuccess(
        tradeType: event.tradeType,
        date: event.date,
        cashCostList: cashCostList,
      ));
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapPickDateToState(CashCostApprovalPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        emit(CashCostApprovalLoading());
        endPage = false;
        pageNumber = 1;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final date = event.date ?? currentState.date;
        final tradeType = event.tradeType ?? currentState.tradeType;
        final apiResult = await _getCashCost(
          subsidiaryId: userInfo.subsidiaryId ?? '',
          defaultBranch: userInfo.defaultBranch ?? '',
          tradeType: tradeType,
          eventDate: date,
          userId: userInfo.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(CashCostApprovalFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(CashCostApprovalFailure(
              message: apiResponse.error?.message,
              errorCode: apiResponse.error?.errorCode));
          return;
        }
        CashCostApprovalResponse cashCostRes = apiResponse.payload;

        List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];

        _groupCarrierBCNo(list: cashCostList);

        emit(CashCostApprovalSuccess(
            tradeType: tradeType, date: date, cashCostList: cashCostList));
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapPreviousToState(
      CashCostApprovalPreviousDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        endPage = false;
        pageNumber = 1;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();
        emit(CashCostApprovalLoading());
        final previous = currentState.date.findPreviousDate;
        final apiResult = await _getCashCost(
          subsidiaryId: userInfo.subsidiaryId ?? '',
          defaultBranch: userInfo.defaultBranch ?? '',
          tradeType: currentState.tradeType,
          eventDate: previous,
          userId: userInfo.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(CashCostApprovalFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(CashCostApprovalFailure(
              message: apiResponse.error?.message,
              errorCode: apiResponse.error?.errorCode));
          return;
        }
        CashCostApprovalResponse cashCostRes = apiResponse.payload;

        List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];
        _groupCarrierBCNo(list: cashCostList);

        emit(currentState.copyWith(date: previous, cashCostList: cashCostList));
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapNextToState(
      CashCostApprovalNextDateLoaded event, emit) async {
    try {
      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        emit(CashCostApprovalLoading());
        endPage = false;
        pageNumber = 1;
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final next = currentState.date.findNextDate;
        final apiResult = await _getCashCost(
          subsidiaryId: userInfo.subsidiaryId ?? '',
          defaultBranch: userInfo.defaultBranch ?? '',
          tradeType: currentState.tradeType,
          eventDate: next,
          userId: userInfo.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(CashCostApprovalFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(CashCostApprovalFailure(
              message: apiResponse.error?.message,
              errorCode: apiResponse.error?.errorCode));
          return;
        }
        CashCostApprovalResponse cashCostRes = apiResponse.payload;

        List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];
        _groupCarrierBCNo(list: cashCostList);
        emit(currentState.copyWith(date: next, cashCostList: cashCostList));
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapSelectedToState(CashCostApprovalSelected event, emit) async {
    try {
      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        emit(CashCostApprovalLoading());
        List<CashCostApproval> cashCostSelect = [];
        for (var e in event.cashCostList) {
          cashCostSelect = currentState.cashCostList[event.index].items!
              .map((element) => element.woNo == e.woNo
                  ? element.copyWith(isSelected: event.isSelected)
                  : element)
              .toList();
        }

        final list2 = currentState.cashCostList
            .map((e) => currentState.cashCostList[event.index] == e
                ? currentState.cashCostList[event.index]
                    .copyWith(items: cashCostSelect)
                : e)
            .toList();

        _groupCarrierBCNo(list: list2);

        emit(currentState.copyWith(isSuccess: null, cashCostList: list2));
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(CashCostApprovalUpdate event, emit) async {
    try {
      final List<int> cwoId = [];
      final List<int> cwoCId = [];
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        emit(CashCostApprovalLoading());

        for (var item in currentState.cashCostList) {
          for (var item2 in item.items!) {
            if (item2.isSelected == true) {
              if (item2.costSource == 'BL') {
                cwoId.add(item2.docId!);
              } else {
                cwoCId.add(item2.docId!);
              }
            }
          }
        }
        if (cwoCId.isEmpty && cwoId.isEmpty) {
          emit(const CashCostApprovalFailure(message: '5166'));
          emit(currentState.copyWith(isSuccess: null));
          return;
        }
        String cwoidStr = cwoId.join(',');
        String cwocidStr = cwoCId.join(',');
        final content = CashCostApprovalSaveRequest(
            contactCode: userInfo.defaultClient ?? '',
            cwoId: cwoidStr,
            cwoCId: cwocidStr,
            userId: userInfo.userId ?? '');
        final apiSave = await _cashCostApprovalRepo.getCashCostApprovalSave(
            content: content, subsidiaryId: userInfo.subsidiaryId!);
        if (apiSave.isSuccess != true) {
          emit(currentState.copyWith(
            isSuccess: false,
          ));
          return;
        }

        final apiResult = await _getCashCost(
          subsidiaryId: userInfo.subsidiaryId ?? '',
          defaultBranch: userInfo.defaultBranch ?? '',
          tradeType: currentState.tradeType,
          eventDate: currentState.date,
          userId: userInfo.userId ?? '',
        );
        if (apiResult.isFailure) {
          emit(CashCostApprovalFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(CashCostApprovalFailure(
              message: apiResponse.error?.message,
              errorCode: apiResponse.error?.errorCode));
          return;
        }
        CashCostApprovalResponse cashCostRes = apiResponse.payload;

        List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];
        _groupCarrierBCNo(list: cashCostList);
        emit(
            currentState.copyWith(cashCostList: cashCostList, isSuccess: true));
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(CashCostApprovalPaging event, emit) async {
    try {
      UserInfo userInfo = event.userInfo;

      final currentState = state;
      if (currentState is CashCostApprovalSuccess) {
        if (endPage == false) {
          emit(CashCostApprovalLoading());
          pageNumber++;
          final apiResult = await _getCashCost(
            subsidiaryId: userInfo.subsidiaryId ?? '',
            defaultBranch: userInfo.defaultBranch ?? '',
            tradeType: currentState.tradeType,
            eventDate: currentState.date,
            userId: userInfo.userId ?? '',
          );
          if (apiResult.isFailure) {
            emit(CashCostApprovalFailure(
                message: apiResult.getErrorMessage(),
                errorCode: apiResult.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResult.data;
          if (apiResponse.success == false) {
            emit(CashCostApprovalFailure(
                message: apiResponse.error?.message,
                errorCode: apiResponse.error?.errorCode));
            return;
          }
          CashCostApprovalResponse cashCostRes = apiResponse.payload;

          List<CashCostApprovalResult> cashCostList = cashCostRes.results ?? [];
          if (cashCostList != [] && cashCostList.isNotEmpty) {
            _groupCarrierBCNo(list: cashCostList);
            emit(currentState.copyWith(
                cashCostList: [...currentState.cashCostList, ...cashCostList]));
          } else {
            endPage = true;
            emit(currentState);
          }
        }
      }
    } catch (e) {
      emit(CashCostApprovalFailure(message: e.toString()));
    }
  }

  Future<ApiResult> _getCashCost(
      {required String tradeType,
      required DateTime eventDate,
      required String defaultBranch,
      required String userId,
      required String subsidiaryId}) async {
    final content = BulkCostApprovalSearchRequest(
        contactCode: contact,
        tradeType: tradeType,
        reqDateF: DateFormat(constants.formatyyyyMMdd).format(eventDate),
        reqDateT: DateFormat(constants.formatyyyyMMdd).format(eventDate),
        createUser: userId,
        woNo: '',
        blNo: '',
        cntrNo: '',
        paymentMode: "" /* 'CATR,BTRF' */,
        approvalMode: 'UAPPV',
        payToContactCode: '',
        accountCode: '',
        branchCode: defaultBranch,
        pageNumber: pageNumber,
        pageSize: constants.sizePaging);

    return await _cashCostApprovalRepo.getCashCostApproval(
        content: content, subsidiaryId: subsidiaryId);
  }

  List<CashCostApprovalResult> _groupCarrierBCNo(
      {required List<CashCostApprovalResult> list}) {
    for (var element in list) {
      final menuGroupBy = groupBy(
          element.items!,
          (CashCostApproval elm) =>
              (elm.carrierBcNo != '' && elm.carrierBcNo != null)
                  ? elm.carrierBcNo
                  : elm.blNo);

      element.itemGroup =
          menuGroupBy.entries.map((entry) => entry.value).toList();
    }
    return list;
  }
}
