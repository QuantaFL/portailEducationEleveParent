import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;
  final RxBool isAnimating = false.obs;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    final hasSeenOnboarding = await _storage.read(key: 'hasSeenOnboarding');
    if (hasSeenOnboarding == 'true') {
      // Skip onboarding and go to login
      Get.offAllNamed('/login');
    }
  }

  void nextPage() {
    if (currentPage.value < 3) {
      isAnimating.value = true;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      isAnimating.value = true;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPage(int page) {
    isAnimating.value = true;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    isLastPage.value = page == 3;
    isAnimating.value = false;
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() async {
    await _storage.write(key: 'hasSeenOnboarding', value: 'true');
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
