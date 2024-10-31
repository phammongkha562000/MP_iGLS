import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/todo_request.dart';
import 'package:igls_new/data/repository/local_distribution/to_do_local_distribution/to_do_repository.dart';
import 'package:igls_new/data/repository/user_profile/user_repository.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/result/api_response.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';

import '../../../../../data/models/models.dart';
import '../../../general/general_bloc.dart';

part 'add_todo_trip_event.dart';
part 'add_todo_trip_state.dart';

class AddTodoTripBloc extends Bloc<AddTodoTripEvent, AddTodoTripState> {
  final _userRepo = getIt<UserProfileRepository>();
  final _toDoTripRepo = getIt<ToDoTripRepository>();

  AddTodoTripBloc() : super(AddTodoTripInitial()) {
    on<AddTodoTripViewLoaded>(_mapViewLoadedToState);
    on<AddTodoTripSubmit>(_mapSubmitToState);
  }
  Future<void> _mapViewLoadedToState(AddTodoTripViewLoaded event, emit) async {
    emit(AddTodoTripLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

      final apiResultContact = await _userRepo.getContact(
          userId: event.generalBloc.generalUserInfo?.userId ?? '',
          subsidiaryId: userInfo.subsidiaryId ?? '');
      if (apiResultContact.isFailure) {
        emit(AddTodoTripFailure(
            message: apiResultContact.getErrorMessage(),
            errorCode: apiResultContact.errorCode));
        return;
      }
      List<ContactLocal> contactList = apiResultContact.data;
      final apiResultRaq = await _toDoTripRepo.getDriverContactUsedFreq(
          equipmentCode: sharedPref.equipmentNo!,
          dcCode: userInfo.defaultCenter ?? '',
          companyId: userInfo.subsidiaryId ?? '');
      if (apiResultRaq.isFailure) {
        emit(AddTodoTripFailure(
            message: apiResultRaq.getErrorMessage(),
            errorCode: apiResultRaq.errorCode));
        return;
      }
      List<ContactLocal> contactListRaq = apiResultRaq.data;
      emit(AddTodoTripSuccess(
          contactList: contactList, contactList2: contactListRaq));
    } catch (e) {
      emit(AddTodoTripFailure(message: e.toString()));
    }
  }

  Future<void> _mapSubmitToState(AddTodoTripSubmit event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final currentState = state;
      if (currentState is AddTodoTripSuccess) {
        emit(AddTodoTripLoading());
        UserInfo userInfo = event.generalBloc.generalUserInfo ?? UserInfo();

        final content = SimpleTripRequest(
            driverTripType: event.tripClassCode,
            tripMemo: event.memo!,
            contactCode: event.contactCode,
            equipmentCode: sharedPref.equipmentNo,
            driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
            driverDesc: sharedPref.userName,
            createUser: event.generalBloc.generalUserInfo?.userId ?? '',
            dCCode: userInfo.defaultCenter);
        final apiResultAdd = await _toDoTripRepo.getAddSimpleTripMyWork(
            content: content,
            contact: userInfo.defaultClient ?? '',
            subsidiaryId: userInfo.subsidiaryId ?? '');
        if (apiResultAdd.isFailure) {
          emit(AddTodoTripFailure(
              message: apiResultAdd.getErrorMessage(),
              errorCode: apiResultAdd.errorCode));
          return;
        }
        StatusResponse apiAdd = apiResultAdd.data;
        if (apiAdd.isSuccess != true) {
          emit(AddTodoTripFailure(message: apiAdd.message ?? ''));
          return;
        }
        final fromDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);

        final apiResult = await _toDoTripRepo.getListToDoTrips(
          content: TodoRequest(
              equipmentCode: '',
              driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
              etp: fromDate,
              companyId: userInfo.subsidiaryId ?? '',
              pageNumber: 0, //hardcode
              pageSize: 100), //hardcode
          /*   driverId: event.generalBloc.generalUserInfo?.empCode ?? '',
            fromDate: fromDate,
            subsidiaryId: userInfo.subsidiaryId ?? '',
            equipmentCode: sharedPref.equipmentNo ?? '' */
        );
        if (apiResult.isFailure) {
          emit(AddTodoTripFailure(
              message: apiResult.getErrorMessage(),
              errorCode: apiResult.errorCode));
          return;
        }
        ApiResponse apiRes = apiResult.data;
        TodoResponse todoRes = apiRes.payload;
        List<TodoResult> todoList = todoRes.results ?? [];
        final TodoResult simpleTrip = todoList
            .where((element) =>
                element.tripType == 'Simple' &&
                element.tripNo == apiAdd.valueReturn)
            .single;

        emit(currentState.copyWith(isSuccess: true, simpleTrip: simpleTrip));
      }
    } catch (e) {
      emit(AddTodoTripFailure(message: e.toString()));
    }
  }
}
