import 'package:flutter/material.dart';
import 'package:gallery/data_objects/picture_data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'favorites_util.dart';
import 'picture.dart';
import 'full_screen_image_page.dart';

class Homepage extends StatefulWidget {
  final String title;

  const Homepage({Key? key, required this.title}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _textFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  List<PictureData> _pictures = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPictureData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      _page++;
      final List<PictureData> morePictures = await _fetchPictureData(query: _searchQuery);
      setState(() {
        _pictures.addAll(morePictures);
      });
    }
  }

  Future<List<PictureData>> _fetchPictureData({String query = ''}) async {
    const apiKey = 'Va7WM5ToNpyz8-4CWvZ7fkeV8sr_QMf0BH9NAJ8GCbk';
    String url = 'https://api.unsplash.com/photos/?client_id=$apiKey&page=$_page&per_page=30';

    if (query.isNotEmpty) {
      url = 'https://api.unsplash.com/search/photos?client_id=$apiKey&query=$query&page=$_page&per_page=30';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = query.isNotEmpty ? json.decode(response.body)['results'] : json.decode(response.body);
      return data.map((json) => PictureData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pictures');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xff33394f),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      hintText: 'Search by keyword',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _textFieldController.text;
                      _pictures.clear();
                      _page = 1;
                      _fetchPictureData(query: _searchQuery);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _pictures.length,
              itemBuilder: (context, index) {
                final picture = _pictures[index];
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
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await FavoritesUtil.setFavorite(picture.id, !isFav);
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
            ),
          ),
        ],
      ),
    );
  }
}

