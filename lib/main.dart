import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: VegasApp()));
}

class VegasApp extends StatefulWidget {
  const VegasApp({super.key});

  @override
  VegasAppState createState() => VegasAppState();
}

class VegasAppState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Example of audio player and TTS',
      home: HomePage(),

    );
  }
}
