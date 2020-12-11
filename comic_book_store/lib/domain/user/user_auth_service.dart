import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:comic_book_store/domain/user/user_local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserAuthService {
  /// Signs user in with Google.
  ///
  ///
  Future<void> signInWithGoogle(GoogleSignIn googleSignIn) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuthService().firebaseAuth.signInWithCredential(
              credential,
            );
    final User user = authResult.user;

    // Makes sure that user is not anonymous sign in
    assert(!user.isAnonymous);

    // Creates a user token and makes sure it is not null
    assert(await user.getIdToken() != null);

    await UserLocalStorageService().saveUserPreferences(
      displayName: user.displayName,
      uid: user.uid,
      email: user.email,
    );
  }

  Future<void> signOut() async {
    StreamingSharedPreferences streamingSharedPreferences =
        await StreamingSharedPreferences.instance;
    await streamingSharedPreferences.clear();
  }
}
