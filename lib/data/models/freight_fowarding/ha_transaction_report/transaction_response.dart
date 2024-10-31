class TransactionReportResponse {
  List<GetTransactionDetail>? getTransactionDetail;
  GetTransactionDetails? getTransactionDetails;

  TransactionReportResponse({
    this.getTransactionDetail,
    this.getTransactionDetails,
  });

  factory TransactionReportResponse.fromJson(Map<String, dynamic> json) =>
      TransactionReportResponse(
        getTransactionDetail: json["GetTransactionDetail"] == null
            ? []
            : List<GetTransactionDetail>.from(json["GetTransactionDetail"]!
                .map((x) => GetTransactionDetail.fromJson(x))),
        getTransactionDetails: json["GetTransactionDetails"] == null
            ? null
            : GetTransactionDetails.fromJson(json["GetTransactionDetails"]),
      );
}

class GetTransactionDetail {
  double? balance;
  String? docNo;
  String? groupTypeDesc;
  double? inAmount;
  String? lacVietCode;
  String? memo;
  double? outAmount;
  String? refDocNo;
  String? staffId;
  String? staffName;
  String? transactionDate;
  String? transactionTypeDesc;

  GetTransactionDetail({
    this.balance,
    this.docNo,
    this.groupTypeDesc,
    this.inAmount,
    this.lacVietCode,
    this.memo,
    this.outAmount,
    this.refDocNo,
    this.staffId,
    this.staffName,
    this.transactionDate,
    this.transactionTypeDesc,
  });

  factory GetTransactionDetail.fromJson(Map<String, dynamic> json) =>
      GetTransactionDetail(
        balance: json["Balance"]?.toDouble(),
        docNo: json["DocNo"],
        groupTypeDesc: json["GroupTypeDesc"],
        inAmount: json["InAmount"]?.toDouble(),
        lacVietCode: json["LacVietCode"],
        memo: json["Memo"],
        outAmount: json["OutAmount"]?.toDouble(),
        refDocNo: json["RefDocNo"],
        staffId: json["StaffID"],
        staffName: json["StaffName"],
        transactionDate: json["TransactionDate"],
        transactionTypeDesc: json["TransactionTypeDesc"],
      );
}

class GetTransactionDetails {
  double? closeBalance;
  double? openBalance;

  GetTransactionDetails({
    this.closeBalance,
    this.openBalance,
  });

  factory GetTransactionDetails.fromJson(Map<String, dynamic> json) =>
      GetTransactionDetails(
        closeBalance: json["CloseBalance"],
        openBalance: json["OpenBalance"],
      );
}
