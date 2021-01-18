import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:comic_book_store/routes/home/home_page.dart';
import 'package:comic_book_store/routes/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() {
    return _AuthWidgetState();
  }
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    // Initialize the authentication provider
    final firebaseAuthService = Provider.of<FirebaseAuthService>(
      context,
    );

    return StreamBuilder<String>(
      stream: firebaseAuthService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            print(user);

            if (user == null) {
              // User hasn't logged in yet
              return LoginPage();
            } else {
              // User has logged in
              return HomePage();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          } else {
            return LoginPage();
          }
        } else {
          return LoginPage();
        }
      },
    );
  }
}
