import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portail_eleve/app/core/data/models/notification_model.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class NotificationsSection extends GetView<ParentHomeController> {
  const NotificationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final notifications = controller.notifications;

                if (notifications.isEmpty) {
                  return _buildEmptyNotificationsState();
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationItem(notification);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyNotificationsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppDesignSystem.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous serez notifié des nouveaux bulletins et messages',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppDesignSystem.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: AppDesignSystem.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.type ?? 'Notification',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppDesignSystem.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppDesignSystem.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(notification.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppDesignSystem.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'bulletin':
        return Icons.school;
      case 'message':
        return Icons.message;
      case 'event':
        return Icons.event;
      default:
        return Icons.info;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
