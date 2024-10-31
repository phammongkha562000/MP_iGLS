part of 'salary_file_bloc.dart';

abstract class SalaryFileEvent extends Equatable {
  const SalaryFileEvent();

  @override
  List<Object?> get props => [];
}

class SalaryFileLoaded extends SalaryFileEvent {
  final String fileLocation;
  const SalaryFileLoaded({
    required this.fileLocation,
  });
  @override
  List<Object?> get props => [fileLocation];
}
