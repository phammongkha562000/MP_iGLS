class SiteTrailerSumaryRes {
  String? cYName;
  int? empty;
  int? loaded;
  int? total;

  SiteTrailerSumaryRes({this.cYName, this.empty, this.loaded, this.total});

  SiteTrailerSumaryRes.fromJson(Map<String, dynamic> json) {
    cYName = json['CYName'];
    empty = json['Empty'];
    loaded = json['Loaded'];
    total = json['Total'];
  }
}
