import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import '../Animations/FadeAnimation.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _hidePass = true;
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.4; // from 0-1.0
  String name = "";
  String uniqueId = "";
  Color kPinkColor = Color(0xffE84656);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    onSaved: (input) => name = input,
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
                                    onSaved: (input) => uniqueId = input,
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
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              //login user

                            } else {}
                            //show loading bar
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Center(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.transparent,
                                    child: SpinKitChasingDots(
                                      color: kPinkColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                            //end loading bar
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
