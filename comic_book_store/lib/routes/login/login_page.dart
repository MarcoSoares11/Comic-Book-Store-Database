import 'package:comic_book_store/config/global_theming.dart';
import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Easily find path to the logo icon.
  final String iconAssetName = "assets/book_store_login_icon.svg";

  @override
  Widget build(BuildContext context) {
    // Initialize the Authentication provider
    final firebaseAuthService = Provider.of<FirebaseAuthService>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            child: MaterialButton(
              onPressed: () async {
                await firebaseAuthService
                    .signInWithGoogle()
                    .catchError((error) {
                  print(error);
                });
              },
              color: ComicBookStoreTheming().secondary,
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              splashColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Sign In with Google",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
