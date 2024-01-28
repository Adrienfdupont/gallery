import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gallery/picture.dart';

import 'dart:async';
import 'dart:convert';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPictures(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Picture> pictures = snapshot.data as List<Picture>;
          return ListView.builder(
            itemCount: pictures.length,
            itemBuilder: (context, index) {
              return Picture(picture: pictures[index]);
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<Picture>> _fetchPictures() async {
    final pictures = await rootBundle.loadString('assets/pictures.json');
    final parsed = (jsonDecode(pictures) as List).cast<Map<String, dynamic>>();
    return parsed.map<Picture>((json) => Picture.fromJson(json)).toList();
  }
}
