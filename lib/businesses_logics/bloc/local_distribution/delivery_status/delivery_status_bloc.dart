import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';

import 'package:igls_new/presentations/common/strings.dart' as strings;

import '../../../../data/models/models.dart';
import '../../../../data/repository/repository.dart';
import '../../general/general_bloc.dart';
part 'delivery_status_event.dart';
part 'delivery_status_state.dart';

class DeliveryStatusBloc
    extends Bloc<DeliveryStatusEvent, DeliveryStatusState> {
  final _deliveryStatusRepo = getIt<DeliveryStatusRepository>();

  static final _userProfileRepo = getIt<UserProfileRepository>();

  DeliveryStatusBloc() : super(DeliveryStatusInitial()) {
    on<DeliveryStatusViewLoaded>(_mapViewLoadedToState);
    on<DeliveryStatusChangeContact>(_mapChangeContactToState);
  }
  void _mapViewLoadedToState(DeliveryStatusViewLoaded event, emit) async {
    emit(DeliveryStatusLoading());
    try {
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      List<ContactLocal> contactList = [
        ContactLocal(contactCode: '', contactName: '5059'.tr())
      ];
      List<ContactLocal> contactLocalList = event.generalBloc.listContactLocal;

      List<DcLocal> dcLocalList = event.generalBloc.listDC;
      if (dcLocalList == [] ||
          dcLocalList.isEmpty ||
          contactLocalList == [] ||
          contactLocalList.isEmpty) {
        final apiResult = await _userProfileRepo.getLocal(
            userId: event.generalBloc.generalUserInfo?.userId ?? '',
            subsidiaryId: userInfo.subsidiaryId!);
        if (apiResult.isFailure) {
          emit(DeliveryStatusFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }
      contactList.addAll(contactLocalList);

      String contactCode = event.contactCode ?? userInfo.defaultClient ?? '';
      final apiResult = await _deliveryStatusRepo.getDeliveryStatus(
        contactCode: contactCode,
        dcCode: userInfo.defaultCenter ?? '',
        subsidiaryId: userInfo.subsidiaryId ?? '',
      );
      if (apiResult.isFailure) {
        emit(DeliveryStatusFailure(
            message: apiResult.getErrorMessage(),
            errorCode: apiResult.errorCode));
        return;
      }
      DeliveryStatusResponse apiDeliveryStatus = apiResult.data;

      emit(DeliveryStatusSuccess(
          contactList: contactList,
          contactCode: contactCode,
          deliveryStatus: apiDeliveryStatus));
    } catch (e) {
      emit(const DeliveryStatusFailure(message: strings.messError));
    }
  }

  Future<void> _mapChangeContactToState(
      DeliveryStatusChangeContact event, emit) async {
    try {
      final currentState = state;
      if (currentState is DeliveryStatusSuccess) {
        emit(DeliveryStatusLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final apiResult = await _deliveryStatusRepo.getDeliveryStatus(
          contactCode: event.contactCode ?? currentState.contactCode,
          dcCode: userInfo.defaultCenter ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '',
        );
        if (apiResult.isFailure) {
          emit(DeliveryStatusFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        DeliveryStatusResponse apiDeliveryStatus = apiResult.data;
        emit(currentState.copyWith(
            contactCode: event.contactCode, deliveryStatus: apiDeliveryStatus));
      }
    } catch (e) {
      emit(const DeliveryStatusFailure(message: strings.messError));
    }
  }
}
