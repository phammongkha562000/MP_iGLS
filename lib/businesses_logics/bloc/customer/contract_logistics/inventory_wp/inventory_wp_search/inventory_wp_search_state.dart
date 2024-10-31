part of 'inventory_wp_search_bloc.dart';

sealed class InventoryWpSearchState extends Equatable {
  const InventoryWpSearchState();

  @override
  List<Object?> get props => [];
}

final class InventoryWpSearchInitial extends InventoryWpSearchState {}

final class InventoryWpSearchLoading extends InventoryWpSearchState {}

final class InventoryWpSearchSuccess extends InventoryWpSearchState {
  final List<GetStdCodeRes> lstGrade;
  final List<GetStdCodeRes> lstItemStatus;
  final List<UserDCResult> lstDC;

  const InventoryWpSearchSuccess({
    required this.lstGrade,
    required this.lstItemStatus,
    required this.lstDC,
  });
  @override
  List<Object?> get props => [lstGrade, lstItemStatus, lstDC];
}

final class InventoryWpSearchFailure extends InventoryWpSearchState {
  final int? errorCode;
  final String message;

  const InventoryWpSearchFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
