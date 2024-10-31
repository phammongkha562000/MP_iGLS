class UploadDocumentEntryRequest {
  final String fileName;
  final String? docRefType;
  final String? refNoType;
  final String? refNoValue;
  final String userId;
  final String stringData;

  UploadDocumentEntryRequest({
    required this.fileName,
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
    required this.userId,
    required this.stringData,
  });

  Map<String, dynamic> toMap() {
    return {
      'FileName': fileName,
      'DocRefType': docRefType,
      'RefNoType': refNoType,
      'RefNoValue': refNoValue,
      'UserId': userId,
      'StringData': stringData,
    };
  }

  factory UploadDocumentEntryRequest.fromMap(Map<String, dynamic> map) {
    return UploadDocumentEntryRequest(
      fileName: map['FileName'] ?? '',
      docRefType: map['DocRefType'] ?? '',
      refNoType: map['RefNoType'] ?? '',
      refNoValue: map['RefNoValue'] ?? '',
      userId: map['UserId'] ?? '',
      stringData: map['StringData'] ?? '',
    );
  }
}
