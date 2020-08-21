import 'package:shared_preferences/shared_preferences.dart';

class StoreData {
  final _writeKey = "validate";
  String _user;
  //get user
  String get user => _user;
  //get data from local storage
  Future<bool> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool res = pref.getBool(_writeKey);
    return res;
  }

  //save data to local storage
  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _user = pref.getString('user');
  }
}
