class AnnouncementUpdateRequest {
  final int annId;
  final String agreedUser;
  final String comment;
  AnnouncementUpdateRequest({
    required this.annId,
    required this.agreedUser,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'AnnId': annId,
      'AgreedUser': agreedUser,
      'Comment': comment,
    };
  }
}
