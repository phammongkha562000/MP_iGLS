class ContactResponse {
  ContactResponse({
    this.othersValue,
    this.valueCode,
  });

  String? othersValue;
  String? valueCode;

  factory ContactResponse.fromMap(Map<String, dynamic> json) => ContactResponse(
        othersValue: json["OthersValue"],
        valueCode: json["ValueCode"],
      );
}
