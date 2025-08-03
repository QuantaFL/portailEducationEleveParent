import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';
import 'package:portail_eleve/app/themes/palette_system.dart';

/// Generic profile header that works for any user type (Student, Parent, etc.)
/// Reuses the existing design from StudentProfileHeader but makes it flexible
class UserProfileHeader extends StatelessWidget {
  final UserModel user;
  final String? subtitle;
  final String? role;
  final VoidCallback? onNotificationTap;
  final bool showNotifications;

  const UserProfileHeader({
    Key? key,
    required this.user,
    this.subtitle,
    this.role,
    this.onNotificationTap,
    this.showNotifications = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, all: 0),
      padding: AppDesignSystem.responsivePadding(context, all: 20),
      decoration: BoxDecoration(
        gradient: AppDesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(
          AppDesignSystem.responsiveRadius(context, 20),
        ),
        boxShadow: AppDesignSystem.elevation(3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // User Avatar
              Container(
                width: AppDesignSystem.responsiveSize(context, 60),
                height: AppDesignSystem.responsiveSize(context, 60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppDesignSystem.textInverse,
                    width: 3,
                  ),
                  boxShadow: AppDesignSystem.elevation(2),
                ),
                child: CircleAvatar(
                  backgroundColor: AppDesignSystem.textInverse,
                  child: Text(
                    _getInitials(),
                    style: AppDesignSystem.textTheme(context).titleLarge
                        ?.copyWith(
                          color: AppDesignSystem.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),

              SizedBox(width: AppDesignSystem.spacing(context, 16)),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse.withValues(
                              alpha: 0.8,
                            ),
                          ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 4)),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: AppDesignSystem.textTheme(context).headlineLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 2)),
                    Text(
                      subtitle ?? 'Groupe Scolaire Quanta',
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse.withValues(
                              alpha: 0.9,
                            ),
                          ),
                    ),
                    if (role != null) ...[
                      SizedBox(height: AppDesignSystem.spacing(context, 2)),
                      Text(
                        role!,
                        style: AppDesignSystem.textTheme(context).bodyMedium
                            ?.copyWith(
                              color: AppDesignSystem.textInverse.withValues(
                                alpha: 0.7,
                              ),
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Notification Button
              if (showNotifications)
                GestureDetector(
                  onTap:
                      onNotificationTap ??
                      () => Get.toNamed(Routes.NOTIFICATIONS),
                  child: Container(
                    padding: AppDesignSystem.responsivePadding(
                      context,
                      all: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.textInverse.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppDesignSystem.responsiveRadius(context, 12),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppDesignSystem.textInverse,
                      size: AppDesignSystem.responsiveSize(context, 24),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    return (firstName.isNotEmpty ? firstName[0] : '') +
        (lastName.isNotEmpty ? lastName[0] : '');
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour,';
    if (hour < 18) return 'Bon après-midi,';
    return 'Bonsoir,';
  }
}
