import 'package:flutter/material.dart';
import 'package:gallery/data_objects/picture_data.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'favorites_util.dart';
import 'picture.dart';
import 'full_screen_image_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = ScrollController();
  int page = 1;
  String? query;

  String selectedFilter = 'country';
  final TextEditingController _textFieldController = TextEditingController();
  // var filters = [{'label': 'Pays', 'value': 'country'}, {'label': 'Photographe', 'value': 'photograph'}];
  List<PictureData> _fetchedPictures = [];


  @override
  void initState() {
    super.initState();

    controller.addListener(() async {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        setState(() {});
      }
    });


  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  // fetch images from the API
  Future<List<PictureData>> _fetchPictureData() async {

    print('fetching page $page, query: $query');

    const apiKey = 'Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk';

    String url = 'https://api.unsplash.com/photos/?client_id=$apiKey&page=$page&per_page=50';
    if (query != null) {
      url =
      'https://api.unsplash.com/search/photos?client_id=$apiKey&query=$query&page=$page&per_page=50';
    }

    //print(url);

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      page++;
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
              IconButton(
                  onPressed: () async {
                    page = 1;
                    query = _textFieldController.text == '' ? null : _textFieldController.text;
                    _fetchedPictures = await _fetchPictureData();
                    setState(() {});
                  },
                  icon: const Icon(Icons.search, color: Colors.white))
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _fetchPictureData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _fetchedPictures.addAll(snapshot.requireData);
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  controller: controller,
                  itemCount: _fetchedPictures.length +1,
                  itemBuilder: (context, index) {
                    if (index < _fetchedPictures.length) {
                      final picture = _fetchedPictures[index];
                      bool isFav = FavoritesUtil.isFavorite(picture.id) ?? false;
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImagePage(imageUrl: picture.regularUrl),
                          ));
                        },
                        child: Stack(
                          children: [
                            Image.network(picture.regularUrl, fit: BoxFit.cover),
                            Positioned(
                              top: 1,
                              left: 2,
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await FavoritesUtil.setFavorite(
                                      picture.id, !isFav);
                                  setState(() {
                                    isFav = !isFav;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
