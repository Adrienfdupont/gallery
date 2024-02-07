import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gallery/data_objects/picture_data.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'picture.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        _fetchPictureData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
  }

  Future<List<PictureData>> _fetchPictureData() async {
    final response = await http.get(Uri.parse(
        "https://api.unsplash.com/photos/?client_id=Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk&page=1&per_page=$page"));
    if (response.statusCode == 200) {
      page++;
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PictureData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pictures');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPictureData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<PictureData> pictures = snapshot.requireData;
          return ListView.builder(
            controller: controller,
            itemCount: pictures.length + 1,
            itemBuilder: (context, index) {
              if (index < pictures.length) {
                return Picture(picture: pictures[index]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }



}
