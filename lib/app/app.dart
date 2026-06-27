import 'package:apod/app/controller_binder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/screens/home.dart';

class Apod extends StatelessWidget {
  const Apod({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
