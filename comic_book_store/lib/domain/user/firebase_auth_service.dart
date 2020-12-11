import 'package:comic_book_store/domain/user/user_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../../routes/login/login_page.dart';
import '../../routes/home/home_page.dart';

class FirebaseAuthService {
  /// Initializes the FirebaseAuth service.
  ///
  /// [GoogleSignIn] is used for authentication
  /// with [FirebaseAuth]
  final firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// The [Stream] used for handling auth.
  ///
  /// Will decide the route that the user is sent to.
  /// If auth == null, then the user will be sent to
  /// the [LoginPage] to sign in.
  Stream<String> get onAuthStateChanged {
    return firebaseAuth.authStateChanges().map((User user) {
      return user?.uid;
    });
  }

  /// Signs in the user from Login Page.
  ///
  /// Once signed in, the [StreamingSharedPreferences] will
  /// modify the value of 'finishedLogin' to true, which will
  /// redirect the user to [HomePage].
  Future<void> signInWithGoogle() async {
    // Awaits the Google auth service to sign in the user.
    await UserAuthService().signInWithGoogle(googleSignIn);

    /// This modifies the value of 'finishedLogin' to notify
    /// the user logged in.
    final prefs = await StreamingSharedPreferences.instance;
    await prefs.setBool('finishedLogin', true);
  }

  /// Signs out the user from the Home Page.
  Future<void> signOutWithGoogle() async {
    // Sign out from Google Sign In
    await googleSignIn.signOut();

    // Sign out from Firebase Auth
    await firebaseAuth.signOut();

    // Sign out from local auth service
    await UserAuthService().signOut();
  }
}
