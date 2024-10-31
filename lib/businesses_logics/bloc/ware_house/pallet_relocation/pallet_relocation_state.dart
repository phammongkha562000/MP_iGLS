part of 'pallet_relocation_bloc.dart';

abstract class PalletRelocationState extends Equatable {
  const PalletRelocationState();

  @override
  List<Object?> get props => [];
}

class PalletRelocationInitial extends PalletRelocationState {}

class PalletRelocationLoading extends PalletRelocationState {}

class PalletRelocationSuccess extends PalletRelocationState {
  final PalletRelocationResponse pallet;

  const PalletRelocationSuccess({required this.pallet});
  @override
  List<Object?> get props => [pallet];
}

class PalletRelocationFailure extends PalletRelocationState {
  final String message;
  final int? errorCode;
  const PalletRelocationFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class PalletRelocationSaveSuccess extends PalletRelocationState {
  final PalletRelocationResponse pallet;

  const PalletRelocationSaveSuccess({required this.pallet});
  @override
  List<Object?> get props => [pallet];
}
