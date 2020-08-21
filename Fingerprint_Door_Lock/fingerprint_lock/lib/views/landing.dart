import 'package:fingerprint_lock/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../Animation/fade_animation.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = true;
  bool _hidePass = true;
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.4; // from 0-1.0
  String name = "";
  String uniqueId = "";
  Color kPinkColor = Color(0xffE84656);
  Future<void> saveName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromRGBO(71, 63, 151, 1),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fingerprint_bg.jpg'),
                        fit: BoxFit.fill),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                    child: Container(
                      color: Colors.black.withOpacity(_opacity),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(
                          1.2,
                          Text(
                            "Welcome",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          1.5,
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    onChanged: (fullname) => name = fullname,
                                    validator: (input) =>
                                        input.isEmpty ? "*Required" : null,
                                    cursorColor: kPinkColor,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "Fullname"),
                                  ),
                                ),
                                Container(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    onChanged: (id) => uniqueId = id,
                                    validator: (input) =>
                                        input.isEmpty ? "*Required" : null,
                                    cursorColor: kPinkColor,
                                    obscureText: _hidePass,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(() {
                                            _hidePass = !_hidePass;
                                          }),
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: _hidePass
                                                ? Colors.grey.withOpacity(.8)
                                                : kPinkColor,
                                          ),
                                        ),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "Device Unique ID"),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      FadeAnimation(
                        1.8,
                        GestureDetector(
                          onTap: () {
                            if (_autoValidate) {
                              saveName();
                              if (uniqueId.compareTo('hackingthrough001') ==
                                  0) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(name: name)));
                              } else {
                                SnackBar snackBar = new SnackBar(
                                  content: Text('Enter A Unique ID'),
                                  duration: Duration(seconds: 2),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: kPinkColor.withOpacity(0.9),
                              ),
                              child: Center(
                                  child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
