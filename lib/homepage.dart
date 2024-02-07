import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gallery/data_objects/picture_data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'picture.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedFilter = 'country';
  final TextEditingController _textFieldController = TextEditingController();
  // var filters = [{'label': 'Pays', 'value': 'country'}, {'label': 'Photographe', 'value': 'photograph'}];
  Future<List<PictureData>>? _fetchedPictures;

  @override
  void initState() {
    super.initState();
    _fetchedPictures = _fetchPictureData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     DropdownMenu<String>(
        //       dropdownMenuEntries: filters
        //           .map((Map<String, String> entry) => DropdownMenuEntry<String>(
        //                 value: entry['value']!,
        //                 label: entry['label']!,
        //               ))
        //           .toList(),
        //       initialSelection: selectedFilter,
        //       onSelected: (String? value) {
        //         setState(() {
        //           selectedFilter = value!;
        //         });
        //       },
        //       inputDecorationTheme: const InputDecorationTheme(
        //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
        //         border: InputBorder.none,
        //       ),
        //       textStyle: const TextStyle(color: Colors.white),
        //       trailingIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        //     ),
        //   ],
        // ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0xff33394f),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Recherche par mot-clé',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white12),
                  ),
                  style: const TextStyle(color: Colors.white),
                  controller: _textFieldController,
                ),
              ),
              IconButton(onPressed: () {
                setState(() {
                  _fetchedPictures = _fetchPictureData(_textFieldController.text);
                });
              }, icon: const Icon(Icons.search, color: Colors.white))
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _fetchedPictures,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint("data");
                final List<PictureData> pictures = snapshot.requireData;
                return ListView.builder(
                  itemCount: pictures.length,
                  itemBuilder: (context, index) {
                    return Picture(picture: pictures[index]);
                  },
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}", style: const TextStyle(color: Colors.white)));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Future<List<PictureData>> _fetchPictureData([query]) async {
    const apiKey = 'Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk';

    String url = 'https://api.unsplash.com/photos/?client_id=$apiKey';
    if (query != null) {
      url = 'https://api.unsplash.com/search/photos?client_id=$apiKey&query=$query';
    }

    final response = await http.get(Uri.parse(
        url));
    if (response.statusCode == 200) {
      List<dynamic> data;

      if (query != null) {
        data = json.decode(response.body)['results'];
      } else {
        data = json.decode(response.body);
      }

      return data.map((json) => PictureData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pictures');
    }
  }
}
