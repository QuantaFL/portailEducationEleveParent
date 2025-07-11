import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
