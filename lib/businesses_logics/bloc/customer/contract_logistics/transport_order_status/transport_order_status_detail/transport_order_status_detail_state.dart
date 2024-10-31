part of 'transport_order_status_detail_bloc.dart';

sealed class CustomerTOSDetailState extends Equatable {
  const CustomerTOSDetailState();

  @override
  List<Object?> get props => [];
}

final class CustomerTOSDetailInitial extends CustomerTOSDetailState {}

final class CustomerTOSDetailLoading extends CustomerTOSDetailState {}

final class CustomerTOSDetailSuccess extends CustomerTOSDetailState {
  final CustomerTOSDetailRes detail;
  final CustomerNotifyOrderRes notifyOrder;
  final List<GetStdCodeRes> lstStdNotify;

  const CustomerTOSDetailSuccess(
      {required this.detail,
      required this.notifyOrder,
      required this.lstStdNotify});
  @override
  List<Object?> get props => [detail, notifyOrder, lstStdNotify];
}

final class CustomerTOSDetailFailure extends CustomerTOSDetailState {
  final String message;
  final int? errorCode;

  const CustomerTOSDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
final class CustomerTOSDetailSaveNotifySuccess extends CustomerTOSDetailState {}
