import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class ChildDashboardContent extends GetView<ParentHomeController> {
  const ChildDashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.children.isEmpty) {
        return _buildEmptyState();
      }

      final selectedChild =
          controller.children[controller.selectedChildIndex.value];
      return _buildSelectedChildContent(selectedChild);
    });
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.family_restroom_outlined,
            size: 64,
            color: AppDesignSystem.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun enfant trouvé',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contactez l\'administration pour ajouter vos enfants',
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

  Widget _buildSelectedChildContent(dynamic selectedChild) {
    final childUser = selectedChild.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChildHeaderCard(selectedChild, childUser),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildChildHeaderCard(dynamic selectedChild, dynamic childUser) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppDesignSystem.primary,
            AppDesignSystem.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppDesignSystem.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStudentAvatar(childUser),
          const SizedBox(width: 20),
          _buildStudentInfo(selectedChild, childUser),
          _buildQuickActionButton(selectedChild),
        ],
      ),
    );
  }

  Widget _buildStudentAvatar(dynamic childUser) {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              childUser?.firstName?.substring(0, 1) ?? 'E',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Academic performance indicator
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getPerformanceColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(_getPerformanceIcon(), size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentInfo(dynamic selectedChild, dynamic childUser) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            childUser != null
                ? '${childUser.firstName} ${childUser.lastName}'
                : 'Élève',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.school,
                size: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                selectedChild.classId == 1 ? 'Terminale S' : '3ème B',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                'N° ${selectedChild.studentIdNumber}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(dynamic selectedChild) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => _showChildDetailsSheet(selectedChild),
        icon: Icon(Icons.more_vert, color: Colors.white, size: 20),
      ),
    );
  }

  Color _getPerformanceColor() {
    return controller.selectedChildIndex.value == 0
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);
  }

  IconData _getPerformanceIcon() {
    return controller.selectedChildIndex.value == 0
        ? Icons.trending_up
        : Icons.trending_flat;
  }

  void _showChildDetailsSheet(dynamic selectedChild) {
    final childUser = selectedChild.user;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChildSheetHeader(selectedChild, childUser),
            const SizedBox(height: 24),
            _buildActionTile(Icons.person_outline, 'Profil de l\'élève', () {
              Get.back();
              _showChildProfile(selectedChild);
            }),
            _buildActionTile(Icons.history, 'Historique des bulletins', () {
              Get.back();
              controller.goToBulletinHistory();
            }),
            _buildActionTile(Icons.email_outlined, 'Contacter l\'école', () {
              Get.back();
              _contactSchool(selectedChild);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSheetHeader(dynamic selectedChild, dynamic childUser) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
          child: Text(
            childUser?.firstName?.substring(0, 1) ?? 'E',
            style: GoogleFonts.inter(
              fontSize: 20,
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
                '${childUser?.firstName ?? ''} ${childUser?.lastName ?? ''}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppDesignSystem.textPrimary,
                ),
              ),
              Text(
                selectedChild.classId == 1 ? 'Terminale S' : '3ème B',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppDesignSystem.primary),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppDesignSystem.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppDesignSystem.textSecondary),
      onTap: onTap,
    );
  }

  void _showChildProfile(dynamic child) {
    // Implementation moved to separate widget for cleaner code
    Get.toNamed('/child-profile', arguments: child);
  }

  void _contactSchool(dynamic child) {
    // Implementation for contacting school
    Get.snackbar(
      'Contact',
      'Fonctionnalité de contact en développement',
      backgroundColor: AppDesignSystem.primary.withOpacity(0.1),
    );
  }
}
