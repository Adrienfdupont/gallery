import 'package:flutter/material.dart';
import 'package:gallery/data_objects/picture_data.dart';

class Picture extends StatelessWidget {
  final PictureData picture;
  const Picture({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    return Image.network(picture.url);
  }
}