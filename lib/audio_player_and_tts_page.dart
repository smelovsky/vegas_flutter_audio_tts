import 'dart:math';
import 'dart:io' show Platform;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vegas_flutter_audio_tts/proviiders/settings_notifier_provider.dart';


List<String> ttsPhrases = [
  "Нет предела моему совершенствованию и развитию",
  "Я постоянно развиваюсь как личность, и Вселенная поддерживает мои устремления",
  "Я прогрессирую во всем",
  "Моё духовное развитие способствует карьерному росту и росту моего финансового положения",
];

AudioPlayer audioPlayer = AudioPlayer();
FlutterTts flutterTts = FlutterTts();

class AudioPlayerAndTtsPage extends ConsumerStatefulWidget {
  const AudioPlayerAndTtsPage({super.key});

  @override
  _AudioPlayerAndTtsPageState createState() => _AudioPlayerAndTtsPageState();
}

class _AudioPlayerAndTtsPageState extends ConsumerState<AudioPlayerAndTtsPage> {

  //////////////////////////////////////////////////////////////////////////////
  // audio player

  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = "assets/audio/red-indian-music.mp3";
  bool isplaying = false;
  bool audioplayed = false;

  int voiceVolume = 50;
  bool isBackgroundMute = false;

  _initAudioPlayer() {

    Future.delayed(Duration.zero, () async {

      audioPlayer.onDurationChanged.listen((Duration d) { //get the duration of audio
        maxduration = d.inMilliseconds;

        setState(() {});

      });

      audioPlayer.onPositionChanged.listen((Duration  p){
        currentpos = p.inMilliseconds; //get the current position of playing audio

        //generating the duration label
        int shours = Duration(milliseconds:currentpos).inHours;
        int sminutes = Duration(milliseconds:currentpos).inMinutes;
        int sseconds = Duration(milliseconds:currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() {});
      });

    });
    super.initState();

  }

  //////////////////////////////////////////////////////////////////////////////
  // tts

  String? language;
  String? engine;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  int backgroundVolume = 50;
  bool isVoiceMute = false;
  int voicePause = 3;

  String _voiceText = "";

  bool isStoped = true;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  _initTts() {

  }

  Future _speak() async {

    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(_voiceText!);
  }

  _speakAllPhrases() async {

    for (int i = 0; i  <ttsPhrases.length; i++){
      if (isStoped) break;
      _voiceText = ttsPhrases[i];
      setState(() {
      });

      await _speak();

      int voice_pause = ref.read(settingsProviderVoicePause).voicePause;
      print("voicePause: ${voice_pause}");
      await Future.delayed(Duration(seconds: voice_pause));
    }

    isStoped = true;
    setState(() {
    });

  }

  //////////////////////////////////////////////////////////////////////////////
  //

  @override
  void initState() {

    _initTts();
    _initAudioPlayer();
  }

  @override
  void dispose() async {
    super.dispose();

    flutterTts.stop();
    await audioPlayer.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.yellow, Colors.green],
        ),
      ),
      //margin: EdgeInsets.only(top:50),
      child: Center (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: Text(currentpostlabel, style: TextStyle(fontSize: 25),),
              ),

              Container(
                  child: Slider(
                    value: min(currentpos, maxduration).toDouble(),
                    min: 0,
                    max: maxduration.toDouble(),
                    divisions: maxduration,
                    label: currentpostlabel,
                    onChanged: (double value) async {
                      int seekval = value.round();
                      await audioPlayer.seek(Duration(milliseconds: seekval));
                      currentpos = seekval;

                    },
                  )
              ),

              Container(
                child: Wrap(
                  spacing: 10,
                  children: [

                    ElevatedButton.icon(
                        onPressed: () async {
                          if(!isplaying && !audioplayed){

                            final source = AssetSource('audio/red-indian-music.mp3');
                            //final source = UrlSource("http://www.sovmusic.ru/m32/ballada5.mp3");
                            await audioPlayer.play(source);
                            print("player.play");

                            //play success
                            setState(() {
                              isplaying = true;
                              audioplayed = true;
                            });

                          }else if(audioplayed && !isplaying){
                            await audioPlayer.resume();
                            print("player.resume");
                            setState(() {
                              isplaying = true;
                              audioplayed = true;
                            });

                          }else{
                            await audioPlayer.pause();
                            print("player.pause");
                            setState(() {
                              isplaying = false;
                            });

                          }
                        },
                        icon: Icon(isplaying?Icons.pause:Icons.play_arrow),
                        label:Text(isplaying?"Pause":"Play")
                    ),

                    ElevatedButton.icon(
                        onPressed: () async {
                          await audioPlayer.stop();
                          print("player.stop");

                          setState(() {
                            currentpostlabel = "00:00";
                            isplaying = false;
                            audioplayed = false;
                            currentpos = 0;
                          });

                        },
                        icon: Icon(Icons.stop),
                        label:Text("Stop")
                    ),
                  ],
                ),
              ),


              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
                  child: Text((isStoped) ? "" : _voiceText)
              ),

              Container(
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          isStoped = !isStoped;
                        });

                        await flutterTts.stop();

                        if (!isStoped) {
                          _speakAllPhrases();
                        }


                      },
                      icon: Icon(Icons.speaker_notes),
                      label:Text((isStoped) ?  "Voice text" : "Stop voice")
                  )
              ),



            ],
          )
      ),


    );
  }
}