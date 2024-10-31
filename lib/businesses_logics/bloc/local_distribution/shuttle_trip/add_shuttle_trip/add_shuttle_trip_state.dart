part of 'add_shuttle_trip_bloc.dart';

abstract class AddShuttleTripState extends Equatable {
  const AddShuttleTripState();

  @override
  List<Object?> get props => [];
}

class AddShuttleTripInitial extends AddShuttleTripState {}

class AddShuttleTripLoading extends AddShuttleTripState {}

class AddShuttleTripSuccess extends AddShuttleTripState {
  final List<CompanyResponse> companyList;
  final List<StdCode> listStd;
  final List<StdCode>? listStdFreq;
  final bool? isSuccess;
  final ShuttleTripsResponse? shuttleTrip;
  final List<CompanyFreqResponse> companyFreqFrom;
  final List<CompanyFreqResponse> companyFreqTo;
  final DateTime? expectedTime;
  final String equipmentCode;
  const AddShuttleTripSuccess(
      {required this.companyList,
      required this.listStd,
      this.isSuccess,
      this.shuttleTrip,
      this.expectedTime,
      this.listStdFreq,
      required this.companyFreqFrom,
      required this.companyFreqTo,
      required this.equipmentCode});
  @override
  List<Object?> get props => [
        companyList,
        listStd,
        isSuccess,
        shuttleTrip,
        companyFreqFrom,
        companyFreqTo,
        expectedTime,
        listStdFreq,
        equipmentCode
      ];

  AddShuttleTripSuccess copyWith(
      {List<CompanyResponse>? companyList,
      List<StdCode>? listStd,
      List<StdCode>? listStdFreq,
      bool? isSuccess,
      ShuttleTripsResponse? shuttleTrip,
      DateTime? expectedTime,
      List<CompanyFreqResponse>? companyFreqFrom,
      List<CompanyFreqResponse>? companyFreqTo,
      String? equipmentCode}) {
    return AddShuttleTripSuccess(
        companyList: companyList ?? this.companyList,
        listStd: listStd ?? this.listStd,
        listStdFreq: listStdFreq ?? this.listStdFreq,
        isSuccess: isSuccess ?? this.isSuccess,
        shuttleTrip: shuttleTrip ?? this.shuttleTrip,
        companyFreqFrom: companyFreqFrom ?? this.companyFreqFrom,
        companyFreqTo: companyFreqTo ?? this.companyFreqTo,
        expectedTime: expectedTime ?? this.expectedTime,
        equipmentCode: equipmentCode ?? this.equipmentCode);
  }
}

class AddShuttleTripFailure extends AddShuttleTripState {
  final String message;
  final int? errorCode;
  const AddShuttleTripFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
