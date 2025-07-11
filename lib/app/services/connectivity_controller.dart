import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityController extends GetxController {
  final RxBool isConnected = true.obs;
  final RxBool hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityMonitoring();
  }

  void _initConnectivityMonitoring() {
    Connectivity().onConnectivityChanged.listen((_) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      isConnected.value = connectivityResult != ConnectivityResult.none;
    });

    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      hasInternet.value = status == InternetConnectionStatus.connected;
    });

    _initialCheck();
  }

  Future<void> _initialCheck() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = connectivityResult != ConnectivityResult.none;

    hasInternet.value = await InternetConnectionChecker.instance.hasConnection;
  }
}
