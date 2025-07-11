import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Ultra Modern Header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  // Top Bar
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
                            'Tout marquer',
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
                  // Title with accent
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
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        '5 nouvelles notifications',
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

            // Enhanced Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      child: _buildEnhancedStat(
                        'Non lues',
                        '5',
                        const Color(0xFFEF4444),
                        const Color(0xFFFEF2F2),
                        Icons.mark_email_unread_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Expanded(
                      child: _buildEnhancedStat(
                        'Aujourd\'hui',
                        '3',
                        const Color(0xFF3B82F6),
                        const Color(0xFFEFF6FF),
                        Icons.today_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Expanded(
                      child: _buildEnhancedStat(
                        'Cette semaine',
                        '12',
                        const Color(0xFF10B981),
                        const Color(0xFFF0FDF4),
                        Icons.date_range_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Modern Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildModernFilterTab('Toutes', true),
                    _buildModernFilterTab('Non lues', false),
                    _buildModernFilterTab('Bulletins', false),
                    _buildModernFilterTab('Notes', false),
                    _buildModernFilterTab('Devoirs', false),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notifications List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _mockNotifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = _mockNotifications[index];
                  return NotificationCard(notification: notification);
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStat(
    String label,
    String value,
    Color color,
    Color bgColor,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModernFilterTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          // Handle filter selection
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 12 : 8,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  void _markAllAsRead() {
    Get.snackbar(
      'Notifications',
      'Toutes les notifications ont été marquées comme lues',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  static final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': '1',
      'title': 'Nouveau bulletin disponible',
      'message':
          'Votre bulletin du 2ème trimestre est maintenant disponible pour consultation.',
      'type': 'bulletin',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'isUnread': true,
    },
    {
      'id': '2',
      'title': 'Note ajoutée',
      'message': 'Une nouvelle note a été ajoutée en Mathématiques: 16/20',
      'type': 'note',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isUnread': true,
    },
    {
      'id': '3',
      'title': 'Devoir à rendre',
      'message':
          'N\'oubliez pas de rendre votre devoir de Français pour demain.',
      'type': 'devoir',
      'time': DateTime.now().subtract(const Duration(hours: 4)),
      'isUnread': false,
    },
    {
      'id': '4',
      'title': 'Absence signalée',
      'message':
          'Votre absence du 15 janvier a été signalée par le professeur.',
      'type': 'absence',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isUnread': false,
    },
    {
      'id': '5',
      'title': 'Réunion parents-professeurs',
      'message':
          'La réunion parents-professeurs aura lieu le 25 janvier à 18h.',
      'type': 'info',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isUnread': false,
    },
    {
      'id': '6',
      'title': 'Bulletin consulté',
      'message': 'Votre bulletin du 1er trimestre a été consulté avec succès.',
      'type': 'bulletin',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isUnread': false,
    },
  ];
}
