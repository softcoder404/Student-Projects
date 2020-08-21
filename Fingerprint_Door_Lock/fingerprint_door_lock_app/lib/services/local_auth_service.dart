import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = false;
  bool _isAuthenticate = false;
  bool _hasFingerprintSupport = false;
  // ignore: unnecessary_getters_setters
  bool get isProtectionEnabled => _isProtectionEnabled;
  bool get isAuthenticate => _isAuthenticate;
  bool get hasFingerprintSupport => _hasFingerprintSupport;
  // ignore: unnecessary_getters_setters
  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;

  
  bool hasFingerPrintSupport = false;
  Future<void> authenticate() async {
    if (_isProtectionEnabled) {
      try {
        _isAuthenticate = await _auth.authenticateWithBiometrics(
            localizedReason: 'authenticate to access',
            useErrorDialogs: true,
            stickyAuth: true);
        _isAuthenticate ? print('User is valid') : print("Invalid User");
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Future<void> getBiometricSupport() async {
    try {
      _hasFingerprintSupport = await _auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
  }
}
