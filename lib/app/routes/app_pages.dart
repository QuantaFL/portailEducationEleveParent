import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/bindings/change_password_binding.dart';
import 'package:portail_eleve/app/modules/auth/views/change_password_view.dart';
import 'package:portail_eleve/app/modules/notifications/views/notifications_view.dart';
import 'package:portail_eleve/app/modules/student_home/views/home_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/parent_home/bindings/parent_home_binding.dart';
import '../modules/parent_home/views/parent_home_view.dart';
import '../modules/student_home/bindings/home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_HOME,
      page: () => const ParentHomeView(),
      binding: ParentHomeBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),

    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationsView(),
      binding: HomeBinding(),
    ),
  ];
}
