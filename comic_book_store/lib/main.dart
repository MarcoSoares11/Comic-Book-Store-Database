import 'package:comic_book_store/config/global_theming.dart';
import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:comic_book_store/providers/local_storage_provider.dart';
import 'package:comic_book_store/routes/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main() async {
  // Initialize Flutter's widget binding service
  WidgetsFlutterBinding.ensureInitialized();

  GestureBinding.instance.resamplingEnabled = true;

  /// Initialize the [StreamingSharedPreferences] service through
  /// a provider
  LocalStorageProvider localStorageProvider;
  final streamingPrefs = await StreamingSharedPreferences.instance;
  localStorageProvider = new LocalStorageProvider(
    streamingPrefs,
  );

  // Initialize the Firebase service in the app
  await Firebase.initializeApp();

  runApp(
    ComicBookStoreApp(
      localStorageProvider: localStorageProvider,
    ),
  );
}

class ComicBookStoreApp extends StatefulWidget {
  final LocalStorageProvider localStorageProvider;

  const ComicBookStoreApp({
    Key key,
    this.localStorageProvider,
  }) : super(key: key);

  @override
  _ComicBookStoreAppState createState() => _ComicBookStoreAppState();
}

class _ComicBookStoreAppState extends State<ComicBookStoreApp> {
  // Define the local Firebase Authentication Service
  FirebaseAuthService firebaseAuthService = new FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    /// [MultiProvider] initializes both of the app's providers.
    ///
    /// [FirebaseAuthService] is used for authentication
    /// [LocalStorageProvider] is used for Shared Preferences
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => firebaseAuthService,
        ),
        Provider<LocalStorageProvider>(
          create: (_) => widget.localStorageProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Comic Book Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: ComicBookStoreTheming().primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
