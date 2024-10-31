part of 'relocation_bloc.dart';

abstract class RelocationState extends Equatable {
  const RelocationState();

  @override
  List<Object?> get props => [];
}

class RelocationInitial extends RelocationState {}

class RelocationLoading extends RelocationState {}

class RelocationSuccess extends RelocationState {
  final bool? saveSuccess;
  final DateTime date;
  final List<RelocationResult> relocationList;
  final int quantity;
  final bool isPagingLoading;
  const RelocationSuccess({
    required this.date,
    required this.relocationList,
    this.saveSuccess,
    required this.quantity,
    required this.isPagingLoading,
  });
  @override
  List<Object?> get props =>
      [date, relocationList, saveSuccess, quantity, isPagingLoading];

  RelocationSuccess copyWith(
      {bool? saveSuccess,
      DateTime? date,
      List<RelocationResult>? relocationList,
      int? quantity,
      bool? isPagingLoading}) {
    return RelocationSuccess(
      saveSuccess: saveSuccess ?? this.saveSuccess,
      date: date ?? this.date,
      relocationList: relocationList ?? this.relocationList,
      quantity: quantity ?? this.quantity,
      isPagingLoading: isPagingLoading ?? this.isPagingLoading,
    );
  }
}

class RelocationFailure extends RelocationState {
  final String message;
  final int? errorCode;
  const RelocationFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
