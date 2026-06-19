import 'package:flutter/material.dart';

import 'home.dart';

class Apod extends StatelessWidget {
  const Apod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
