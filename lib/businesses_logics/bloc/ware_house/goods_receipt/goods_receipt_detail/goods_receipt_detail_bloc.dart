import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/ware_house/goods-receipt/goods_receipt_repository.dart';
import 'package:igls_new/data/repository/ware_house/stock_count/stock_count_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../../data/models/models.dart';
import '../../../../../data/shared/shared.dart';
import '../../../general/general_bloc.dart';

part 'goods_receipt_detail_event.dart';
part 'goods_receipt_detail_state.dart';

class GoodsReceiptDetailBloc
    extends Bloc<GoodsReceiptDetailEvent, GoodsReceiptDetailState> {
  final _goodsReceiptRepo = getIt<GoodsReceiptRepository>();
  final _stockCountRepo = getIt<StockCountRepository>();

  GoodsReceiptDetailBloc() : super(GoodsReceiptDetailInitial()) {
    on<GoodsReceiptDetailViewLoaded>(_mapViewLoadedToState);
    on<GoodsReceiptDetailSave>(_mapSaveToState);
  }
  Future<void> _mapViewLoadedToState(
      GoodsReceiptDetailViewLoaded event, emit) async {
    emit(GoodsReceiptDetailLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final contactCode = userInfo.defaultClient ?? '';
      final subsidiaryId = userInfo.subsidiaryId ?? '';
      final dcCode = userInfo.defaultCenter ?? '';
      //hardcode Future.wait
      final results = await Future.wait([
        _goodsReceiptRepo.getContact(
            stdCodeType: constants.driverSTDGrade,
            codeVariant: '',
            contactCode: contactCode,
            subsidiaryId: subsidiaryId),
        _goodsReceiptRepo.getContact(
            stdCodeType: constants.driverSTDItemsStatus,
            codeVariant: '',
            contactCode: contactCode,
            subsidiaryId: subsidiaryId),
        _stockCountRepo.getLocation(
            dcCode: dcCode,
            locRole: '',
            subsidiaryId: subsidiaryId), //không theo locCode:'RD'
        _goodsReceiptRepo.getSku(
            iOrderNo: event.iOrderNo, companyId: subsidiaryId),
      ]);
      final getGrade = results[0];
      final getStatus = results[1];
      final getLoc = results[2];
      final getSku = results[3];

//grade
      if (getGrade.isFailure) {
        emit(GoodsReceiptDetailFailure(
            message: getGrade.getErrorMessage(),
            errorCode: getGrade.errorCode));
        return;
      }
      List<StdCode> apiGrade = getGrade.data;

//Status
      if (getStatus.isFailure) {
        emit(GoodsReceiptDetailFailure(
            message: getStatus.getErrorMessage(),
            errorCode: getStatus.errorCode));
        return;
      }
      List<StdCode> apiStatus = getStatus.data;

//location
      if (getLoc.isFailure) {
        emit(GoodsReceiptDetailFailure(
            message: getLoc.getErrorMessage(), errorCode: getLoc.errorCode));
        return;
      }
      List<LocationStockCountResponse> apiLocCode = getLoc.data;

      //sku
      if (getSku.isFailure) {
        emit(GoodsReceiptDetailFailure(
            message: getSku.getErrorMessage(), errorCode: getSku.errorCode));
        return;
      }
      List<SkuResponse> apiSku = getSku.data;
      emit(GoodsReceiptDetailSuccess(
          stdCodeGrade: apiGrade,
          stdCodeStatus: apiStatus,
          locationList: apiLocCode,
          skuResponse: apiSku));
    } catch (e) {
      emit(GoodsReceiptDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(GoodsReceiptDetailSave event, emit) async {
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final subsidiaryId = userInfo.subsidiaryId ?? '';
      final currentState = state;

      if (currentState is GoodsReceiptDetailSuccess) {
        emit(GoodsReceiptDetailLoading());
        final goodsReceipt = event.goodsReceiptDetail;
        final content = GoodsReceiptSaveRequest(
          iOrdNo: goodsReceipt.iOrdNo!,
          clientRefNo: goodsReceipt.clientRefNo!,
          grade: event.grade,
          itemStatus: event.status,
          skuId: event.sku.skuId!,
          productionDate: FormatDateConstants.getMMDDYYFromSDDMMYYYStringDate(
              event.propDate),
          expiredDate: FormatDateConstants.getMMDDYYFromSDDMMYYYStringDate(
              event.expDate),
          lotCode: event.lotCode,
          locCode: event.locCode,
          doneByStaff: event.generalBloc.generalUserInfo?.userId ?? '',
          cntrNo: '',
          truckNo: '',
          zoneCode: '',
          eta: goodsReceipt.eta!,
          pwQty: 0,
          isSplit: event.isSplit,
          grQty: event.grQty,
          itemCode: goodsReceipt.itemCode!,
          itemDesc: goodsReceipt.itemDesc!,
          iOrderType: goodsReceipt.iOrdType!,
          createUser: goodsReceipt.createUser!,
          owenerShip: goodsReceipt.ownerShip!,
          baseQty: event.sku.baseQty!,
          qty: goodsReceipt.qty!,
        );

        final apiResultSave = await _goodsReceiptRepo.getSaveGoodsRecepit(
            content: content, subsidiaryId: subsidiaryId);
        if (apiResultSave.isFailure) {
          emit(GoodsReceiptDetailFailure(
              message: apiResultSave.getErrorMessage(),
              errorCode: apiResultSave.errorCode));
          return;
        }
        StatusResponse apiResponse = apiResultSave.data;
        if (apiResponse.isSuccess != true) {
          emit(const GoodsReceiptDetailFailure(message: strings.messError));
          emit(currentState);
          
          return;
        }
        emit(currentState.copyWith(saveSuccess: true));
      }
    } catch (e) {
      emit( GoodsReceiptDetailFailure(message: e.toString()));
    }
  }
}
