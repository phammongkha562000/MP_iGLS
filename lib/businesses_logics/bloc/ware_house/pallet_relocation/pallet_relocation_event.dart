part of 'pallet_relocation_bloc.dart';

abstract class PalletRelocationEvent extends Equatable {
  const PalletRelocationEvent();

  @override
  List<Object?> get props => [];
}

class PalletRelocationSearch extends PalletRelocationEvent {
  final String grNo;
  final GeneralBloc generalBloc;
  const PalletRelocationSearch({required this.grNo, required this.generalBloc});
  @override
  List<Object> get props => [grNo, generalBloc];
}

class PalletRelocationSave extends PalletRelocationEvent {
  final String locCode;
  final GeneralBloc generalBloc;
  const PalletRelocationSave(
      {required this.locCode, required this.generalBloc});
  @override
  List<Object> get props => [locCode, generalBloc];
}
