import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/core/initializer/service_initializer.dart';
import 'package:portail_eleve/app/services/connectivity_listener.dart';

import 'app/routes/app_pages.dart';
import 'app/themes/palette_system.dart';

Future<void> main() async {
  await ServiceInitializer().init();
  runApp(
    ConnectivityListener(
      child: GetMaterialApp(
        title: 'Portail Élève',
        locale: Locale('fr', 'FR'),
        fallbackLocale: Locale('en', 'US'),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
