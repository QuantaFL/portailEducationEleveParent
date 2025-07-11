import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class ChildSelectorTabs extends GetView<ParentHomeController> {
  const ChildSelectorTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.children.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes enfants',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Clean card-based selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with count
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primary.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          color: AppDesignSystem.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${controller.children.length} enfant${controller.children.length > 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Children list
                  ...controller.children.asMap().entries.map((entry) {
                    final index = entry.key;
                    final child = entry.value;
                    final isSelected =
                        controller.selectedChildIndex.value == index;
                    final isLast = index == controller.children.length - 1;

                    return _buildChildItem(child, index, isSelected, isLast)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.3);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildChildItem(
    dynamic child,
    int index,
    bool isSelected,
    bool isLast,
  ) {
    final childUser = child.user;
    final className = child.classId == 1 ? 'Terminale S' : '3ème B';

    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.selectChild(index),
          borderRadius: BorderRadius.circular(isLast ? 20 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppDesignSystem.primary.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(isLast ? 20 : 0),
            ),
            child: Row(
              children: [
                // Avatar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDesignSystem.primary
                        : AppDesignSystem.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected
                        ? Border.all(
                            color: AppDesignSystem.primary.withOpacity(0.3),
                            width: 3,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      childUser?.firstName?.substring(0, 1) ?? 'E',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppDesignSystem.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childUser?.firstName ?? 'Élève',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppDesignSystem.primary
                              : AppDesignSystem.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        className,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options button
                PopupMenuButton<String>(
                  onSelected: (value) => _handleChildMenuAction(value, child),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('Voir le profil'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'contact',
                      child: Row(
                        children: [
                          Icon(Icons.school, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('Contacter l\'école'),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDesignSystem.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppDesignSystem.primary
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleChildMenuAction(String action, dynamic child) {
    switch (action) {
      case 'profile':
        _showChildProfile(child);
        break;
      case 'contact':
        _contactSchool(child);
        break;
    }
  }

  void _showChildProfile(dynamic child) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.9,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
                    child: Text(
                      child.user?.firstName?.substring(0, 1) ?? 'E',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppDesignSystem.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${child.user?.firstName ?? ''} ${child.user?.lastName ?? ''}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppDesignSystem.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          child.classId == 1 ? 'Terminale S' : '3ème B',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Profile Information
              _buildProfileInfo(
                'Numéro étudiant',
                child.studentIdNumber ?? 'N/A',
              ),
              _buildProfileInfo('Email', child.user?.email ?? 'N/A'),
              _buildProfileInfo('Téléphone', child.user?.phone ?? 'N/A'),
              _buildProfileInfo(
                'Date de naissance',
                child.user?.dateOfBirth ?? 'N/A',
              ),
              _buildProfileInfo('Adresse', child.user?.address ?? 'N/A'),
              _buildProfileInfo(
                'Date d\'inscription',
                child.enrollmentDate ?? 'N/A',
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _contactSchool(child),
                      icon: const Icon(Icons.school),
                      label: const Text('Contacter l\'école'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppDesignSystem.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppDesignSystem.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppDesignSystem.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _contactSchool(dynamic child) async {
    // Close profile dialog if open
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Connexion à l\'école...',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    Get.back();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.school, color: AppDesignSystem.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Contacter l\'école',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppDesignSystem.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Concernant: ${child.user?.firstName ?? 'Élève'}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppDesignSystem.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              // Contact options
              _buildContactOption(
                Icons.phone,
                'Téléphoner',
                '+33 1 23 45 67 89',
                () => _makePhoneCall('+33123456789'),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.email,
                'Envoyer un email',
                'contact@lycee-exemple.fr',
                () => _sendEmail('contact@lycee-exemple.fr', child),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.location_on,
                'Visiter l\'école',
                '123 Rue de l\'Éducation, 75001 Paris',
                () => _showSchoolLocation(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppDesignSystem.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppDesignSystem.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    Get.back();

    Get.snackbar(
      'Appel en cours',
      'Composition du numéro...',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
      colorText: AppDesignSystem.primary,
      duration: const Duration(seconds: 2),
    );

    await Future.delayed(const Duration(seconds: 1));

    Get.snackbar(
      'Appel',
      'Appel en cours vers l\'école',
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void _sendEmail(String email, dynamic child) async {
    Get.back();

    Get.snackbar(
      'Email',
      'Ouverture de l\'application email...',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
      colorText: AppDesignSystem.primary,
      duration: const Duration(seconds: 2),
    );

    await Future.delayed(const Duration(seconds: 1));

    Get.snackbar(
      'Email',
      'Email préparé pour ${child.user?.firstName ?? 'l\'élève'}',
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void _showSchoolLocation() async {
    Get.back();

    Get.snackbar(
      'Localisation',
      'Ouverture de la carte...',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
      colorText: AppDesignSystem.primary,
      duration: const Duration(seconds: 2),
    );

    await Future.delayed(const Duration(seconds: 1));

    Get.snackbar(
      'Localisation',
      'Localisation de l\'école affichée',
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }
}
