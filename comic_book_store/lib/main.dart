import 'package:cloud_firestore/cloud_firestore.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  LocalStorageProvider localStorageProvider;
  final streamingPrefs = await StreamingSharedPreferences.instance;
  localStorageProvider = new LocalStorageProvider(
    streamingPrefs,
  );
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
  FirebaseAuthService firebaseAuthService = new FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
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
