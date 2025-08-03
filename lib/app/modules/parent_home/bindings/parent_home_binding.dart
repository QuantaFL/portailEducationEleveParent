import 'package:get/get.dart';
import 'package:portail_eleve/app/core/services/parent_service.dart';

import '../controllers/parent_home_controller.dart';

class ParentHomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register ParentService as a singleton
    Get.lazyPut<ParentService>(() => ParentService(), fenix: true);

    // Register ParentHomeController
    Get.lazyPut<ParentHomeController>(() => ParentHomeController());
  }
}
