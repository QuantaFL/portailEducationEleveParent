import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'connectivity_controller.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  _ConnectivityListenerState createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  late ConnectivityController controller;
  late bool previouslyOnline;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ConnectivityController>();
    previouslyOnline = controller.hasInternet.value;

    controller.hasInternet.listen((online) {
      if (!online && previouslyOnline) {
        Get.snackbar(
          'Pas d\'Internet',
          'Vous êtes hors ligne ou votre réseau est inutilisable.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (online && !previouslyOnline) {
        Get.snackbar(
          'Retour en ligne',
          'La connexion Internet a été rétablie.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      previouslyOnline = online;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
