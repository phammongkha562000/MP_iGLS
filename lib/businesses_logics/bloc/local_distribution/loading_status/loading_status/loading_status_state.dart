part of 'loading_status_bloc.dart';

abstract class LoadingStatusState extends Equatable {
  const LoadingStatusState();

  @override
  List<Object?> get props => [];
}

class LoadingStatusInitial extends LoadingStatusState {}

class LoadingStatusLoading extends LoadingStatusState {}

class LoadingStatusSuccess extends LoadingStatusState {
  final DateTime dateTime;
  final List<LoadingStatusResponse> loadingStatusList;
  const LoadingStatusSuccess(
      {required this.loadingStatusList, required this.dateTime});
  @override
  List<Object?> get props => [loadingStatusList, dateTime];

  LoadingStatusSuccess copyWith({
    DateTime? dateTime,
    List<LoadingStatusResponse>? loadingStatusList,
  }) {
    return LoadingStatusSuccess(
      dateTime: dateTime ?? this.dateTime,
      loadingStatusList: loadingStatusList ?? this.loadingStatusList,
    );
  }
}

class LoadingStatusFailure extends LoadingStatusState {
  final String message;
  final int? errorCode;
  const LoadingStatusFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
