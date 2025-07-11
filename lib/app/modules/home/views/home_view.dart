import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../../profile/views/about_view.dart';
import '../../profile/views/help_view.dart';
import '../../profile/views/personal_info_view.dart';
import '../../profile/views/security_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/bulletin_card.dart';
import '../widgets/student_profile_header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
              _buildDashboard(context),
              _buildHistory(context),
              _buildProfile(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.loadDashboardData,
        color: const Color(0xFF6366F1),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentProfileHeader(),

              const SizedBox(height: 32),

              _buildStatsOverview(context),

              const SizedBox(height: 32),

              _buildRecentBulletins(context),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header
          Text(
            'Aperçu',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Simple stats row
          Row(
            children: [
              Expanded(
                child: _buildSimpleStatItem(
                  '15.3',
                  'Moyenne',
                  AppDesignSystem.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimpleStatItem(
                  '1er',
                  'Classement',
                  AppDesignSystem.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimpleStatItem(
                  '3',
                  'Bulletins',
                  AppDesignSystem.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatItem(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppDesignSystem.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppDesignSystem.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBulletins(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Bulletins récents',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppDesignSystem.textPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tout',
                        style: GoogleFonts.inter(
                          color: AppDesignSystem.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppDesignSystem.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Obx(
          () => controller.isLoading.value
              ? _buildLoadingShimmer(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.recentBulletins.length > 3
                      ? 3
                      : controller.recentBulletins.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final bulletin = controller.recentBulletins[index];
                    return BulletinCard(
                      bulletin: bulletin,
                      onTap: () => controller.viewBulletin(bulletin['id']),
                      onDownload: () =>
                          controller.downloadBulletin(bulletin['id']),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
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
              'Historique des bulletins',
              style: AppDesignSystem.textTheme(context).headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppDesignSystem.textPrimary,
                  ),
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 16)),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Mock data
                itemBuilder: (context, index) {
                  final bulletinData = {
                    'title': 'Bulletin Trimestre ${index + 1}',
                    'periode': '2023-2024',
                    'status': 'Consulté',
                    'moyenne': (15.5 + index * 0.5).toString(),
                    'date': '${10 + index}/0${index + 1}/2024',
                  };
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppDesignSystem.spacing(context, 12),
                    ),
                    child: BulletinCard(
                      bulletin: bulletinData,
                      onTap: () => controller.viewBulletin(index.toString()),
                      onDownload: () =>
                          controller.downloadBulletin(index.toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: AppDesignSystem.responsivePadding(
            context,
            horizontal: 16,
            vertical: 8,
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Accueil'),
                _buildNavItem(1, Icons.history, 'Historique'),
                _buildNavItem(2, Icons.person, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
