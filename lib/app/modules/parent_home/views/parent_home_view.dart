import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/palette_system.dart';
import '../../profile/views/about_view.dart';
import '../../profile/views/help_view.dart';
import '../../profile/views/personal_info_view.dart';
import '../../profile/views/security_view.dart';
import '../controllers/parent_home_controller.dart';
import '../widgets/bulletins_section.dart';
import '../widgets/child_dashboard_content.dart';
import '../widgets/child_selector_tabs.dart';
import '../widgets/notifications_section.dart';
import '../widgets/parent_bottom_nav_bar.dart';
import '../widgets/parent_profile_header.dart';

class ParentHomeView extends GetView<ParentHomeController> {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.surfaceGradient,
        ),
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _buildParentDashboard(),
              const NotificationsSection(),
              _buildProfile(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ParentBottomNavBar(),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppDesignSystem.responsivePadding(
          context,
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mon profil',
              style: AppDesignSystem.textTheme(context).headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppDesignSystem.textPrimary,
                  ),
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 20)),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileItem(
                    context,
                    Icons.person,
                    'Informations personnelles',
                    'Nom, prénom, email, etc.',
                    () => Get.to(() => const PersonalInfoView()),
                  ),
                  _buildProfileItem(
                    context,
                    Icons.lock,
                    'Sécurité',
                    'Changer le mot de passe',
                    () => Get.to(() => const SecurityView()),
                  ),
                  _buildProfileItem(
                    context,
                    Icons.notifications,
                    'Notifications',
                    'Gérer les notifications',
                    () => Get.snackbar('Info', 'Notifications'),
                  ),
                  _buildProfileItem(
                    context,
                    Icons.help,
                    'Aide',
                    'FAQ et support',
                    () => Get.to(() => const HelpView()),
                  ),
                  _buildProfileItem(
                    context,
                    Icons.info,
                    'À propos',
                    'Version de l\'application',
                    () => Get.to(() => const AboutView()),
                  ),
                  SizedBox(height: AppDesignSystem.spacing(context, 20)),
                  _buildProfileItem(
                    context,
                    Icons.logout,
                    'Déconnexion',
                    'Se déconnecter du compte',
                    () => controller.logout(),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignSystem.spacing(context, 12)),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(
          AppDesignSystem.responsiveRadius(context, 12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: AppDesignSystem.responsivePadding(context, all: 8),
          decoration: BoxDecoration(
            color: (isDestructive ? Colors.red : Colors.blue).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(
              AppDesignSystem.responsiveRadius(context, 8),
            ),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildParentDashboard() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppDesignSystem.primary,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ParentProfileHeader(),

              const SizedBox(height: 24),

              const ChildSelectorTabs(),

              const SizedBox(height: 24),

              const ChildDashboardContent(),

              const SizedBox(height: 20),

              const BulletinsSection(),

              const SizedBox(height: 20),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
