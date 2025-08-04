import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';
import 'package:portail_eleve/app/core/services/parent_service.dart';
import 'package:portail_eleve/app/modules/parent_home/controllers/parent_home_controller.dart';
import 'package:portail_eleve/app/services/notification_service.dart';

/// Service for auto-refreshing data and checking for new bulletins
class AutoRefreshService extends GetxService with WidgetsBindingObserver {
  static const Duration _refreshInterval = Duration(minutes: 5);
  static const Duration _bulletinCheckInterval = Duration(minutes: 10);

  Timer? _refreshTimer;
  Timer? _bulletinCheckTimer;
  final Logger _logger = Logger();
  late ParentService _parentService;
  late NotificationService _notificationService;

  // Keep track of last known bulletins to detect new ones
  final Map<int, List<int>> _lastKnownBulletinIds = {};

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _parentService = Get.find<ParentService>();
    _notificationService = Get.find<NotificationService>();
    _startAutoRefresh();
    _logger.i('✅ Auto-refresh service initialized');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopAutoRefresh();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _logger.d('📱 App resumed - triggering refresh');
        _triggerManualRefresh();
        _startAutoRefresh();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _logger.d('📱 App paused/inactive - stopping auto-refresh');
        _stopAutoRefresh();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Start periodic auto-refresh timers
  void _startAutoRefresh() {
    _stopAutoRefresh();
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      _triggerDataRefresh();
    });

    _bulletinCheckTimer = Timer.periodic(_bulletinCheckInterval, (timer) {
      _checkForNewBulletins();
    });

    _logger.d('🔄 Auto-refresh timers started');
  }

  /// Stop all auto-refresh timers
  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _bulletinCheckTimer?.cancel();
    _refreshTimer = null;
    _bulletinCheckTimer = null;
    _logger.d('⏹️ Auto-refresh timers stopped');
  }

  /// Trigger immediate data refresh
  Future<void> _triggerDataRefresh() async {
    try {
      // Try to find and refresh the parent home controller
      if (Get.isRegistered<ParentHomeController>()) {
        final controller = Get.find<ParentHomeController>();
        _logger.d('🔄 Auto-refreshing dashboard data...');
        await controller.loadParentDashboardData();
      }
    } catch (e) {
      _logger.e('❌ Error during auto-refresh: $e');
    }
  }

  /// Manual refresh trigger (for app resume or user action)
  Future<void> _triggerManualRefresh() async {
    try {
      // Check if parent home controller exists and trigger refresh
      if (Get.isRegistered<ParentHomeController>()) {
        final controller = Get.find<ParentHomeController>();
        _logger.d('🔄 Manual refresh triggered');
        await controller.loadParentDashboardData();
      }
    } catch (e) {
      _logger.e('❌ Error during manual refresh: $e');
    }
  }

  /// Check for new bulletins and send notifications
  Future<void> _checkForNewBulletins() async {
    try {
      _logger.d('🔍 Checking for new bulletins...');

      final children = await _parentService.getChildren();
      if (children.isEmpty) return;

      for (final child in children) {
        if (child.id == null) continue;

        final bulletins = await _parentService.getBulletinsForChild(child.id!);
        final currentBulletinIds = bulletins
            .map((b) => b.id)
            .where((id) => id != null)
            .cast<int>()
            .toList();

        final lastKnownIds = _lastKnownBulletinIds[child.id!] ?? [];

        // Find new bulletins
        final newBulletinIds = currentBulletinIds
            .where((id) => !lastKnownIds.contains(id))
            .toList();

        if (newBulletinIds.isNotEmpty && lastKnownIds.isNotEmpty) {
          _logger.i(
            '🎉 Found ${newBulletinIds.length} new bulletin(s) for child ${child.id}',
          );

          // Get child user info for notification
          final childrenUsers = await _parentService.getChildrenUsers();
          final childUser = childrenUsers.firstWhere(
            (u) => u.id == child.userModelId,
            orElse: () => throw Exception('Child user not found'),
          );

          final childName = childUser.firstName ?? 'Enfant';

          for (final bulletinId in newBulletinIds) {
            final bulletin = bulletins.firstWhere((b) => b.id == bulletinId);
            await _notificationService.showBulletinNotification(
              studentName: childName,
              bulletinTitle:
                  'Bulletin ${bulletin.termId == 1 ? 'semestre 1' : 'semestre 2'}',
              bulletinId: bulletinId,
            );
          }
        }

        // Update last known bulletin IDs
        _lastKnownBulletinIds[child.id!] = currentBulletinIds;
      }
    } catch (e) {
      _logger.e('❌ Error checking for new bulletins: $e');
    }
  }

  /// Initialize bulletin tracking for a child
  Future<void> initializeBulletinTracking(
    int childId,
    List<ReportCard> bulletins,
  ) async {
    final bulletinIds = bulletins
        .map((b) => b.id)
        .where((id) => id != null)
        .cast<int>()
        .toList();
    _lastKnownBulletinIds[childId] = bulletinIds;
    _logger.d(
      '📋 Initialized bulletin tracking for child $childId with ${bulletinIds.length} bulletins',
    );
  }

  /// Force check for new bulletins (for manual refresh)
  Future<void> forceCheckNewBulletins() async {
    await _checkForNewBulletins();
  }

  /// Get refresh status
  bool get isAutoRefreshActive =>
      _refreshTimer?.isActive == true && _bulletinCheckTimer?.isActive == true;
}
