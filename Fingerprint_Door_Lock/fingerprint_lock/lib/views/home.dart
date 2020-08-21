import 'package:fingerprint_lock/utils/widgets/bottom_sheet.dart';
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

  //start
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasFingerPrintSupport = false;
  String _authorizedOrNot = "Not Authorized";

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
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
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
            Text("Has FingerPrint Support : $_hasFingerPrintSupport"),
            Text("Authorized : $_authorizedOrNot"),
            RaisedButton(
              child: Text("Authorize Now"),
              color: Colors.green,
              onPressed: _authenticateMe,
            ),
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(),
    );
  }
}
