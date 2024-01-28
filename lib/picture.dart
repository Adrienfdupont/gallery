import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final String url;

  const Picture({required this.url});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(url: json['urls']['regular']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(url),
    );
  }
}
