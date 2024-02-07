import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gallery/data_objects/picture_data.dart';

import 'package:http/http.dart' as http;

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
    var response = await http.get(Uri.parse("https://api.unsplash.com/photos/?client_id=Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk&page=1&per_page=30"));
    if (response.statusCode == 200) {
      final pictures = response.body;
      final parsed = (jsonDecode(pictures) as List).cast<Map<String, dynamic>>();
      return parsed.map<PictureData>((json) => PictureData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pictures');
    }

  }
}

