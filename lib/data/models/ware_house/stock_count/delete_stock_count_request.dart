class DeleteStockCountRequest {
  DeleteStockCountRequest({
    required this.id,
    required this.updateUser,
    required this.companyId,
  });

  final int id;
  final String updateUser;
  final String companyId;

  

  Map<String, dynamic> toJson() => {
        "id": id,
        "UpdateUser": updateUser,
        "CompanyId": companyId,
      };
}
