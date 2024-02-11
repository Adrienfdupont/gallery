class PictureData {
  final String id;
  final Map<String, dynamic> urls;

  const PictureData({required this.id, required this.urls});

  factory PictureData.fromJson(Map<String, dynamic> json) {
    return PictureData(
      id: json['id'] as String,
      urls: json['urls'] as Map<String, dynamic>,
    );
  }

  String get regularUrl => urls['regular'];
}
