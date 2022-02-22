import 'features/user/repositories/storage_repo.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  //locator.registerSingleton<AuthClient>(AuthClient(FirebaseAuth.instance));
  locator.registerSingleton<StorageRepo>(StorageRepo());
  //locator.registerSingleton<UserController>(UserController());
}
