part of 'inbound_order_detail_bloc.dart';

sealed class InboundOrderDetailState extends Equatable {
  const InboundOrderDetailState();

  @override
  List<Object> get props => [];
}

final class InboundOrderDetailInitial extends InboundOrderDetailState {}

final class IOSDetailLoadSuccess extends InboundOrderDetailState {
  final GetIOSDetailRes iosDetailRes;
  const IOSDetailLoadSuccess({required this.iosDetailRes});
  @override
  List<Object> get props => [];
}

final class IOSDetailLoadFail extends InboundOrderDetailState {
  final String message;
  const IOSDetailLoadFail({required this.message});
  @override
  List<Object> get props => [];
}

final class ShowLoadingState extends InboundOrderDetailState {}

final class HideLoadingState extends InboundOrderDetailState {}

final class DownloadFileSuccessState extends InboundOrderDetailState {}

final class DownloadFileFailState extends InboundOrderDetailState {}
