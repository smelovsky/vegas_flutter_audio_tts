import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegas_flutter_audio_tts/settings.dart';
import 'audio_player_and_tts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => exit(0)
          ),
        ],
        //backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Audio ans TTS example",
        ),
      ),

      body: AudioPlayerAndTtsPage(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SettingsPage();
            },
          );
        },
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
      ),


    );
  }
}