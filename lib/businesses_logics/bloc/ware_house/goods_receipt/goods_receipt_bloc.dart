import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/repository/ware_house/goods-receipt/goods_receipt_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../data/models/models.dart';
import '../../general/general_bloc.dart';

part 'goods_receipt_event.dart';
part 'goods_receipt_state.dart';

class GoodsReceiptBloc extends Bloc<GoodsReceiptEvent, GoodsReceiptState> {
  final _goodsReceiptRepo = getIt<GoodsReceiptRepository>();
  GoodsReceiptBloc() : super(GoodsReceiptInitial()) {
    on<GoodsReceiptViewLoaded>(_mapViewLoadedToState);
    on<GoodsReceiptPickDate>(_mapPickDateToState);
    on<GoodsReceiptPickOrderNo>(_mapPickOrderNoToState);
    on<GoodsReceiptSearch>(_mapSearchToState);
  }
  Future<void> _mapViewLoadedToState(GoodsReceiptViewLoaded event, emit) async {
    emit(GoodsReceiptLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final contentOrder = await _getContentOrder(
          userInfo: userInfo,
          dateEvent: event.date,
          orderNo: event.orderNo ?? '');
      final apiResultOder =
          await _goodsReceiptRepo.getGoodsReceipt(content: contentOrder);
      if (apiResultOder.isFailure) {
        emit(GoodsReceiptFailure(
            message: apiResultOder.getErrorMessage(),
            errorCode: apiResultOder.errorCode));
        return;
      }

      List<OrderResponse> orderList = apiResultOder.data;

      emit(GoodsReceiptSuccess(
        date: event.date,
        orderList: orderList,
      ));
    } catch (e) {
      emit(const GoodsReceiptFailure(message: strings.messError));
    }
  }

  Future<void> _mapSearchToState(GoodsReceiptSearch event, emit) async {
    try {
      final currentState = state;
      if (currentState is GoodsReceiptSuccess) {
        emit(GoodsReceiptLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = await _getContentOrder(
            userInfo: userInfo,
            dateEvent: currentState.date,
            orderNo: event.orderNo);
        final apiResultDetail =
            await _goodsReceiptRepo.getGoodsReceiptDetail(content: content);
        if (apiResultDetail.isFailure) {
          emit(GoodsReceiptFailure(
              message: apiResultDetail.getErrorMessage(),
              errorCode: apiResultDetail.errorCode));
          return;
        }
        GoodsReceiptResponse goodsReceipt = apiResultDetail.data;
        emit(currentState.copyWith(
            goodsReceipt: goodsReceipt,
            orderNo: event.orderNo,
            isLoading: false));
      }
    } catch (e) {
      emit(const GoodsReceiptFailure(message: strings.messError));
    }
  }

  Future<void> _mapPickDateToState(GoodsReceiptPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is GoodsReceiptSuccess) {
        emit(GoodsReceiptLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final contentOrder = await _getContentOrder(
            userInfo: userInfo,
            dateEvent: event.date,
            orderNo: event.orderNo ?? '');
        final apiResultOder =
            await _goodsReceiptRepo.getGoodsReceipt(content: contentOrder);
        if (apiResultOder.isFailure) {
          emit(GoodsReceiptFailure(
              message: apiResultOder.getErrorMessage(),
              errorCode: apiResultOder.errorCode));
          return;
        }

        List<OrderResponse> orderList = apiResultOder.data;

        emit(currentState.copyWith(
            orderList: orderList,
            date: event.date,
            orderNo: '',
            goodsReceipt: null));
      }
    } catch (e) {
      emit(const GoodsReceiptFailure(message: strings.messError));
    }
  }

  Future<void> _mapPickOrderNoToState(
      GoodsReceiptPickOrderNo event, emit) async {
    try {
      final currentState = state;
      if (currentState is GoodsReceiptSuccess) {
        emit(GoodsReceiptLoading());
        emit(currentState.copyWith(
          orderNo: event.orderNo,
        ));
      }
    } catch (e) {
      emit(const GoodsReceiptFailure(message: strings.messError));
    }
  }

  Future<OrderInboundPhotoRequest> _getContentOrder(
      {required DateTime dateEvent,
      required String orderNo,
      required UserInfo userInfo}) async {
    final date = DateFormat(constants.formatMMddyyyy).format(dateEvent);

    final dcCode = userInfo.defaultCenter ?? '';
    final contactCode = userInfo.defaultClient ?? '';
    final companyId = userInfo.subsidiaryId ?? '';
    final content = OrderInboundPhotoRequest(
        orderNo: orderNo,
        orderType: '',
        etaf: date,
        etat: date,
        aignedStaff: '',
        contactCode: contactCode,
        dcCode: dcCode,
        companyId: companyId);
    return content;
  }
}
