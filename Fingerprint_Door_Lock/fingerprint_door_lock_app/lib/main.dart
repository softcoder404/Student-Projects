import 'package:fingerprint_door_lock_app/services/service_locator.dart';
import 'package:fingerprint_door_lock_app/views/loading.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  setupPref();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "fingerprint door lock",
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
