class DocumentDTO {
  String? createDate;
  String? createUser;
  int? docNo;
  String? docRefType;
  String? fileName;
  String? filePath;
  String? fileType;
  String? refNoType;
  String? refNoValue;
  bool? isSelected;
  DocumentDTO(
    this.createDate,
    this.createUser,
    this.docNo,
    this.docRefType,
    this.fileName,
    this.filePath,
    this.fileType,
    this.refNoType,
    this.refNoValue,
    this.isSelected,
  );

  factory DocumentDTO.fromMap(Map<String, dynamic> map) {
    return DocumentDTO(
      map['CreateDate'],
      map['CreateUser'],
      map['DocNo']?.toInt(),
      map['DocRefType'],
      map['FileName'],
      map['FilePath'],
      map['FileType'],
      map['RefNoType'],
      map['RefNoValue'],
      map['IsSelected'],
    );
  }
}
