import 'package:fingerprint_door_lock_app/services/local_auth_service.dart';
import 'package:fingerprint_door_lock_app/services/shared_preference.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<LocalAuthenticationService>(
      () => LocalAuthenticationService());
}

void setupPref() {
  locator.registerLazySingleton<StoreData>(() => StoreData());
}
