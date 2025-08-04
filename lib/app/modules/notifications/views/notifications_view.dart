import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/themes/palette_system.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundOf(context),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppDesignSystem.cardOf(context),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF1E293B),
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _markAllAsRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Tout marquer lu',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Bulletins',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppDesignSystem.textPrimaryOf(context),
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        'Chargement des bulletins...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppDesignSystem.cardOf(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBulletinStat(
                        'Nouveaux',
                        '--', // TODO: Connect to real new bulletin count
                        const Color(0xFFEF4444),
                        const Color(0xFFFEF2F2),
                        Icons.fiber_new_rounded,
                        context,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Expanded(
                      child: _buildBulletinStat(
                        'Total',
                        '--', // TODO: Connect to real total bulletin count
                        const Color(0xFF10B981),
                        const Color(0xFFF0FDF4),
                        Icons.assignment_rounded,
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bulletin Notifications List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildBulletinsList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the bulletins list widget
  Widget _buildBulletinsList(BuildContext context) {
    // TODO: Replace with GetX controller or FutureBuilder connected to real data
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun bulletin disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les nouveaux bulletins apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: AppDesignSystem.textPrimaryOf(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds a bulletin statistic widget
  Widget _buildBulletinStat(
    String label,
    String value,
    Color primaryColor,
    Color backgroundColor,
    IconData icon,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppDesignSystem.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppDesignSystem.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }

  /// Marks all bulletin notifications as read
  void _markAllAsRead() {
    // TODO: Implement actual mark all as read functionality
    Get.snackbar(
      'Bulletins marqués',
      'Tous les bulletins ont été marqués comme lus',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // /// Opens the selected bulletin
  // void _openBulletin(Map<String, dynamic> bulletin) {
  //   // TODO: Implement actual bulletin opening/downloading functionality
  //   Get.snackbar(
  //     'Ouverture du bulletin',
  //     'Téléchargement de ${bulletin['title']}...',
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: const Color(0xFF6366F1),
  //     colorText: Colors.white,
  //     duration: const Duration(seconds: 2),
  //   );
  // }
}
