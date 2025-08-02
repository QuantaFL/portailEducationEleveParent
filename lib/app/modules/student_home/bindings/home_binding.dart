import 'package:get/get.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/repositories/bulletin_repository.dart';
import 'package:portail_eleve/app/core/data/repositories/student_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BulletinRepository>()) {
      final apiClient = Get.find<ApiClient>();
      Get.lazyPut<BulletinRepository>(
        () => BulletinRepository(apiClient: apiClient),
      );
    }
    if (!Get.isRegistered<StudentRepository>()) {
      final apiClient = Get.find<ApiClient>();
      Get.lazyPut<StudentRepository>(
        () => StudentRepository(apiClient: apiClient),
      );
    }
    Get.lazyPut<HomeController>(
      () => HomeController(
        bulletinRepository: Get.find<BulletinRepository>(),
        studentRepository: Get.find<StudentRepository>(),
      ),
    );
  }
}
