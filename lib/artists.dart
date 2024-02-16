import 'package:flutter/material.dart';

class Artists extends StatelessWidget {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff24293d),
      child: const Center(
        child: Text(
          'Artistes',
          style: TextStyle(
            color: Color(0xfffea500),
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
