import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gallery/data_objects/picture_data.dart';

import 'dart:async';
import 'dart:convert';

import 'picture.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPictureData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<PictureData> pictures = snapshot.requireData;
          return ListView.builder(
            itemCount: pictures.length,
            itemBuilder: (context, index) {
              return Picture(picture: pictures[index]);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<PictureData>> _fetchPictureData() async {
    final pictures = await rootBundle.loadString('assets/pictures.json');
    final parsed = (jsonDecode(pictures) as List).cast<Map<String, dynamic>>();
    return parsed.map<PictureData>((json) => PictureData.fromJson(json)).toList();
  }
}
