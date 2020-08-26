import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

class FingerprintHandler {
  
  final LocalAuthentication _localAuthentication = new LocalAuthentication();

  bool _hasFingerprintSupport = false;
  bool get hasFingerprintSupport => _hasFingerprintSupport;

  Future<void> getBiometricsSupport() async {
    bool hasFingerprintSupport = false;
    try {
      hasFingerprintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    _hasFingerprintSupport = hasFingerprintSupport;
  }

  Future<bool> authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, 
        androidAuthStrings: AndroidAuthMessages(cancelButton: "Cancel")// native process
      );
    } catch (e) {
      print(e);
    }
    return authenticated;
  }
}
