part of 'barcode_tracking_bloc.dart';

sealed class BarcodeTrackingEvent extends Equatable {
  const BarcodeTrackingEvent();

  @override
  List<Object> get props => [];
}

class BarcodeTrackingSearch extends BarcodeTrackingEvent {
  final String grNo;
  final String subsidiaryId;

  const BarcodeTrackingSearch({required this.grNo, required this.subsidiaryId});
  @override
  List<Object> get props => [grNo, subsidiaryId];
}
