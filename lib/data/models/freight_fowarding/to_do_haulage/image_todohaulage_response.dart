class ImageTodoHaulageResponse {
  ImageTodoHaulageResponse({
    required this.createDate,
    required this.createUser,
    required this.docNo,
    required this.docRefType,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.fileType,
    required this.refNoType,
    required this.refNoValue,
    this.updateDate,
    this.updateUser,
  });

  String? createDate;
  String? createUser;
  int? docNo;
  String? docRefType;
  String? fileName;
  String? filePath;
  int? fileSize;
  String? fileType;
  String? refNoType;
  String? refNoValue;
  dynamic updateDate;
  dynamic updateUser;

  ImageTodoHaulageResponse copyWith({
    String? createDate,
    String? createUser,
    int? docNo,
    String? docRefType,
    String? fileName,
    String? filePath,
    int? fileSize,
    String? fileType,
    String? refNoType,
    String? refNoValue,
    dynamic updateDate,
    dynamic updateUser,
  }) =>
      ImageTodoHaulageResponse(
        createDate: createDate ?? this.createDate,
        createUser: createUser ?? this.createUser,
        docNo: docNo ?? this.docNo,
        docRefType: docRefType ?? this.docRefType,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        fileSize: fileSize ?? this.fileSize,
        fileType: fileType ?? this.fileType,
        refNoType: refNoType ?? this.refNoType,
        refNoValue: refNoValue ?? this.refNoValue,
        updateDate: updateDate ?? this.updateDate,
        updateUser: updateUser ?? this.updateUser,
      );

  factory ImageTodoHaulageResponse.fromJson(Map<String, dynamic> json) =>
      ImageTodoHaulageResponse(
        createDate: json["CreateDate"],
        createUser: json["CreateUser"],
        docNo: json["DocNo"],
        docRefType: json["DocRefType"],
        fileName: json["FileName"],
        filePath: json["FilePath"],
        fileSize: json["FileSize"],
        fileType: json["FileType"],
        refNoType: json["RefNoType"],
        refNoValue: json["RefNoValue"],
        updateDate: json["UpdateDate"],
        updateUser: json["UpdateUser"],
      );
}
