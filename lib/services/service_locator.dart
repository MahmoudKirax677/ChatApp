import 'package:get_it/get_it.dart';
import '../services/iap_backend_service.dart';
import '../services/iap_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => IAPService());
  locator.registerLazySingleton(() => IAPBackendService());
}
