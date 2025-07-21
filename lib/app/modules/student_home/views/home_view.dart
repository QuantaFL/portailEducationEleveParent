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
              _buildRecentBulletins(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBulletins(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Bulletins Récents',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppDesignSystem.textPrimary,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historique',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
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
                    padding: const EdgeInsets.only(bottom: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ProfileListItem(
                    icon: Icons.person_outline,
                    title: 'Informations Personnelles',
                    onTap: () => Get.to(() => const PersonalInfoView()),
                  ),
                  ProfileListItem(
                    icon: Icons.lock_outline,
                    title: 'Sécurité',
                    onTap: () => Get.to(() => const SecurityView()),
                  ),
                  ProfileListItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => Get.snackbar('Info', 'Notifications'),
                  ),
                  ProfileListItem(
                    icon: Icons.help_outline,
                    title: 'Aide et Support',
                    onTap: () => Get.to(() => const HelpView()),
                  ),
                  ProfileListItem(
                    icon: Icons.info_outline,
                    title: 'À Propos',
                    onTap: () => Get.to(() => const AboutView()),
                  ),
                  const SizedBox(height: 20),
                  ProfileListItem(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    onTap: () => controller.logout(),
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

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? Colors.red : AppDesignSystem.textPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isDestructive ? Colors.red : AppDesignSystem.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
