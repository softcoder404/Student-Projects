import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final name;

  HomeScreen({@required this.name});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('validate', true);
  }

  bool showBottomSheet = true;
  bool _showSecond = false;
  //start
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasFingerPrintSupport = false;
  String _authorizedOrNot = "User Not Authorized";

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? "Authorized" : "User Not Authorized";
      authenticated ? _showSecond = true : _showSecond = false;
    });
  }

  //end
  @override
  void initState() {
    _getBiometricsSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    saveData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey ${widget.name} !"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Has FingerPrint Support : "),
            Text("Authorized : "),
            RaisedButton(
              child: Text("Authorize Now"),
              color: Colors.green,
              onPressed: () {},
            ),
          ],
        ),
      ),
      bottomSheet: showBottomSheet
          ? BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) => AnimatedContainer(
                margin: EdgeInsets.only(left: 10, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: AnimatedCrossFade(
                    firstChild: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height * 0.65),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_authorizedOrNot,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                          RaisedButton(
                            color: Colors.red[100],
                            padding: EdgeInsets.all(8.0),
                            onPressed: _authenticateMe,
                            child: Image.asset(
                              'assets/images/thumbprint.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  _hasFingerPrintSupport
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _hasFingerPrintSupport
                                      ? Colors.amber
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                _hasFingerPrintSupport
                                    ? "Device support fingerprint biometric"
                                    : "Device does not support fingerprint",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    secondChild: Container(
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height * 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text("Authorized User Found",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18,fontWeight: FontWeight.w500)),
                          ),
                          Image.asset('assets/images/success.png',height: 160,),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () =>
                                    setState(() => showBottomSheet = false),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Connect To Bluetooth Device',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    crossFadeState: _showSecond
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 400)),
                duration: Duration(milliseconds: 400),
              ),
            )
          : null,
    );
  }
}
