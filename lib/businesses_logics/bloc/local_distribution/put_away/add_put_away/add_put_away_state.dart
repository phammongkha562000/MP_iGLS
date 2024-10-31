part of 'add_put_away_bloc.dart';

class AddPutAwayState extends Equatable {
  const AddPutAwayState();

  @override
  List<Object?> get props => [];
}

class AddPutAwayInitial extends AddPutAwayState {}

class AddPutAwayLoading extends AddPutAwayState {}

class AddPutAwaySuccess extends AddPutAwayState {
  final OrderItem orderItem;

  const AddPutAwaySuccess({required this.orderItem});
  @override
  List<Object> get props => [orderItem];
}

class AddPutAwayFailure extends AddPutAwayState {
  final int? errorCode;
  final String message;
  const AddPutAwayFailure({
    this.errorCode,
    required this.message,
  });
  @override
  List<Object?> get props => [errorCode, message];
}

class AddPutAwaySaveSuccess extends AddPutAwayState {
  final OrderItem orderItem;

  const AddPutAwaySaveSuccess({required this.orderItem});
  @override
  List<Object?> get props => [orderItem];
}
