import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// Singleton to fetch local user data.
///
/// [Provider] used for fetching user data from [StreamingSharedPreferences].
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

  // Signilizes when to redirect user to home page
  final Preference<bool> finishedLogin;

  // Basic information from user login
  final Preference<String> uid;
  final Preference<String> displayName;
  final Preference<String> email;
}
