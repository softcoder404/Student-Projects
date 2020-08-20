import 'dart:async';

import 'package:fingerprint_door_lock_app/views/home.dart';
import 'package:fingerprint_door_lock_app/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future checkValidity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool _isValid = pref.getBool('validity');
    if (_isValid != null) {
      if (_isValid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  name: "John Doe !",
                )));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LandingScreen()));
      }
    } else {
      Timer.periodic(Duration(seconds: 5), (Timer timer) {
        _isValid = false;
      });
    }
  }

  @override
  void initState() {
    checkValidity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.amber,
        ),
      ),
    ));
  }
}
