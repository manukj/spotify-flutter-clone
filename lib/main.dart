import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/di/injection_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spotify Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialBinding: DependencyInjection(),
      home: const Placeholder(), // Replace with your initial route/page
    );
  }
}
