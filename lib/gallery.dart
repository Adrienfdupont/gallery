import 'package:flutter/material.dart';
import 'package:gallery/artists.dart';
import 'package:gallery/favorites.dart';
import 'package:gallery/homepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff24293d),
          toolbarHeight: 0,
        ),
        backgroundColor: const Color(0xff24293d),
        body: IndexedStack(
          index: currentPageIndex,
          children: const [
            Homepage(),
            Favorites(),
            Artists(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xff33394f),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                gap: 8,
                color: const Color(0xfffea500),
                activeColor: const Color(0xff33394f),
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: const Duration(milliseconds: 200),
                tabBackgroundColor: const Color(0xfffea500),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Accueil',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Favoris',
                  ),
                  GButton(
                    icon: Icons.group,
                    text: 'Artistes',
                  ),
                ],
                selectedIndex: currentPageIndex,
                onTabChange: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
