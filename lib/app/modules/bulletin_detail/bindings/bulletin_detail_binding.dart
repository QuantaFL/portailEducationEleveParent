import 'package:get/get.dart';

import '../controllers/bulletin_detail_controller.dart';

class BulletinDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BulletinDetailController>(() => BulletinDetailController());
  }
}
