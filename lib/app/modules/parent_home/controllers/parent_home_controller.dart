import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:portail_eleve/app/core/services/parent_service.dart';
import 'package:portail_eleve/app/modules/parent_home/data/useCases/parent_poll_latest_bulletins.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

import '../../../core/data/models/report_card.dart';
import '../../../core/data/models/student.dart';
import '../../../core/data/models/user_model.dart';

class ParentHomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var selectedChildIndex = 0.obs;
  var isRefreshing = false.obs;

  var currentParent = Rx<UserModel?>(null);
  var children = <Student>[].obs;
  var childrenUsers = <UserModel>[].obs;

  var recentBulletins = <ReportCard>[].obs;
  var allBulletins = <ReportCard>[].obs;

  var bulletinsHistory = <ReportCard>[].obs;

  late ParentService _parentService;
  late ParentPollLatestBulletins _pollService;
  final Logger _logger = Logger();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    _parentService = Get.find<ParentService>();
    _pollService = Get.find<ParentPollLatestBulletins>();
    await loadParentDashboardData();
    _startBulletinPolling();
  }

  @override
  void onClose() {
    _pollService.stopPolling();
    super.onClose();
  }

  void _startBulletinPolling() {
    _logger.i('🚀 Démarrage du polling des bulletins pour les enfants');
    _pollService.startPolling();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectChild(int index) {
    if (index >= 0 && index < children.length) {
      selectedChildIndex.value = index;
      _loadSelectedChildBulletins();
    }
  }

  Future<void> loadParentDashboardData() async {
    try {
      isLoading.value = true;
      _logger.d('🔄 Chargement du tableau de bord parent...');

      currentParent.value = await _parentService.getCurrentParent();
      _logger.i('✅ Profil parent chargé: ${currentParent.value?.firstName}');

      children.value = await _parentService.getChildren();
      _logger.i('✅ ${children.length} enfants chargés');

      if (children.isNotEmpty) {
        childrenUsers.value = await _parentService.getChildrenUsers();
        _logger.i('✅ ${childrenUsers.length} profils d\'enfants chargés');

        await _loadSelectedChildBulletins();

        await _initializeBulletinTracking();
      }

      _logger.i('🎉 Tableau de bord parent chargé avec succès!');
    } catch (e) {
      _logger.e('❌ Erreur chargement tableau de bord parent: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initializeBulletinTracking() async {
    _logger.i(
      '📋 Bulletin tracking initialized for ${children.length} children',
    );
  }

  Future<void> refreshData() async {
    if (isRefreshing.value) return;

    try {
      isRefreshing.value = true;
      _logger.d('🔄 Manual refresh triggered');

      await loadParentDashboardData();
      await _pollService.pollNow();

      Get.snackbar(
        'Actualisation',
        'Données mises à jour',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('❌ Error during manual refresh: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'actualisation',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> forceRefreshBulletins() async {
    try {
      _logger.d('🔄 Force refresh bulletins triggered');
      await _pollService.forceRefreshBulletins();
      await loadParentDashboardData();
    } catch (e) {
      _logger.e('❌ Error during force refresh bulletins: $e');
    }
  }

  void enableBulletinDebugMode() {
    _pollService.enableDebugMode();
    Get.snackbar(
      'Mode Debug',
      'Polling des bulletins activé en mode debug (30s)',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  Future<void> _loadSelectedChildBulletins() async {
    if (children.isEmpty) return;

    try {
      final selectedChild = children[selectedChildIndex.value];
      _logger.d('📋 Chargement bulletins pour enfant: ${selectedChild.id}');

      final bulletins = await _parentService.getBulletinsForChild(
        selectedChild.id!,
      );
      allBulletins.value = bulletins;

      final sortedBulletins = List<ReportCard>.from(bulletins);
      sortedBulletins.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      recentBulletins.value = sortedBulletins.take(3).toList();

      _logger.i(
        '✅ ${bulletins.length} bulletins chargés (${recentBulletins.length} récents)',
      );
    } catch (e) {
      _logger.e('❌ Erreur chargement bulletins: $e');
    }
  }

  Future<void> downloadBulletin(int bulletinId) async {
    try {
      isLoading.value = true;

      final bulletin = [...allBulletins, ...recentBulletins].firstWhere(
        (b) => b.id == bulletinId,
        orElse: () => throw Exception('Bulletin non trouvé'),
      );

      final selectedChild = children[selectedChildIndex.value];
      final childId = selectedChild.id!;

      Get.snackbar(
        'Téléchargement',
        'Téléchargement du bulletin en cours...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      final downloadPath = await _pollService.downloadBulletin(
        childId,
        bulletin,
      );

      if (downloadPath != null) {
        Get.snackbar(
          'Succès',
          'Bulletin téléchargé avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await OpenFile.open(downloadPath);
      } else {
        throw Exception('Échec du téléchargement');
      }
    } catch (e) {
      _logger.e('❌ Erreur téléchargement bulletin: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le bulletin: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  UserModel? get selectedChildUser {
    if (children.isEmpty || childrenUsers.isEmpty) return null;

    final selectedChild = children[selectedChildIndex.value];
    return childrenUsers.firstWhere(
      (u) => u.id == selectedChild.userModelId,
      orElse: () => UserModel(firstName: 'Enfant'),
    );
  }

  Future<void> logout() async {
    try {
      _logger.d('🚪 Déconnexion...');

      await _storage.deleteAll();

      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        'Déconnexion',
        'Vous avez été déconnecté avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _logger.e('❌ Erreur lors de la déconnexion: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la déconnexion',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
