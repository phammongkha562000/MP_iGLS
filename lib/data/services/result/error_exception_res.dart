class ErrorExceptionRes {
  String? className;
  String? message;
  dynamic data;
  dynamic innerException;
  dynamic helpUrl;
  dynamic stackTraceString;
  dynamic remoteStackTraceString;
  int? remoteStackIndex;
  dynamic exceptionMethod;
  int? hResult;
  dynamic source;
  dynamic watsonBuckets;

  ErrorExceptionRes({
    this.className,
    this.message,
    this.data,
    this.innerException,
    this.helpUrl,
    this.stackTraceString,
    this.remoteStackTraceString,
    this.remoteStackIndex,
    this.exceptionMethod,
    this.hResult,
    this.source,
    this.watsonBuckets,
  });

  factory ErrorExceptionRes.fromJson(Map<String, dynamic> json) =>
      ErrorExceptionRes(
        className: json["ClassName"],
        message: json["Message"],
        data: json["Data"],
        innerException: json["InnerException"],
        helpUrl: json["HelpURL"],
        stackTraceString: json["StackTraceString"],
        remoteStackTraceString: json["RemoteStackTraceString"],
        remoteStackIndex: json["RemoteStackIndex"],
        exceptionMethod: json["ExceptionMethod"],
        hResult: json["HResult"],
        source: json["Source"],
        watsonBuckets: json["WatsonBuckets"],
      );
}
