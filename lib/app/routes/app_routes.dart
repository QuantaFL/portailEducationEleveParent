part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const PARENT_HOME = _Paths.PARENT_HOME;
  static const HISTORY = _Paths.HISTORY;
  static const SETTINGS = _Paths.SETTINGS;
  static const NOTIFICATIONS = _Paths.NOTIFICATION;
}

abstract class _Paths {
  _Paths._();

  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const NOTIFICATION = '/notification';
  static const HOME = '/home';
  static const PARENT_HOME = '/parent-home';
  static const HISTORY = '/history';
  static const SETTINGS = '/settings';
}
