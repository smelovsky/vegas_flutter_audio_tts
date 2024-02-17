import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifierVoicePause extends ChangeNotifier {
  int voicePause = 3;
}
final settingsProviderVoicePause =
ChangeNotifierProvider<SettingsNotifierVoicePause>((ref) {
  return SettingsNotifierVoicePause();
});

class SettingsNotifierVoiceVolume extends ChangeNotifier {
  int voiceVolume = 30;
}
final settingsProviderVoiceVolume =
ChangeNotifierProvider<SettingsNotifierVoiceVolume>((ref) {
  return SettingsNotifierVoiceVolume();
});

class SettingsNotifierIsVoiceMute extends ChangeNotifier {
  bool isVoiceMute = false;
}
final settingsProviderIsVoiceMute =
ChangeNotifierProvider<SettingsNotifierIsVoiceMute>((ref) {
  return SettingsNotifierIsVoiceMute();
});

class SettingsNotifierBackgroundVolume extends ChangeNotifier {
  int backgroundVolume = 30;
}
final settingsProviderBackgroundVolume =
ChangeNotifierProvider<SettingsNotifierBackgroundVolume>((ref) {
  return SettingsNotifierBackgroundVolume();
});

class SettingsNotifierIsBackgroundMute extends ChangeNotifier {
  bool isBackgroundMute = false;
}
final settingsProviderIsBackgroundMute =
ChangeNotifierProvider<SettingsNotifierIsBackgroundMute>((ref) {
  return SettingsNotifierIsBackgroundMute();
});
