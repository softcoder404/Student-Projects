import 'package:fingerprint_door_lock_app/views/home.dart';
import 'package:fingerprint_door_lock_app/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with AfterLayoutMixin<LoadingScreen> {
  Future checkValidity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _valid = (prefs.getBool('seen') ?? false);

    if (_valid) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LandingScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context)=> checkValidity();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
