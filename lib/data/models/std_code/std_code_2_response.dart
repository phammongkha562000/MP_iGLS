class StdCode2Response {
  String? code;
  String? codeDesc;
  String? codeGroup;
  dynamic codeVariant;
  bool? isUse;
  int? seqNo;
  int? tid;

  StdCode2Response({
    this.code,
    this.codeDesc,
    this.codeGroup,
    this.codeVariant,
    this.isUse,
    this.seqNo,
    this.tid,
  });

  factory StdCode2Response.fromJson(Map<String, dynamic> json) =>
      StdCode2Response(
        code: json["Code"],
        codeDesc: json["CodeDesc"],
        codeGroup: json["CodeGroup"],
        codeVariant: json["CodeVariant"],
        isUse: json["IsUse"],
        seqNo: json["SeqNo"],
        tid: json["Tid"],
      );
}
