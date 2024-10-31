class LoadingStatusDetailRequest {
  final String tripNo;
  final String equipmentCode;
  final String etpt;
  final String etpf;
  final String dcCode;

  LoadingStatusDetailRequest({
    required this.tripNo,
    required this.equipmentCode,
    required this.etpt,
    required this.etpf,
    required this.dcCode,
  });

  Map<String, dynamic> toJson() => {
        "TripNo": tripNo,
        "EquipmentCode": equipmentCode,
        "ETPT": etpt,
        "ETPF": etpf,
        "DCCode": dcCode,
      };
}
