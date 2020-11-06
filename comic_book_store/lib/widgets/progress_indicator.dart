import 'package:flutter/material.dart';

class ComicBookStoreProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        strokeWidth: 3,
      ),
    );
  }
}
