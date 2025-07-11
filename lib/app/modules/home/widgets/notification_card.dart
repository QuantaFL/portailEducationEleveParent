import 'package:flutter/material.dart';

import '../../../themes/palette_system.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({Key? key, required this.notification})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDesignSystem.cardDecoration(context, elevation: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _markAsRead(context),
          borderRadius: BorderRadius.circular(
            AppDesignSystem.responsiveRadius(context, 16),
          ),
          child: Padding(
            padding: AppDesignSystem.responsivePadding(context, all: 16),
            child: Row(
              children: [
                // Notification Icon - Simple Icon instead of Lottie
                Container(
                  width: AppDesignSystem.responsiveSize(context, 48),
                  height: AppDesignSystem.responsiveSize(context, 48),
                  decoration: BoxDecoration(
                    color: _getNotificationColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDesignSystem.responsiveRadius(context, 12),
                    ),
                    border: Border.all(
                      color: _getNotificationColor().withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getNotificationIcon(),
                    color: _getNotificationColor(),
                    size: 24,
                  ),
                ),

                SizedBox(width: AppDesignSystem.spacing(context, 16)),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] ?? 'Notification',
                              style: AppDesignSystem.textTheme(context)
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppDesignSystem.textPrimary,
                                  ),
                            ),
                          ),
                          if (notification['isUnread'] == true)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppDesignSystem.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppDesignSystem.spacing(context, 4)),
                      Text(
                        notification['message'] ??
                            'Nouvelle notification disponible',
                        style: AppDesignSystem.textTheme(context).bodySmall
                            ?.copyWith(
                              color: AppDesignSystem.textSecondary,
                              height: 1.4,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDesignSystem.spacing(context, 8)),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppDesignSystem.textTertiary,
                          ),
                          SizedBox(width: AppDesignSystem.spacing(context, 4)),
                          Text(
                            _formatTime(notification['time']),
                            style: AppDesignSystem.textTheme(context).labelSmall
                                ?.copyWith(color: AppDesignSystem.textTertiary),
                          ),
                          const Spacer(),
                          Container(
                            padding: AppDesignSystem.responsivePadding(
                              context,
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getNotificationColor().withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDesignSystem.responsiveRadius(context, 8),
                              ),
                            ),
                            child: Text(
                              _getTypeLabel(),
                              style: AppDesignSystem.textTheme(context)
                                  .labelSmall
                                  ?.copyWith(
                                    color: _getNotificationColor(),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor() {
    switch (notification['type']) {
      case 'bulletin':
        return AppDesignSystem.primary;
      case 'note':
        return AppDesignSystem.success;
      case 'devoir':
        return AppDesignSystem.warning;
      case 'absence':
        return AppDesignSystem.error;
      default:
        return AppDesignSystem.info;
    }
  }

  IconData _getNotificationIcon() {
    switch (notification['type']) {
      case 'bulletin':
        return Icons.description;
      case 'note':
        return Icons.grade;
      case 'devoir':
        return Icons.assignment;
      case 'absence':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String _getTypeLabel() {
    switch (notification['type']) {
      case 'bulletin':
        return 'Bulletin';
      case 'note':
        return 'Note';
      case 'devoir':
        return 'Devoir';
      case 'absence':
        return 'Absence';
      default:
        return 'Info';
    }
  }

  String _formatTime(dynamic time) {
    if (time == null) return 'Maintenant';
    if (time is String) return time;

    try {
      final notificationTime = time is DateTime
          ? time
          : DateTime.parse(time.toString());
      final now = DateTime.now();
      final difference = now.difference(notificationTime);

      if (difference.inMinutes < 1) {
        return 'Maintenant';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}min';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}j';
      } else {
        return 'Il y a plus d\'une semaine';
      }
    } catch (e) {
      return 'Récent';
    }
  }

  void _markAsRead(BuildContext context) {
    // TODO: Implement mark as read functionality
    // This would typically call an API to mark the notification as read
  }
}
