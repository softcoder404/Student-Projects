import 'dart:async';
import 'package:fingerprint_lock/views/home.dart';
import 'package:fingerprint_lock/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isValid;
  String _user;
  Future getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _user = pref.getString('user');
  }

  Future checkValidity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isValid = pref.getBool('validate');
  }

  void takeAction() {
    if (_isValid == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingScreen()));
    } else if (_isValid) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                name: _user,
              )));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingScreen()));
    }
  }

  Timer _timer;
  @override
  void initState() {
    checkValidity();
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timer = new Timer.periodic(Duration(seconds: 5), (Timer t) {
      takeAction();
    });
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
