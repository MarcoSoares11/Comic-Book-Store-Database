import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class LocalStorageProvider {
  LocalStorageProvider(
    final StreamingSharedPreferences streamingSharedPreferences,
  )   : finishedLogin = streamingSharedPreferences.getBool(
          'finishedLogin',
          defaultValue: false,
        ),
        uid = streamingSharedPreferences.getString(
          'uid',
          defaultValue: '',
        ),
        displayName = streamingSharedPreferences.getString(
          'displayName',
          defaultValue: '',
        ),
        email = streamingSharedPreferences.getString(
          'email',
          defaultValue: 'null',
        );

  final Preference<bool> finishedLogin;

  final Preference<String> uid;
  final Preference<String> displayName;
  final Preference<String> email;
}
