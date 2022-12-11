import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friend_zone/src/app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox('permanentBox');
    await Hive.openBox('temporaryBox');

    await Firebase.initializeApp();
    FlutterError.onError = (FlutterErrorDetails details) {
      print(details);
    };
    runApp(const App());
  }, (Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  });
}
