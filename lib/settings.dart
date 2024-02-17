import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vegas_flutter_audio_tts/proviiders/settings_notifier_provider.dart';

import 'audio_player_and_tts_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  double voiceVolume = 50;
  bool isVoiceMute = false;
  double voicePause = 3;

  double backgroundVolume = 50;
  bool isBackgroundMute = false;

  @override
  void initState() {

    voiceVolume = ref.read(settingsProviderVoiceVolume).voiceVolume.toDouble();
    isVoiceMute = ref.read(settingsProviderIsVoiceMute).isVoiceMute;
    voicePause = ref.read(settingsProviderVoicePause).voicePause.toDouble();

    backgroundVolume = ref.read(settingsProviderBackgroundVolume).backgroundVolume.toDouble();
    isBackgroundMute = ref.read(settingsProviderIsBackgroundMute).isBackgroundMute;

    print("backgroundVolume: ${ref.read(settingsProviderBackgroundVolume).backgroundVolume}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.yellow, Colors.green],
          ),
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(18))),
      child: Center(
        child: Column(

          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom:20, left:0, right:0),

              child: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
            ),

            Text("Background volume"),
            Row(
              children: [

                Expanded(
                  child: Slider(
                    value: backgroundVolume,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${backgroundVolume.round()}%",
                    onChanged: (double value) async {

                      setState(() {
                        backgroundVolume = value;
                        isBackgroundMute = false;
                      });

                      ref.refresh(settingsProviderBackgroundVolume).backgroundVolume = backgroundVolume.round();

                      final double background_volume = (isBackgroundMute) ? 0 : value/100;
                      await audioPlayer.setVolume( background_volume);

                    },
                  ),
                ),

                IconButton(
                  tooltip: "Mute",
                  icon: Icon((isBackgroundMute == true) ?
                  Icons.volume_off_outlined :
                  Icons.volume_up_outlined),
                  onPressed: () async {

                    setState(() {
                      isBackgroundMute = !isBackgroundMute;
                    });

                    ref.refresh(settingsProviderIsBackgroundMute).isBackgroundMute = isBackgroundMute;

                    final double background_volume = (isBackgroundMute) ? 0 : backgroundVolume/100;
                    await audioPlayer.setVolume( background_volume);

                  },
                ),

              ],
            ),

            Text("Voice volume"),
            Row(
              //mainAxisSize: MainAxisSize.max,
              children: [

                Expanded(
                  child: Slider(
                    value: voiceVolume,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${voiceVolume.round()}%",
                    onChanged: (double value)  async {

                      setState(() {
                        voiceVolume = value;
                        isVoiceMute = false;
                      });

                      ref.refresh(settingsProviderVoiceVolume).voiceVolume = voiceVolume.round();

                      final double voice_volume = (isVoiceMute) ? 0 : value/100;
                      await flutterTts.setVolume(voice_volume);

                    },
                  ),
                ),

                IconButton(
                  tooltip: "Mute",
                  icon: Icon((isVoiceMute == true) ?
                  Icons.volume_off_outlined :
                  Icons.volume_up_outlined),
                  onPressed: () async {

                    setState(() {
                      isVoiceMute = !isVoiceMute;
                    });

                    ref.refresh(settingsProviderIsVoiceMute).isVoiceMute = isVoiceMute;

                    final double voice_volume = (isVoiceMute) ? 0 : voiceVolume/100;
                    await flutterTts.setVolume( voice_volume);

                  },
                ),
              ],
            ),

            Text("Pause between phrases"),
            Row(

              children: [

                Expanded(
                  child: Slider(
                    value: voicePause,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: "${voicePause.round()} sec",
                    onChanged: (double value)  async {

                      setState(() {
                        voicePause = value;
                      });

                      ref.refresh(settingsProviderVoicePause).voicePause = voicePause.round();

                    },
                  ),
                ),

              ],
            ),



          ],
        ),
      ),
    );

  }
}