import 'package:flutter/material.dart';
import 'favorites_util.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  late Map<String, bool> _favorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = FavoritesUtil.getAllFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: const Color(0xff24293d),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _favorites.length,
        itemBuilder: (BuildContext context, int index) {
          String key = _favorites.keys.elementAt(index);
          bool isFav = _favorites[key] ?? false;
          if (isFav) {
            return Image.network("URL de votre image", fit: BoxFit.cover);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
