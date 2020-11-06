import 'dart:async';

import 'package:comic_book_store/routes/auth_widget.dart';
import 'package:comic_book_store/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final iconAssetName = "assets/book_store_login_icon.svg";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(
            milliseconds: 400,
          ),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: new Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                ),
              ),
              child: child,
            );
          },
          pageBuilder: (context, a, b) {
            return AuthWidget();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Transform.scale(
            scale: 1.3,
            child: SvgPicture.asset(
              iconAssetName,
              width: 400,
              height: 200,
            ),
          ),
          Text(
            "Book Store Database",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ComicBookStoreProgressIndicator()
        ],
      ),
    );
  }
}
