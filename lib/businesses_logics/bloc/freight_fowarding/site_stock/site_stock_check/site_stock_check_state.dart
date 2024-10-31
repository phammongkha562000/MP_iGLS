// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'site_stock_check_bloc.dart';

abstract class SiteStockCheckState extends Equatable {
  const SiteStockCheckState();

  @override
  List<Object?> get props => [];
}

class SiteStockCheckInitial extends SiteStockCheckState {}

class SiteStockCheckLoading extends SiteStockCheckState {}

// class SiteStockCheckSuccess extends SiteStockCheckState {
//   final CySiteResponse? cySite;
//   final List<CySiteResponse> cySiteList;
//   final List<EquipmentResponse> equipmentList;
//   final List<DcLocal> dcList;

//   const SiteStockCheckSuccess(
//       {required this.cySite,
//       required this.cySiteList,
//       required this.equipmentList,
//       required this.dcList});
//   @override
//   List<Object?> get props => [cySite, equipmentList, cySiteList, dcList];

//   SiteStockCheckSuccess copyWith({
//     CySiteResponse? cySite,
//     List<CySiteResponse>? cySiteList,
//     List<EquipmentResponse>? equipmentList,
//     List<DcLocal>? dcList,
//   }) {
//     return SiteStockCheckSuccess(
//       cySite: cySite ?? this.cySite,
//       cySiteList: cySiteList ?? this.cySiteList,
//       equipmentList: equipmentList ?? this.equipmentList,
//       dcList: dcList ?? this.dcList,
//     );
//   }
// }

class SiteStockCheckFailure extends SiteStockCheckState {
  final String message;
  final int? errorCode;
  const SiteStockCheckFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class SiteStockCheckGetCYSuccess extends SiteStockCheckState {
  final List<CySiteResponse> cySiteList;
  final CySiteResponse? cySite;

  const SiteStockCheckGetCYSuccess({required this.cySiteList, this.cySite});
  @override
  List<Object?> get props => [cySiteList, cySite];
}

class SiteStockCheckGetEquipmentSuccess extends SiteStockCheckState {
  final List<EquipmentResponse> equipmentList;

  const SiteStockCheckGetEquipmentSuccess({required this.equipmentList});
  @override
  List<Object?> get props => [identityHashCode(equipmentList)];
}

class SiteStockCheckGetCYFailure extends SiteStockCheckState {
  final String message;
  const SiteStockCheckGetCYFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

class SiteStockCheckGetEquipmentFailure extends SiteStockCheckState {
  final String message;
  const SiteStockCheckGetEquipmentFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

class SiteStockCheckSaveSuccess extends SiteStockCheckState {}
