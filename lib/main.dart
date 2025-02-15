import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/config/env_config.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/search/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  if (!EnvConfig.isValid) {
    throw Exception(
        'Environment variables are not properly configured. Please check your .env file.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spotify Flutter',
      theme: AppTheme.spotifyTheme,
      initialBinding: DependencyInjection(),
      home: const HomePage(),
    );
  }
}
