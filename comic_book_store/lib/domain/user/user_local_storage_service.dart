import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserLocalStorageService {

  Future<void> saveUserPreferences({
    @required String displayName,
    @required String uid,
    @required String email,
  }) async {
    StreamingSharedPreferences streamingSharedPreferences = await StreamingSharedPreferences.instance;
    await streamingSharedPreferences.setString('uid', uid);
    await streamingSharedPreferences.setString('displayName', displayName);
    await streamingSharedPreferences.setString('email', email);
  }

}