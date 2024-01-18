import 'package:flutter/material.dart';
import 'package:gallery/gallery.dart';

void main() => runApp(const CvMobileApp());

class CvMobileApp extends StatelessWidget {
  const CvMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Gallery(),
    );
  }
}
