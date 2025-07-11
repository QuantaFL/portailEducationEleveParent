import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class ParentProfileSection extends GetView<ParentHomeController> {
  const ParentProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mon Profil',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
            child: Obx(() {
              final user = controller.currentParentUser.value;
              return Text(
                user?.firstName?.substring(0, 1) ?? 'P',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppDesignSystem.primary,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final user = controller.currentParentUser.value;
            return Column(
              children: [
                Text(
                  user != null
                      ? '${user.firstName} ${user.lastName}'
                      : 'Parent',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppDesignSystem.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppDesignSystem.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildProfileInfoGrid(user),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileInfoGrid(dynamic user) {
    return Column(
      children: [
        _buildProfileInfoTile('Téléphone', user?.phone ?? 'Non renseigné'),
        _buildProfileInfoTile('Adresse', user?.address ?? 'Non renseignée'),
        _buildProfileInfoTile(
          'Date de naissance',
          user?.dateOfBirth ?? 'Non renseignée',
        ),
        _buildProfileInfoTile(
          'Genre',
          user?.gender == 'M'
              ? 'Masculin'
              : user?.gender == 'F'
              ? 'Féminin'
              : 'Non renseigné',
        ),
      ],
    );
  }

  Widget _buildProfileInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppDesignSystem.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppDesignSystem.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            Icons.edit_outlined,
            'Modifier le profil',
            'Mettre à jour vos informations personnelles',
            () => _editProfile(),
          ),
          _buildSettingsTile(
            Icons.notifications_outlined,
            'Notifications',
            'Gérer les notifications',
            () => _manageNotifications(),
          ),
          // Navigate to existing settings for security, help, and about
          _buildSettingsTile(
            Icons.settings_outlined,
            'Paramètres avancés',
            'Sécurité, aide et à propos',
            () => Get.toNamed('/settings'),
          ),
          _buildSettingsTile(
            Icons.logout,
            'Se déconnecter',
            'Quitter l\'application',
            () => _logout(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppDesignSystem.primary,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : AppDesignSystem.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppDesignSystem.textSecondary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppDesignSystem.textSecondary),
      onTap: onTap,
    );
  }

  void _editProfile() {
    Get.snackbar(
      'Profil',
      'Fonctionnalité de modification du profil en développement',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
    );
  }

  void _manageNotifications() {
    Get.snackbar(
      'Notifications',
      'Paramètres de notification en développement',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
    );
  }

  void _logout() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Déconnexion',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppDesignSystem.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Navigate to auth/login instead of calling controller.logout()
              Get.offAllNamed('/auth/login');
            },
            child: Text(
              'Déconnecter',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
