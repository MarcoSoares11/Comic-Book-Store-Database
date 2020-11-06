import 'package:comic_book_store/domain/user/user_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged {
    return firebaseAuth.authStateChanges().map((User user) {
      return user?.uid;
    });
  }

  Future<void> signInWithGoogle() async {
    await UserAuthService().signInWithGoogle(googleSignIn);

    final prefs = await StreamingSharedPreferences.instance;

    await prefs.setBool('finishedLogin', true);
  }

  Future<void> signOutWithGoogle() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await UserAuthService().signOut();
  }
}
