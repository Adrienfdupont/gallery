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
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isFetching = false;
  String selectedFilter = 'country';
  final TextEditingController _textFieldController = TextEditingController();
  final List<PictureData> _fetchedPictures = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    controller.addListener(() async {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        _fetchedPictures.addAll(await _fetchPictureData());
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<PictureData>> _fetchPictureData([String? query]) async {
    String baseUrl = "https://api.unsplash.com/photos/";
    String clientId = "Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk";
    String commonParams = "client_id=$clientId&page=$page&per_page=50";
    
    String url;

    if (query != null && query.isNotEmpty) {
      baseUrl = "https://api.unsplash.com/search/photos/";
      url = "$baseUrl?$commonParams&query=$query";
    } else {
      url = "$baseUrl?$commonParams";
    }

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      page++;
      List<dynamic> data;

      if (query != null && query.isNotEmpty) {
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
              onPressed: () {
                debugPrint("Search button clicked");
                // print query
                print(_textFieldController.text);
                if (isFetching) {
                  print("Fetch operation is already in progress.");
                  return;
                }
                print("Starting fetch operation...");
                setState(() {
                  page = 1;
                  _fetchedPictures.clear();
                  isFetching = true;
                });
                _fetchPictureData(_textFieldController.text).then((newPictures) {
                  setState(() {
                    _fetchedPictures.addAll(newPictures);
                    isFetching = false;
                  });
                  print("Fetch operation completed.");
                }).catchError((error) {
                  setState(() {
                    isFetching = false;
                  });
                  print("Fetch operation failed: $error");
                });
              },
              icon: const Icon(Icons.search, color: Colors.white),
            )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _fetchPictureData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<PictureData> pictures = snapshot.requireData;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  controller: controller,
                  itemCount: pictures.length,
                  itemBuilder: (context, index) {
                    final picture = pictures[index];
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
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("${snapshot.error}",
                        style: const TextStyle(color: Colors.white)));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

}
