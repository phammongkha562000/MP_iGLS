part of 'salary_file_bloc.dart';

abstract class SalaryFileState extends Equatable {
  const SalaryFileState();

  @override
  List<Object?> get props => [];
}

class SalaryFileInitial extends SalaryFileState {}

class SalaryFileLoading extends SalaryFileState {}

class SalaryFileSuccess extends SalaryFileState {
  final String fileLocation;
  const SalaryFileSuccess({
    required this.fileLocation,
  });
  @override
  List<Object?> get props => [fileLocation];
}

class SalaryFileFailure extends SalaryFileState {
  final String message;
  final String? errorCode;
  const SalaryFileFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
