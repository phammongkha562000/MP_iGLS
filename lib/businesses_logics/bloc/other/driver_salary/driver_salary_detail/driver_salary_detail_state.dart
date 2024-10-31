part of 'driver_salary_detail_bloc.dart';

abstract class DriverSalaryDetailState extends Equatable {
  const DriverSalaryDetailState();

  @override
  List<Object?> get props => [];
}

class DriverSalaryDetailInitial extends DriverSalaryDetailState {}

class DriverSalaryDetailLoading extends DriverSalaryDetailState {}

class DriverSalaryDetailSuccess extends DriverSalaryDetailState {
  final List<DriverSalaryPayload> listDriverSalary;
  final String url;
  const DriverSalaryDetailSuccess({
    required this.listDriverSalary,
    required this.url,
  });
  @override
  List<Object?> get props => [listDriverSalary, url];

  DriverSalaryDetailSuccess copyWith({
    List<DriverSalaryPayload>? listDriverSalary,
    String? url,
  }) {
    return DriverSalaryDetailSuccess(
      listDriverSalary: listDriverSalary ?? this.listDriverSalary,
      url: url ?? this.url,
    );
  }
}

class DriverSalaryDownFileSuccessfully extends DriverSalaryDetailState {
  final String fileLocation;
  final String fileType;
  const DriverSalaryDownFileSuccessfully({
    required this.fileLocation,
    required this.fileType,
  });
  @override
  List<Object?> get props => [fileLocation, fileType];
}

class DriverSalaryDetailFailure extends DriverSalaryDetailState {
  final String message;
  final int? errorCode;
  const DriverSalaryDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
