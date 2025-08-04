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

/// Clean parent home controller with Hive caching support and bulletin polling
class ParentHomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var selectedChildIndex = 0.obs;
  var isRefreshing = false.obs;

  // Parent and children data
  var currentParent = Rx<UserModel?>(null);
  var children = <Student>[].obs;
  var childrenUsers = <UserModel>[].obs;

  // Bulletin data for selected child
  var recentBulletins = <ReportCard>[].obs;
  var allBulletins = <ReportCard>[].obs;

  // All bulletins from all children for history view
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

  /// Démarre le polling automatique des bulletins
  void _startBulletinPolling() {
    _logger.i('🚀 Démarrage du polling des bulletins pour les enfants');
    _pollService.startPolling();
  }

  /// Change bottom navigation tab (no external navigation needed)
  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Select a child and load their bulletins
  void selectChild(int index) {
    if (index >= 0 && index < children.length) {
      selectedChildIndex.value = index;
      _loadSelectedChildBulletins();
    }
  }

  /// Load all parent dashboard data with Hive fallback
  Future<void> loadParentDashboardData() async {
    try {
      isLoading.value = true;
      _logger.d('🔄 Chargement du tableau de bord parent...');

      // Load parent profile from service (with Hive fallback)
      currentParent.value = await _parentService.getCurrentParent();
      _logger.i('✅ Profil parent chargé: ${currentParent.value?.firstName}');

      // Load children (with Hive fallback)
      children.value = await _parentService.getChildren();
      _logger.i('✅ ${children.length} enfants chargés');

      // Load children user data (with Hive fallback)
      if (children.isNotEmpty) {
        childrenUsers.value = await _parentService.getChildrenUsers();
        _logger.i('✅ ${childrenUsers.length} profils d\'enfants chargés');

        // Load bulletins for first child by default
        await _loadSelectedChildBulletins();

        // Initialize bulletin tracking for polling service
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

  /// Initialize bulletin tracking for all children
  Future<void> _initializeBulletinTracking() async {
    // The polling service will automatically track bulletins when it starts
    // No manual initialization needed - just log that children are ready
    _logger.i(
      '📋 Bulletin tracking initialized for ${children.length} children',
    );
  }

  /// Manual refresh with pull-to-refresh and bulletin polling
  Future<void> refreshData() async {
    if (isRefreshing.value) return;

    try {
      isRefreshing.value = true;
      _logger.d('🔄 Manual refresh triggered');

      await loadParentDashboardData();
      await _pollService.pollNow(); // Force bulletin check

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

  /// Force refresh all bulletins (marks all as new)
  Future<void> forceRefreshBulletins() async {
    try {
      _logger.d('🔄 Force refresh bulletins triggered');
      await _pollService.forceRefreshBulletins();
      await loadParentDashboardData();
    } catch (e) {
      _logger.e('❌ Error during force refresh bulletins: $e');
    }
  }

  /// Enable debug mode for bulletin polling (30-second intervals)
  void enableBulletinDebugMode() {
    _pollService.enableDebugMode();
    Get.snackbar(
      'Mode Debug',
      'Polling des bulletins activé en mode debug (30s)',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  /// Load bulletins for the currently selected child
  Future<void> _loadSelectedChildBulletins() async {
    if (children.isEmpty) return;

    try {
      final selectedChild = children[selectedChildIndex.value];
      _logger.d('📋 Chargement bulletins pour enfant: ${selectedChild.id}');

      final bulletins = await _parentService.getBulletinsForChild(
        selectedChild.id!,
      );
      allBulletins.value = bulletins;

      // Sort by creation date (most recent first) - same as student home
      final sortedBulletins = List<ReportCard>.from(bulletins);
      sortedBulletins.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      // Show the 3 most recent bulletins - same as student home
      recentBulletins.value = sortedBulletins.take(3).toList();

      _logger.i(
        '✅ ${bulletins.length} bulletins chargés (${recentBulletins.length} récents)',
      );
    } catch (e) {
      _logger.e('❌ Erreur chargement bulletins: $e');
      // Don't show error to user for bulletins, just log it - same as student
    }
  }

  /// Download and open a bulletin PDF using the polling service
  Future<void> downloadBulletin(int bulletinId) async {
    try {
      isLoading.value = true;

      // Find the bulletin by ID
      final bulletin = [...allBulletins, ...recentBulletins].firstWhere(
        (b) => b.id == bulletinId,
        orElse: () => throw Exception('Bulletin non trouvé'),
      );

      // Get child information
      final selectedChild = children[selectedChildIndex.value];
      final childId = selectedChild.id!;

      // Show download progress
      Get.snackbar(
        'Téléchargement',
        'Téléchargement du bulletin en cours...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Use the polling service download method (same as student)
      final downloadPath = await _pollService.downloadBulletin(
        childId,
        bulletin,
      );

      if (downloadPath != null) {
        // Success notification
        Get.snackbar(
          'Succès',
          'Bulletin téléchargé avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Try to open the file
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

  /// Get the currently selected child user data
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
