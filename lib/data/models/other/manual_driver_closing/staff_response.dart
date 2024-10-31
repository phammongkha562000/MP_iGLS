class Staff {
  String? staffUserId;
  String? staffName;
  Staff({
    this.staffUserId,
    this.staffName,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      staffUserId:
          map['StaffUserId'] != null ? map['StaffUserId'] as String : null,
      staffName: map['StaffName'] != null ? map['StaffName'] as String : null,
    );
  }
}
