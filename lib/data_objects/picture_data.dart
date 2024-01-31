class PictureData  {
  final String url;

  const PictureData({required this.url});

  factory PictureData.fromJson(Map<String, dynamic> json) {
    return PictureData(url: json['urls']['regular']);
  }
}