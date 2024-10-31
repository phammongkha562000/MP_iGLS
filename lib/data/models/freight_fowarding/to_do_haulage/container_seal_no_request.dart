class ContainerAndSealNoRequest {
  final int wOTaskId;
  final String userId;
  final String cNTRNo;
  final String sealNo;
  ContainerAndSealNoRequest({
    required this.wOTaskId,
    required this.userId,
    required this.cNTRNo,
    required this.sealNo,
  });

  ContainerAndSealNoRequest copyWith({
    int? wOTaskId,
    String? userId,
    String? cNTRNo,
    String? sealNo,
  }) {
    return ContainerAndSealNoRequest(
      wOTaskId: wOTaskId ?? this.wOTaskId,
      userId: userId ?? this.userId,
      cNTRNo: cNTRNo ?? this.cNTRNo,
      sealNo: sealNo ?? this.sealNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'WOTaskId': wOTaskId,
      'UserId': userId,
      'CNTRNo': cNTRNo,
      'SealNo': sealNo,
    };
  }
}
