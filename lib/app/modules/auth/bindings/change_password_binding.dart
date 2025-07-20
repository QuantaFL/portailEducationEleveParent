
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/controllers/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(),
    );
  }
}
