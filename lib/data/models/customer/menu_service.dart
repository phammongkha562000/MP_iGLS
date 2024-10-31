class MenuService {
  MenuService({
    required this.assetName,
    required this.assetPackage,
    required this.title,
    required this.caption,
    this.isFavorite = false,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName;
}
