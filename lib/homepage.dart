import 'package:flutter/material.dart';
import 'package:gallery/data_objects/picture_data.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'picture.dart';

class Homepage extends StatefulWidget {

  final String title;

  const Homepage({super.key, required this.title});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final controller = ScrollController();
  int page = 1;
  bool first_load = false;
  List<PictureData> pictures = [];

  @override
  void initState() {
    super.initState();

    controller.addListener(() async {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        pictures.addAll(await _fetchPictureData());
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<PictureData>> _fetchPictureData() async {
    final response = await http.get(Uri.parse(
        "https://api.unsplash.com/photos/?client_id=Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk&page=$page&per_page=30"));
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
          pictures.addAll(snapshot.requireData);
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
