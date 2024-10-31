part of 'inbound_photo_bloc.dart';

abstract class InboundPhotoState extends Equatable {
  const InboundPhotoState();

  @override
  List<Object?> get props => [];
}

class InboundPhotoInitial extends InboundPhotoState {}

class InboundPhotoLoading extends InboundPhotoState {}

class InboundPhotoSuccess extends InboundPhotoState {
  final DateTime date;
  final bool isPagingLoading;
  final List<InboundPhotoResult> orderList;
  final int quantity;
  const InboundPhotoSuccess({
    required this.date,
    required this.orderList,
    required this.quantity,
    required this.isPagingLoading,
  });
  @override
  List<Object?> get props => [date, orderList, quantity, isPagingLoading];

  InboundPhotoSuccess copyWith(
      {DateTime? date,
      bool? isPagingLoading,
      List<InboundPhotoResult>? orderList,
      int? quantity}) {
    return InboundPhotoSuccess(
      date: date ?? this.date,
      orderList: orderList ?? this.orderList,
      quantity: quantity ?? this.quantity,
      isPagingLoading: isPagingLoading ?? this.isPagingLoading,
    );
  }
}

class InboundPhotoFailure extends InboundPhotoState {
  final String message;
  final int? errorCode;
  const InboundPhotoFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
