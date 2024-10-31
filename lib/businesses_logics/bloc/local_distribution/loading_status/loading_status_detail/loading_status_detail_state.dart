part of 'loading_status_detail_bloc.dart';

abstract class LoadingStatusDetailState extends Equatable {
  const LoadingStatusDetailState();

  @override
  List<Object?> get props => [];
}

class LoadingStatusDetailInitial extends LoadingStatusDetailState {}

class LoadingStatusDetailLoading extends LoadingStatusDetailState {}

class LoadingStatusDetailSuccess extends LoadingStatusDetailState {
  final LoadingStatusResponse detail;
  final DateTime etp;
  const LoadingStatusDetailSuccess({
    required this.detail,
    required this.etp,
  });
  @override
  List<Object> get props => [detail, etp];

  LoadingStatusDetailSuccess copyWith(
      {LoadingStatusResponse? detail, DateTime? etp}) {
    return LoadingStatusDetailSuccess(
      detail: detail ?? this.detail,
      etp: etp ?? this.etp,
    );
  }
}

class LoadingStatusDetailFailure extends LoadingStatusDetailState {
  final String message;
  final int? errorCode;
  const LoadingStatusDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class LoadingStatusSaveSuccess extends LoadingStatusDetailState {}
