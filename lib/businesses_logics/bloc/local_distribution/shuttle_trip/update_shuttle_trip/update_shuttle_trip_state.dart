part of 'update_shuttle_trip_bloc.dart';

abstract class UpdateShuttleTripState extends Equatable {
  const UpdateShuttleTripState();

  @override
  List<Object?> get props => [];
}

class UpdateShuttleTripInitial extends UpdateShuttleTripState {}

class UpdateShuttleTripLoading extends UpdateShuttleTripState {}

class UpdateShuttleTripSuccess extends UpdateShuttleTripState {
  final ShuttleTripsResponse shuttleTrip;
  final List<CompanyResponse> companyList;

  final List<CompanyFreqResponse> companyFreqFrom;
  final List<CompanyFreqResponse> companyFreqTo;
  final List<StdCode> listStd;
  final List<StdCode>? listStdFreq;
  final bool? isSuccess;
  final bool? isDelete;
  final DateTime dateTime;
  const UpdateShuttleTripSuccess(
      {required this.shuttleTrip,
      required this.companyList,
      required this.listStd,
      this.listStdFreq,
      required this.companyFreqFrom,
      required this.companyFreqTo,
      this.isSuccess,
      this.isDelete,
      required this.dateTime});
  @override
  List<Object?> get props => [
        listStdFreq,
        shuttleTrip,
        companyList,
        listStd,
        isSuccess,
        isDelete,
        companyFreqFrom,
        companyFreqTo,
        dateTime,
      ];

  UpdateShuttleTripSuccess copyWith(
      {ShuttleTripsResponse? shuttleTrip,
      List<CompanyResponse>? companyList,
      List<StdCode>? listStd,
      List<StdCode>? listStdFreq,
      bool? isSuccess,
      bool? isDelete,
      List<CompanyFreqResponse>? companyFreqFrom,
      List<CompanyFreqResponse>? companyFreqTo,
      DateTime? dateTime}) {
    return UpdateShuttleTripSuccess(
      shuttleTrip: shuttleTrip ?? this.shuttleTrip,
      companyList: companyList ?? this.companyList,
      listStd: listStd ?? this.listStd,
      listStdFreq: listStdFreq ?? this.listStdFreq,
      isSuccess: isSuccess ?? this.isSuccess,
      isDelete: isDelete ?? this.isDelete,
      companyFreqFrom: companyFreqFrom ?? this.companyFreqFrom,
      companyFreqTo: companyFreqTo ?? this.companyFreqTo,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class UpdateShuttleTripFailure extends UpdateShuttleTripState {
  final String message;
  final int? errorCode;
  const UpdateShuttleTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
