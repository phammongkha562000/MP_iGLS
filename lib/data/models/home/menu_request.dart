class MenuRequest {
  final String uid;
  final String systemId;
  final String subsidiaryId;
  MenuRequest({
    required this.uid,
    required this.systemId,
    required this.subsidiaryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'systemId': systemId,
      'subsidiaryId': subsidiaryId,
    };
  }
}
