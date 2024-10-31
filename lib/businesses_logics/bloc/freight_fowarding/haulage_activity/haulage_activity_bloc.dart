import 'package:equatable/equatable.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import '../../../../data/repository/repository.dart';
import '../../../../data/services/services.dart';
import '../../general/general_bloc.dart';

part 'haulage_activity_event.dart';
part 'haulage_activity_state.dart';

class HaulageActivityBloc
    extends Bloc<HaulageActivityEvent, HaulageActivityState> {
  static final _userProfileRepo = getIt<UserProfileRepository>();

  HaulageActivityBloc() : super(HaulageActivityInitial()) {
    on<HaulageActivityViewLoaded>(_mapViewLoadedToState);
    on<HaulageActivityPressed>(_mapPressedToState);
  }
  Future<void> _mapViewLoadedToState(
      HaulageActivityViewLoaded event, emit) async {
    emit(HaulageActivityLoading());
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
          emit(HaulageActivityFailure(message: apiResult.getErrorMessage()));
          return;
        }
        LocalRespone response = apiResult.data;
        dcLocalList = response.dcLocal ?? [];
        contactLocalList = response.contactLocal ?? [];
        event.generalBloc.listDC = dcLocalList;
        event.generalBloc.listContactLocal = contactLocalList;
      }

      contactList = [...contactList, ...contactLocalList];

      emit(HaulageActivitySuccess(
        contactList: contactList,
      ));
    } catch (e) {
      emit(HaulageActivityFailure(message: e.toString()));
    }
  }

  Future<void> _mapPressedToState(HaulageActivityPressed event, emit) async {
    try {
      final currentState = state;
      if (currentState is HaulageActivitySuccess) {
        emit(HaulageActivityLoading());
        final sharedPref = await SharedPreferencesService.instance;

        final contactCode = event.contactCode == 'all'.tr()
            ? ''
            : currentState.contactList
                .where((element) => element.contactCode == event.contactCode)
                .single
                .contactCode;
        final userId = event.generalBloc.generalUserInfo?.userId ?? '';
        final hour = event.hour;
        emit(currentState.copyWith(
            url:
                '${sharedPref.serverWcf!}Webbrowser/HAHistory.html?ihr=$hour&icontact=$contactCode&iuserid=$userId'));
      }
    } catch (e) {
      emit(HaulageActivityFailure(message: e.toString()));
    }
  }
}
